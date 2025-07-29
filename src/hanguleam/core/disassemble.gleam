import gleam/list
import gleam/result
import gleam/string

import hanguleam/internal/constants.{
  choseongs, complete_hangul_start, jongseongs, jungseongs, number_of_jongseong,
  number_of_jungseong,
}
import hanguleam/internal/types.{
  type HangulSyllable, Choseong, HangulSyllable, Jongseong, Jungseong,
}
import hanguleam/internal/utils

pub type DisassembleError {
  IncompleteHangul
  NonHangul
  EmptyInput
}

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
  |> list.append(disassemble_jamo(jung))
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
      True -> constants.disassemble_vowel_string(char)
      False -> constants.disassemble_consonant_string(char)
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

  let disassembled_jongseong = disassemble_jamo(jongseong)

  Ok(HangulSyllable(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(string.join(disassembled_jongseong, "")),
  ))
}
