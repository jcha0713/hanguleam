import gleam/dict
import gleam/list
import gleam/option.{Some}
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

pub fn disassemble_complete_character(
  char: String,
) -> Result(HangulSyllable, DisassembleError) {
  case char {
    "" -> Error(EmptyInput)
    _ -> {
      let codepoint_int = utils.get_codepoint_value_from_char(char)
      case utils.is_complete_hangul(codepoint_int) {
        True -> do_disassemble(codepoint_int)
        False -> {
          case utils.is_hangul(codepoint_int) {
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

  let assert Some(choseong) = utils.get_value_by_index(choseong_idx, choseongs)
  let assert Some(jungseong) =
    utils.get_value_by_index(jungseong_idx, jungseongs)
  let assert Some(jongseong) =
    utils.get_value_by_index(jongseong_idx, jongseongs)

  let components = case dict.get(constants.get_jongseong_data(), jongseong) {
    Ok(data) -> data.components
    Error(_) -> []
  }

  Ok(HangulSyllable(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(string.join(components, "")),
  ))
}
