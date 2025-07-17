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
