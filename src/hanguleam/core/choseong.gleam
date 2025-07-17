import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

// 가
pub const complete_hangul_start = 0xAC00

// 힣
pub const complete_hangul_end = 0xD7A3

pub const number_of_jongseong = 28

pub const number_of_jungseong = 21

pub const choseongs = [
  "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ",
  "ㅌ", "ㅍ", "ㅎ",
]

pub fn get_choseong(word: String) -> String {
  word
  |> string.to_graphemes
  |> list.filter_map(fn(char) {
    case char {
      " " -> Ok(" ")
      "\t" -> Ok("\t")
      "\n" -> Ok("\n")
      _ ->
        case extract_choseong_from_char(char) {
          Some(choseong) -> Ok(choseong)
          None -> Error(Nil)
        }
    }
  })
  |> string.concat
}

fn extract_choseong_from_char(char: String) -> Option(String) {
  case list.contains(choseongs, char) {
    True -> Some(char)
    False -> extract_from_complete_hangul(char)
  }
}

fn extract_from_complete_hangul(char: String) {
  case string.to_utf_codepoints(char) {
    [codepoint] -> {
      let codepoint_int = string.utf_codepoint_to_int(codepoint)
      case is_complete_hangul(codepoint_int) {
        True -> get_choseong_codepoint(codepoint_int) |> get_choseong_by_index
        False -> None
      }
    }
    _ -> None
  }
}

fn get_choseong_by_index(index: Int) -> Option(String) {
  case index >= 0 && index < list.length(choseongs) {
    True -> choseongs |> list.drop(index) |> list.first |> option.from_result
    False -> None
  }
}

fn get_choseong_codepoint(codepoint: Int) -> Int {
  let base = codepoint - complete_hangul_start
  base / { number_of_jungseong * number_of_jongseong }
}

fn is_complete_hangul(codepoint: Int) -> Bool {
  complete_hangul_start <= codepoint && codepoint <= complete_hangul_end
}
