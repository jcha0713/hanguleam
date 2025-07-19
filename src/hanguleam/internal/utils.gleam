import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import hanguleam/internal/constants.{complete_hangul_end, complete_hangul_start}

pub fn is_complete_hangul(codepoint: Int) -> Bool {
  complete_hangul_start <= codepoint && codepoint <= complete_hangul_end
}

pub fn get_codepoint_value_from_char(char: String) -> Option(Int) {
  case string.to_utf_codepoints(char) {
    [codepoint] -> Some(string.utf_codepoint_to_int(codepoint))
    _ -> None
  }
}

pub fn get_value_by_index(
  index: Int,
  value_list: List(String),
) -> Option(String) {
  case index >= 0 && index < list.length(value_list) {
    True -> value_list |> list.drop(index) |> list.first |> option.from_result
    False -> None
  }
}
