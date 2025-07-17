import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import hanguleam/internal/constants.{complete_hangul_start, number_of_jongseong}
import hanguleam/internal/utils

pub fn has_batchim(text: String) {
  get_last_character(text)
  |> option.then(utils.get_codepoint_value_from_char)
  |> option.then(fn(codepoint_int) {
    case utils.is_complete_hangul(codepoint_int) {
      True -> Some(get_batchim_index(codepoint_int) != 0)
      False -> None
    }
  })
  |> option.unwrap(False)
}

fn get_last_character(text: String) -> Option(String) {
  text |> string.to_graphemes |> list.last |> option.from_result
}

fn get_batchim_index(codepoint: Int) -> Int {
  { codepoint - complete_hangul_start } % number_of_jongseong
}
