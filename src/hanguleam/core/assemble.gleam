import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import hanguleam/internal/character
import hanguleam/internal/types

import hanguleam/core/validate
import hanguleam/internal/constants.{
  complete_hangul_start, number_of_jongseong, number_of_jungseong,
}
import hanguleam/internal/utils

pub fn combine_vowels(vowel1: String, vowel2: String) -> String {
  constants.assemble_vowel_string(vowel1 <> vowel2)
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

pub fn combine_character(
  choseong choseong: String,
  jungseong jungseong: String,
  jongseong jongseong: String,
) -> Result(String, AssembleError) {
  let jungseong = constants.assemble_vowel_string(jungseong)
  let jongseong = constants.assemble_consonant_string(jongseong)

  case
    validate.can_be_choseong(choseong),
    validate.can_be_jungseong(jungseong),
    validate.can_be_jongseong(jongseong)
  {
    True, True, True -> Ok(do_combine(choseong, jungseong, jongseong))
    False, _, _ -> Error(InvalidChoseong(choseong))
    _, False, _ -> Error(InvalidJungseong(jungseong))
    _, _, False -> Error(InvalidJongseong(jongseong))
  }
}

fn do_combine(choseong: String, jungseong: String, jongseong: String) -> String {
  let result = {
    use choseong_idx <- result.try(utils.find_index(
      constants.choseongs,
      choseong,
    ))
    use jungseong_idx <- result.try(utils.find_index(
      constants.jungseongs,
      jungseong,
    ))
    use jongseong_idx <- result.try(utils.find_index(
      constants.jongseongs,
      jongseong,
    ))

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

pub fn assemble(fragments: List(String)) -> String {
  case fragments {
    [] -> ""
    [single] -> single
    multiple ->
      multiple
      |> list.fold(#("", types.Empty), process_fragment)
      |> pair.first
  }
}

fn process_fragment(
  acc: #(String, types.CharacterType),
  fragment: String,
) -> #(String, types.CharacterType) {
  let #(accumulated, last_state) = acc
  let next_char_type = get_first_char_type(fragment)

  case last_state, next_char_type {
    types.IncompleteHangul(last_jamo), types.IncompleteHangul(first_jamo) -> {
      let combined = try_combine_jamos(last_jamo, first_jamo)

      let new_text =
        string.drop_end(accumulated, 1)
        <> combined
        <> string.drop_start(fragment, 1)
      let new_state = get_last_char_type(new_text)

      #(new_text, new_state)
    }
    types.CompleteHangul(syllable), types.IncompleteHangul(jamo) -> {
      let extended = try_extend_syllable(syllable, jamo)

      let new_text = string.drop_end(accumulated, 1) <> extended
      let new_state = get_last_char_type(extended)
      #(new_text, new_state)
    }
    _, _ -> {
      let new_text = accumulated <> fragment
      let new_state = get_last_char_type(new_text)
      #(new_text, new_state)
    }
  }
}

fn try_extend_syllable(
  syllable: types.HangulSyllable,
  jamo: types.Jamo,
) -> String {
  let parsed = character.parse_hangul_syllable(syllable)

  case parsed, jamo {
    types.SimpleCV(types.Choseong(cho), types.Jungseong(jung)),
      types.Consonant(consonant)
    -> {
      case validate.can_be_jongseong(consonant) {
        True -> combine_character_unsafe(cho, jung, consonant)
        False -> combine_character_unsafe(cho, jung, "") <> consonant
      }
    }
    types.SimpleCV(types.Choseong(cho), types.Jungseong(jung)),
      types.Vowel(vowel)
    -> {
      let maybe_vowel = jung <> vowel
      case validate.can_be_jungseong(maybe_vowel) {
        True -> combine_character_unsafe(cho, maybe_vowel, "")
        False -> combine_character_unsafe(cho, jung, "") <> vowel
      }
    }
    types.CompoundCV(types.Choseong(cho), types.Jungseong(jung)),
      types.Consonant(consonant)
    -> {
      case validate.can_be_jongseong(consonant) {
        True -> combine_character_unsafe(cho, jung, consonant)
        False -> combine_character_unsafe(cho, jung, "") <> consonant
      }
    }
    types.CompoundCV(types.Choseong(cho), types.Jungseong(jung)),
      types.Vowel(vowel)
    -> {
      let maybe_vowel = jung <> vowel
      case validate.can_be_jungseong(maybe_vowel) {
        True -> combine_character_unsafe(cho, maybe_vowel, "")
        False -> combine_character_unsafe(cho, jung, "") <> maybe_vowel
      }
    }
    types.SimpleCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Vowel(vowel)
    -> {
      case validate.can_be_choseong(jong) {
        True ->
          combine_character_unsafe(cho, jung, "")
          <> combine_character_unsafe(jong, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    }
    types.CompoundCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Vowel(vowel)
    -> {
      case validate.can_be_choseong(jong) {
        True ->
          combine_character_unsafe(cho, jung, "")
          <> combine_character_unsafe(jong, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    }
    types.SimpleCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Consonant(consonant)
    -> {
      let maybe_complex_batchim = jong <> consonant
      case validate.can_be_jongseong(maybe_complex_batchim) {
        True -> combine_character_unsafe(cho, jung, maybe_complex_batchim)
        False -> combine_character_unsafe(cho, jung, jong) <> consonant
      }
    }
    types.CompoundCVC(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Consonant(consonant)
    -> {
      let maybe_complex_batchim = jong <> consonant
      case validate.can_be_jongseong(maybe_complex_batchim) {
        True -> combine_character_unsafe(cho, jung, maybe_complex_batchim)
        False -> combine_character_unsafe(cho, jung, jong) <> consonant
      }
    }
    types.ComplexBatchim(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Vowel(vowel)
    -> {
      let first = string.slice(jong, 1, 1)
      let last = string.slice(jong, 0, 1)
      case validate.can_be_choseong(first) {
        True ->
          combine_character_unsafe(cho, jung, last)
          <> combine_character_unsafe(first, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    }
    types.CompoundComplexBatchim(
      types.Choseong(cho),
      types.Jungseong(jung),
      types.Jongseong(jong),
    ),
      types.Vowel(vowel)
    -> {
      case validate.can_be_choseong(jong) {
        True ->
          combine_character_unsafe(cho, jung, "")
          <> combine_character_unsafe(jong, vowel, "")
        False -> combine_character_unsafe(cho, jung, jong) <> vowel
      }
    }
    _, _ -> {
      let syllable_str = syllable_to_string(syllable)
      let jamo_str = jamo_to_string(jamo)
      syllable_str <> jamo_str
    }
  }
}

fn jamo_to_string(jamo: types.Jamo) -> String {
  case jamo {
    types.Consonant(s) -> s
    types.Vowel(s) -> s
  }
}

fn syllable_to_string(syllable: types.HangulSyllable) -> String {
  let types.HangulSyllable(
    types.Choseong(cho),
    types.Jungseong(jung),
    types.Jongseong(jong),
  ) = syllable
  combine_character_unsafe(cho, jung, jong)
}

fn try_combine_jamos(last: types.Jamo, first: types.Jamo) -> String {
  case last, first {
    types.Consonant(consonant), types.Vowel(vowel) -> {
      case validate.can_be_choseong(consonant) {
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

fn get_first_char_type(text: String) -> types.CharacterType {
  case string.first(text) {
    Ok(first_char) -> character.get_character_type(first_char)
    Error(_) -> types.Empty
  }
}

fn get_last_char_type(text: String) -> types.CharacterType {
  case string.last(text) {
    Ok(last_char) -> character.get_character_type(last_char)
    Error(_) -> types.Empty
  }
}
