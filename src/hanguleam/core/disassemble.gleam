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

pub fn disassemble_to_groups(text: String) {
  text |> string.to_graphemes |> list.map(disassemble_char_to_groups)
}

fn disassemble_char_to_groups(char: String) {
  let codepoint = utils.get_codepoint_value_from_char(char)

  case utils.is_complete_hangul(codepoint) {
    True -> {
      case disassemble_complete_character(char) {
        Ok(HangulSyllable(Choseong(cho), Jungseong(jung), Jongseong(jong))) -> {
          let base_components = [cho] |> list.append(disassemble_jamo(jung))
          case jong {
            "" -> base_components
            _ -> list.append(base_components, string.to_graphemes(jong))
          }
        }
        Error(_) -> [char]
      }
    }
    False -> {
      case utils.is_hangul(codepoint) {
        True -> disassemble_jamo(char)
        False -> [char]
      }
    }
  }
}

fn disassemble_jamo(char: String) {
  let jamo_data = case
    char |> utils.get_codepoint_value_from_char |> utils.is_jungseong_range
  {
    True -> constants.get_jungseong_data()
    False -> constants.get_jongseong_data()
  }

  case dict.get(jamo_data, char) {
    Ok(data) -> data.components
    Error(_) -> []
  }
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

  let disassembled_jongseong = disassemble_jamo(jongseong)

  Ok(HangulSyllable(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(string.join(disassembled_jongseong, "")),
  ))
}
