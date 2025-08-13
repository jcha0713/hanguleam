import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import hanguleam/internal/character
import hanguleam/types

import hanguleam/internal/unicode.{
  assemble_consonant_string, assemble_vowel_string, choseongs,
  complete_hangul_start, jongseongs, jungseongs, number_of_jongseong,
  number_of_jungseong,
}
import hanguleam/internal/utils
import hanguleam/validator

/// Combines two Korean vowels into a single complex vowel if possible.
///
/// ## Examples
///
/// ```gleam
/// combine_vowels("ㅗ", "ㅏ")
/// // -> "ㅘ"
///
/// combine_vowels("ㅣ", "ㅏ")
/// // -> "ㅣㅏ" (no combination possible)
/// ```
pub fn combine_vowels(vowel1: String, vowel2: String) -> String {
  assemble_vowel_string(vowel1 <> vowel2)
}

pub type AssembleError {
  InvalidChoseong(String)
  InvalidJungseong(String)
  InvalidJongseong(String)
}

pub fn combine_character_unsafe(
  cho: String,
  jung: String,
  jong: String,
) -> String {
  case combine_character(cho, jung, jong) {
    Ok(combined) -> combined
    Error(InvalidChoseong(invalid)) -> {
      let msg =
        "Internal error: invalid choseong '"
        <> invalid
        <> "' from validated syllable"
      panic as msg
    }
    Error(InvalidJungseong(invalid)) -> {
      let msg =
        "Internal error: invalid jungseong '"
        <> invalid
        <> "' from validated syllable"
      panic as msg
    }
    Error(InvalidJongseong(invalid)) -> {
      let msg =
        "Internal error: invalid jongseong '"
        <> invalid
        <> "' from validated syllable"
      panic as msg
    }
  }
}

/// Combines Korean jamo components into a complete Hangul syllable.
///
/// ## Examples
///
/// ```gleam
/// combine_character(choseong: "ㄱ", jungseong: "ㅏ", jongseong: "")
/// // -> Ok("가")
///
/// combine_character(choseong: "ㄲ", jungseong: "ㅠ", jongseong: "ㅇ")
/// // -> Ok("뀽")
/// ```
pub fn combine_character(
  choseong choseong: String,
  jungseong jungseong: String,
  jongseong jongseong: String,
) -> Result(String, AssembleError) {
  let jungseong = assemble_vowel_string(jungseong)
  let jongseong = assemble_consonant_string(jongseong)

  case
    validator.can_be_choseong(choseong),
    validator.can_be_jungseong(jungseong),
    validator.can_be_jongseong(jongseong)
  {
    True, True, True -> Ok(do_combine(choseong, jungseong, jongseong))
    False, _, _ -> Error(InvalidChoseong(choseong))
    _, False, _ -> Error(InvalidJungseong(jungseong))
    _, _, False -> Error(InvalidJongseong(jongseong))
  }
}

fn do_combine(choseong: String, jungseong: String, jongseong: String) -> String {
  let result = {
    use choseong_idx <- result.try(utils.find_index(choseongs, choseong))
    use jungseong_idx <- result.try(utils.find_index(jungseongs, jungseong))
    use jongseong_idx <- result.try(utils.find_index(jongseongs, jongseong))

    Ok(#(choseong_idx, jungseong_idx, jongseong_idx))
  }

  case result {
    Ok(#(cho, jung, jong)) -> {
      let codepoint_int =
        complete_hangul_start
        + cho
        * number_of_jungseong
        * number_of_jongseong
        + jung
        * number_of_jongseong
        + jong

      case string.utf_codepoint(codepoint_int) {
        Ok(codepoint) -> string.from_utf_codepoints([codepoint])
        Error(_) -> ""
      }
    }
    Error(_) -> ""
  }
}

/// Assembles Korean text fragments by intelligently combining characters.
/// Processes fragments according to Korean linguistic rules including 
/// consonant-vowel combinations and Korean linking (연음).
///
/// ## Examples
///
/// ```gleam
/// assemble(["ㄱ", "ㅏ", "ㅂ"])
/// // -> "갑"
///
/// assemble(["안녕하", "ㅅ", "ㅔ", "요"])
/// // -> "안녕하세요"
///
/// assemble(["뀽", "ㅏ"])
/// // -> "뀨아"
/// ```
pub fn assemble(fragments: List(String)) -> String {
  fragments
  |> list.fold(#("", types.Empty), merge_fragments)
  |> pair.first
}

fn merge_fragments(
  acc: #(String, types.CharacterType),
  fragment: String,
) -> #(String, types.CharacterType) {
  let #(accumulated, last_state) = acc
  let next_char_type = get_char_type_at(fragment, string.first)

  case last_state, next_char_type {
    types.IncompleteHangul(last_jamo), types.IncompleteHangul(first_jamo) -> {
      let combined = try_combine_jamos(last_jamo, first_jamo)

      let new_text =
        string.drop_end(accumulated, 1)
        <> combined
        <> string.drop_start(fragment, 1)
      let new_state = get_char_type_at(new_text, string.last)

      #(new_text, new_state)
    }
    types.CompleteHangul(syllable), types.IncompleteHangul(jamo) -> {
      let extended = try_extend_syllable(syllable, jamo)

      let new_text = string.drop_end(accumulated, 1) <> extended
      let new_state = get_char_type_at(extended, string.last)
      #(new_text, new_state)
    }
    _, _ -> {
      let new_text = accumulated <> fragment
      let new_state = get_char_type_at(new_text, string.last)
      #(new_text, new_state)
    }
  }
}

fn try_extend_syllable(
  syllable: types.HangulSyllable,
  jamo: types.Jamo,
) -> String {
  let parsed = character.parse_hangul_syllable(syllable)

  case parsed {
    // Syllables without batchim (CV patterns)
    types.SimpleCV(types.Choseong(cho), types.Jungseong(jung)) ->
      extend_syllable_without_batchim(cho, jung, jamo)
    types.CompoundCV(types.Choseong(cho), types.Jungseong(jung)) ->
      extend_syllable_without_batchim(cho, jung, jamo)

    // Syllables with batchim (CVC patterns)
    types.SimpleCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ) -> extend_syllable_with_batchim(cho, jung, jong, jamo)
    types.CompoundCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ) -> extend_syllable_with_batchim(cho, jung, jong, jamo)

    // Complex batchim cases
    types.ComplexBatchim(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ) -> extend_complex_batchim_syllable(cho, jung, jong, jamo)
    types.CompoundComplexBatchim(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ) -> extend_syllable_with_batchim(cho, jung, jong, jamo)
  }
}

fn extend_syllable_without_batchim(
  cho: String,
  jung: String,
  jamo: types.Jamo,
) -> String {
  case jamo {
    types.Consonant(consonant) ->
      case validator.can_be_jongseong(consonant) {
        True -> combine_character_unsafe(cho, jung, consonant)
        False -> combine_character_unsafe(cho, jung, "") <> consonant
      }
    types.Vowel(vowel) -> {
      let extended_vowel = jung <> vowel
      case validator.can_be_jungseong(extended_vowel) {
        True -> combine_character_unsafe(cho, extended_vowel, "")
        False -> combine_character_unsafe(cho, jung, "") <> vowel
      }
    }
  }
}

fn extend_syllable_with_batchim(
  cho: String,
  jung: String,
  jong: String,
  jamo: types.Jamo,
) -> String {
  case jamo {
    types.Vowel(vowel) ->
      case validator.can_be_choseong(jong) {
        True ->
          combine_character_unsafe(cho, jung, "")
          <> combine_character_unsafe(jong, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    types.Consonant(consonant) -> {
      let complex_batchim = jong <> consonant
      case validator.can_be_jongseong(complex_batchim) {
        True -> combine_character_unsafe(cho, jung, complex_batchim)
        False -> combine_character_unsafe(cho, jung, jong) <> consonant
      }
    }
  }
}

fn extend_complex_batchim_syllable(
  cho: String,
  jung: String,
  jong: String,
  jamo: types.Jamo,
) -> String {
  case jamo {
    types.Vowel(vowel) -> {
      let leading_consonant = string.slice(jong, 0, 1)
      let tailing_consonant = string.slice(jong, 1, 1)
      case validator.can_be_choseong(tailing_consonant) {
        True ->
          combine_character_unsafe(cho, jung, leading_consonant)
          <> combine_character_unsafe(tailing_consonant, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    }
    types.Consonant(consonant) ->
      combine_character_unsafe(cho, jung, jong) <> consonant
  }
}

fn try_combine_jamos(last: types.Jamo, first: types.Jamo) -> String {
  case last, first {
    types.Consonant(consonant), types.Vowel(vowel) -> {
      case validator.can_be_choseong(consonant) {
        True -> combine_character_unsafe(consonant, vowel, "")
        False -> consonant <> vowel
      }
    }
    types.Vowel(v1), types.Vowel(v2) -> {
      let combined = combine_vowels(v1, v2)
      case string.length(combined) == 1 {
        True -> combined
        False -> v1 <> v2
      }
    }
    types.Vowel(v1), types.Consonant(c1) -> v1 <> c1
    types.Consonant(c1), types.Consonant(c2) -> c1 <> c2
  }
}

fn get_char_type_at(text: String, position: fn(String) -> Result(String, Nil)) {
  text
  |> position
  |> result.map(character.get_character_type)
  |> result.unwrap(types.Empty)
}
