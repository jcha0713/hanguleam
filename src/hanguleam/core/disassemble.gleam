import gleam/list
import gleam/option
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
  text |> disassemble_to_groups |> list.flatten |> string.join("")
}

pub fn disassemble_to_groups(text: String) -> List(List(String)) {
  text |> string.to_graphemes |> list.map(disassemble_char_to_groups)
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
  case utils.get_codepoint_result_from_char(char) {
    Ok(codepoint) -> {
      let components = case utils.is_jungseong_range(codepoint) {
        True -> constants.disassemble_vowel_string(char)
        False -> constants.disassemble_consonant_string(char)
      }

      case components {
        Ok(data) -> string.to_graphemes(data)
        Error(_) -> []
      }
    }
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
        True -> do_disassemble(codepoint)
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

fn do_disassemble(
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
