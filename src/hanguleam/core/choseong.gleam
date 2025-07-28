import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import hanguleam/internal/constants.{
  choseongs, complete_hangul_start, number_of_jongseong, number_of_jungseong,
}
import hanguleam/internal/utils

pub fn get_choseong(word: String) -> String {
  do_get_choseong(word, "")
}

fn do_get_choseong(word: String, accumulator: String) -> String {
  case string.pop_grapheme(word) {
    Ok(#(head, tail)) -> {
      let extracted = case head {
        " " -> " "
        "\t" -> "\t"
        "\n" -> "\n"
        _ ->
          case extract_choseong_from_char(head) {
            Some(choseong) -> choseong
            None -> ""
          }
      }
      do_get_choseong(tail, accumulator <> extracted)
    }
    Error(_) -> accumulator
  }
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
