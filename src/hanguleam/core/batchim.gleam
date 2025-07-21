import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import hanguleam/internal/constants.{
  complete_hangul_start, get_batchim_data, jongseongs, number_of_jongseong,
}
import hanguleam/internal/utils

pub type BatchimType {
  NoBatchim
  Single
  Double
}

pub type BatchimOnlyFilter {
  SingleOnly
  DoubleOnly
}

pub type BatchimInfo {
  BatchimInfo(
    character: String,
    batchim_type: BatchimType,
    components: List(String),
  )
}

pub type BatchimError {
  EmptyString
  InvalidCharacter(String)
}

pub type HasBatchimOptions {
  HasBatchimOptions(only: Option(BatchimOnlyFilter))
}

pub fn get_batchim(text: String) -> Result(BatchimInfo, BatchimError) {
  use char <- result.try(
    get_last_character(text) |> option.to_result(EmptyString),
  )

  let codepoint_int = utils.get_codepoint_value_from_char(char)

  case utils.is_complete_hangul(codepoint_int) {
    False -> Error(InvalidCharacter(char))
    True -> {
      let batchim_index = get_batchim_index(codepoint_int)
      let batchim_type = get_batchim_type(batchim_index)
      let components = get_batchim_components(batchim_index)

      Ok(BatchimInfo(
        character: char,
        batchim_type: batchim_type,
        components: components,
      ))
    }
  }
}

pub fn has_batchim(text: String) -> Bool {
  has_batchim_with_options(text, None)
}

pub fn has_batchim_with_options(
  text: String,
  options options: Option(HasBatchimOptions),
) -> Bool {
  let filter = case options {
    None -> None
    Some(HasBatchimOptions(only: filter)) -> filter
  }

  case get_batchim(text) {
    Ok(info) -> filter_batchim(info.batchim_type, filter)
    Error(_) -> False
  }
}

fn get_batchim_type(batchim_index: Int) -> BatchimType {
  case batchim_index {
    0 -> NoBatchim
    _ ->
      case get_batchim_length(batchim_index) {
        1 -> Single
        2 -> Double
        _ -> NoBatchim
      }
  }
}

fn filter_batchim(
  batchim_type: BatchimType,
  filter: Option(BatchimOnlyFilter),
) -> Bool {
  case filter {
    None -> batchim_type != NoBatchim
    Some(SingleOnly) -> batchim_type == Single
    Some(DoubleOnly) -> batchim_type == Double
  }
}

fn get_batchim_components(batchim_index: Int) -> List(String) {
  case utils.get_value_by_index(batchim_index, jongseongs) {
    Some(char) ->
      case dict.get(get_batchim_data(), char) {
        Ok(info) -> info.components
        Error(_) -> []
      }
    None -> []
  }
}

fn get_batchim_length(batchim_index: Int) -> Int {
  get_batchim_components(batchim_index) |> list.length
}

fn get_last_character(text: String) -> Option(String) {
  text |> string.to_graphemes |> list.last |> option.from_result
}

fn get_batchim_index(codepoint: Int) -> Int {
  { codepoint - complete_hangul_start } % number_of_jongseong
}
