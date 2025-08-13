import gleam/list
import gleam/string
import hanguleam/internal/unicode.{
  complete_hangul_end, complete_hangul_start, hangul_jamo_end, hangul_jamo_start,
  jungseong_end, jungseong_start, modern_jamo_end, modern_jamo_start,
}

pub fn is_complete_hangul(codepoint: Int) -> Bool {
  complete_hangul_start <= codepoint && codepoint <= complete_hangul_end
}

/// Detects modern Hangul jamo (U+1100-U+11FF) - combining forms
pub fn is_modern_jamo(codepoint: Int) -> Bool {
  modern_jamo_start <= codepoint && codepoint <= modern_jamo_end
}

/// Detects compatibility Hangul jamo (U+3131-U+3163) - standalone forms  
pub fn is_compatibility_jamo(codepoint: Int) -> Bool {
  hangul_jamo_start <= codepoint && codepoint <= hangul_jamo_end
}

/// Detects any Hangul jamo (both modern and compatibility forms)
pub fn is_hangul_alphabet(codepoint: Int) -> Bool {
  is_modern_jamo(codepoint) || is_compatibility_jamo(codepoint)
}

/// Detects vowels within compatibility jamo range (U+314F-U+3163)
pub fn is_jungseong_range(codepoint: Int) -> Bool {
  codepoint >= jungseong_start && codepoint <= jungseong_end
}

/// Detects any Hangul character (complete syllables + any jamo)
pub fn is_hangul(codepoint: Int) -> Bool {
  is_complete_hangul(codepoint) || is_hangul_alphabet(codepoint)
}

pub fn get_codepoint_result_from_char(char: String) -> Result(Int, Nil) {
  case string.to_utf_codepoints(char) |> list.first {
    Ok(codepoint) -> Ok(string.utf_codepoint_to_int(codepoint))
    Error(_) -> Error(Nil)
  }
}

pub fn get_value_by_index(
  index: Int,
  value_list: List(String),
) -> Result(String, Nil) {
  value_list |> list.drop(index) |> list.first
}

pub fn find_index(list: List(a), target: a) -> Result(Int, Nil) {
  list
  |> list.index_fold(Error(Nil), fn(acc, item, index) {
    case acc {
      Ok(_) -> acc
      Error(_) if item == target -> Ok(index)
      Error(_) -> acc
    }
  })
}
