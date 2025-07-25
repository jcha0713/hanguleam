import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import hanguleam/internal/constants.{
  choseongs, complete_hangul_start, number_of_jongseong, number_of_jungseong,
}
import hanguleam/internal/utils

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
  case utils.get_codepoint_result_from_char(char) {
    Ok(codepoint) -> {
      case utils.is_complete_hangul(codepoint) {
        True -> get_choseong_codepoint(codepoint) |> get_choseong_by_index
        False -> None
      }
    }
    Error(_) -> None
  }
}

fn get_choseong_by_index(index: Int) -> Option(String) {
  utils.get_value_by_index(index, choseongs)
}

fn get_choseong_codepoint(codepoint: Int) -> Int {
  let base = codepoint - complete_hangul_start
  base / { number_of_jungseong * number_of_jongseong }
}
