import gleam/list
import gleam/result
import gleam/string
import hanguleam/core/assemble

import hanguleam/internal/constants.{
  choseongs, complete_hangul_start, jongseongs, jungseongs, number_of_jongseong,
  number_of_jungseong,
}
import hanguleam/internal/errors.{
  type DisassembleError, EmptyInput, IncompleteHangul, NonHangul,
}
import hanguleam/internal/types.{
  type HangulCharacter, type HangulSyllable, Choseong, ComplexBatchim,
  CompoundCV, CompoundCVC, CompoundComplexBatchim, HangulSyllable, Jamo,
  Jongseong, Jungseong, SimpleCV, SimpleCVC,
}
import hanguleam/internal/utils

pub fn disassemble(text: String) -> String {
  do_disassemble(text, "")
}

fn do_disassemble(text: String, accumulator: String) -> String {
  case string.pop_grapheme(text) {
    Ok(#(head, tail)) -> {
      let components = disassemble_char_to_groups(head) |> string.join("")
      do_disassemble(tail, accumulator <> components)
    }
    Error(_) -> accumulator
  }
}

pub fn disassemble_to_groups(text: String) -> List(List(String)) {
  do_disassemble_to_groups(text, []) |> list.reverse
}

fn do_disassemble_to_groups(
  text: String,
  accumulator: List(List(String)),
) -> List(List(String)) {
  case string.pop_grapheme(text) {
    Ok(#(head, tail)) -> {
      let group = disassemble_char_to_groups(head)
      do_disassemble_to_groups(tail, [group, ..accumulator])
    }
    Error(_) -> accumulator
  }
}

fn disassemble_char_to_groups(char: String) -> List(String) {
  case disassemble_complete_character(char) {
    Ok(syllable) -> syllable_to_components(syllable)
    Error(IncompleteHangul) -> disassemble_jamo(char)
    Error(NonHangul) -> [char]
    Error(EmptyInput) -> [char]
  }
}

fn syllable_to_components(syllable: HangulSyllable) -> List(String) {
  let HangulSyllable(Choseong(cho), Jungseong(jung), Jongseong(jong)) = syllable
  [cho]
  |> list.append(string.to_graphemes(jung))
  |> fn(base) {
    case jong {
      "" -> base
      _ -> list.append(base, string.to_graphemes(jong))
    }
  }
}

fn disassemble_jamo(char: String) -> List(String) {
  let jamo = {
    use codepoint <- result.try(utils.get_codepoint_result_from_char(char))

    case utils.is_jungseong_range(codepoint) {
      True -> Ok(constants.disassemble_vowel_string(char))
      False -> Ok(constants.disassemble_consonant_string(char))
    }
  }

  case jamo {
    Ok(components) -> string.split(components, "")
    Error(_) -> []
  }
}

pub fn disassemble_complete_character(
  char: String,
) -> Result(HangulSyllable, DisassembleError) {
  case char {
    "" -> Error(EmptyInput)
    _ -> {
      use codepoint <- result.try(
        utils.get_codepoint_result_from_char(char)
        |> result.map_error(fn(_) { NonHangul }),
      )

      case utils.is_complete_hangul(codepoint) {
        True -> parse_hangul_syllable(codepoint)
        False -> {
          case utils.is_hangul(codepoint) {
            True -> Error(IncompleteHangul)
            False -> Error(NonHangul)
          }
        }
      }
    }
  }
}

fn parse_hangul_syllable(
  codepoint_int: Int,
) -> Result(HangulSyllable, DisassembleError) {
  let base = codepoint_int - complete_hangul_start

  let choseong_idx = base / { number_of_jungseong * number_of_jongseong }

  let jungseong_idx =
    base % { number_of_jungseong * number_of_jongseong } / number_of_jongseong

  let jongseong_idx = base % number_of_jongseong

  use choseong <- result.try(
    utils.get_value_by_index(choseong_idx, choseongs)
    |> result.map_error(fn(_) { NonHangul }),
  )
  use jungseong <- result.try(
    utils.get_value_by_index(jungseong_idx, jungseongs)
    |> result.map_error(fn(_) { NonHangul }),
  )
  use jongseong <- result.try(
    utils.get_value_by_index(jongseong_idx, jongseongs)
    |> result.map_error(fn(_) { NonHangul }),
  )

  let jungseong = constants.disassemble_vowel_string(jungseong)
  let jongseong = constants.disassemble_consonant_string(jongseong)

  Ok(HangulSyllable(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(jongseong),
  ))
}

pub fn remove_last_character(text: String) -> String {
  case string.last(text) {
    Error(_) -> text
    Ok(last_char) -> remove_character_component(text, last_char)
  }
}

fn remove_character_component(text: String, last_char: String) -> String {
  let prefix = string.drop_end(text, 1)

  last_char
  |> disassemble_complete_character
  |> result.map(syllable_to_disassembled_char)
  |> result.map(reduce_syllable)
  |> result.unwrap("")
  |> string.append(prefix, _)
}

fn reduce_syllable(disassembled: HangulCharacter) -> String {
  case disassembled {
    SimpleCV(Choseong(cho), _) -> cho
    CompoundCV(Choseong(cho), Jungseong(jung)) -> {
      assemble.combine_character_unsafe(cho, string.slice(jung, 0, 1), "")
    }
    SimpleCVC(Choseong(cho), Jungseong(jung), Jongseong(_)) -> {
      assemble.combine_character_unsafe(cho, jung, "")
    }
    CompoundCVC(Choseong(cho), Jungseong(jung), Jongseong(_)) -> {
      assemble.combine_character_unsafe(cho, jung, "")
    }
    ComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong)) -> {
      assemble.combine_character_unsafe(cho, jung, string.slice(jong, 0, 1))
    }
    CompoundComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong)) -> {
      assemble.combine_character_unsafe(cho, jung, string.slice(jong, 0, 1))
    }
    Jamo(_) -> ""
  }
}

fn syllable_to_disassembled_char(syllable: HangulSyllable) -> HangulCharacter {
  let HangulSyllable(Choseong(cho), Jungseong(jung), Jongseong(jong)) = syllable

  case jong, is_compound_vowel(jung), is_compound_consonant(jong) {
    "", False, _ -> SimpleCV(Choseong(cho), Jungseong(jung))
    "", True, _ -> CompoundCV(Choseong(cho), Jungseong(jung))
    _, False, False ->
      SimpleCVC(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, True, False ->
      CompoundCVC(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, False, True ->
      ComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, True, True ->
      CompoundComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong))
  }
}

fn is_compound_vowel(vowel: String) -> Bool {
  string.length(vowel) > 1
}

fn is_compound_consonant(consonant: String) -> Bool {
  string.length(consonant) > 1
}
