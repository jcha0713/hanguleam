import gleam/list
import gleam/option.{type Option, None}
import gleam/string
import hanguleam/internal/constants.{
  complete_hangul_end, complete_hangul_start, hangul_jamo_end, hangul_jamo_start,
  jungseong_end, jungseong_start,
}

pub fn is_complete_hangul(codepoint: Int) -> Bool {
  complete_hangul_start <= codepoint && codepoint <= complete_hangul_end
}

pub fn is_hangul_alphabet(codepoint: Int) -> Bool {
  hangul_jamo_start <= codepoint && codepoint <= hangul_jamo_end
}

pub fn is_jungseong_range(codepoint: Int) -> Bool {
  codepoint >= jungseong_start && codepoint <= jungseong_end
}

pub fn is_hangul(codepoint: Int) -> Bool {
  is_complete_hangul(codepoint) || is_hangul_alphabet(codepoint)
}

pub fn get_codepoint_value_from_char(char: String) -> Int {
  case string.to_utf_codepoints(char) |> list.first {
    Ok(codepoint) -> string.utf_codepoint_to_int(codepoint)
    Error(_) -> 0
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
