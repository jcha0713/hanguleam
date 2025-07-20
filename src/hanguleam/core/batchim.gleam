import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import hanguleam/internal/constants.{
  complete_hangul_start, get_jongseong_info, jongseongs, number_of_jongseong,
}
import hanguleam/internal/utils

pub type BatchimFilter {
  Any
  Single
  Double
}

pub type HasBatchimOptions {
  HasBatchimOptions(only: Option(BatchimFilter))
}

pub fn has_batchim(
  text: String,
  options options: Option(HasBatchimOptions),
) -> Bool {
  let filter = case options {
    None -> None
    Some(HasBatchimOptions(only: filter)) -> filter
  }

  get_last_character(text)
  |> option.then(utils.get_codepoint_value_from_char)
  |> option.then(get_batchim_index_if_complete_hangul)
  |> option.map(fn(batchim_index) { check_batchim(batchim_index, filter) })
  |> option.unwrap(False)
}

fn check_batchim(batchim_index: Int, filter: Option(BatchimFilter)) {
  case batchim_index {
    0 -> False
    _ ->
      case filter {
        Some(Single) -> is_single_batchim(batchim_index)
        Some(Double) -> is_double_batchim(batchim_index)
        _ -> True
      }
  }
}

fn get_batchim_length(batchim_index: Int) -> Int {
  case utils.get_value_by_index(batchim_index, jongseongs) {
    Some(char) ->
      case dict.get(get_jongseong_info(), char) {
        Ok(info) -> list.length(info.components)
        Error(_) -> 0
      }
    None -> 0
  }
}

fn is_single_batchim(batchim_index: Int) {
  get_batchim_length(batchim_index) == 1
}

fn is_double_batchim(batchim_index: Int) {
  get_batchim_length(batchim_index) == 2
}

fn get_batchim_index_if_complete_hangul(codepoint_int: Int) {
  case utils.is_complete_hangul(codepoint_int) {
    True -> Some(get_batchim_index(codepoint_int))
    False -> None
  }
}

fn get_last_character(text: String) -> Option(String) {
  text |> string.to_graphemes |> list.last |> option.from_result
}

fn get_batchim_index(codepoint: Int) -> Int {
  { codepoint - complete_hangul_start } % number_of_jongseong
}
