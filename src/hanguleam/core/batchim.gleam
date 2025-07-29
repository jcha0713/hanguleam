import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import hanguleam/internal/constants.{
  complete_hangul_start, jongseongs, number_of_jongseong,
}
import hanguleam/internal/types.{
  type BatchimInfo, type BatchimType, Double, NoBatchim, Single,
}
import hanguleam/internal/utils

pub type BatchimOnlyFilter {
  SingleOnly
  DoubleOnly
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
    string.last(text) |> result.map_error(fn(_) { EmptyString }),
  )

  use codepoint <- result.try(
    utils.get_codepoint_result_from_char(char)
    |> result.map_error(fn(_) { InvalidCharacter(char) }),
  )

  case utils.is_complete_hangul(codepoint) {
    False -> Error(InvalidCharacter(char))
    True -> {
      let batchim_index = get_batchim_index(codepoint)
      use batchim <- result.try(
        utils.get_value_by_index(batchim_index, jongseongs)
        |> result.map_error(fn(_) { InvalidCharacter(char) }),
      )
      use components <- result.try(
        constants.disassemble_consonant_string(batchim)
        |> result.map(string.to_graphemes)
        |> result.map_error(fn(_) { InvalidCharacter(char) }),
      )
      let batchim_type = get_batchim_type(components)

      Ok(types.BatchimInfo(
        character: char,
        batchim_type:,
        batchim:,
        components:,
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

fn get_batchim_type(components: List(String)) -> BatchimType {
  case list.length(components) {
    1 -> Single
    2 -> Double
    _ -> NoBatchim
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

fn get_batchim_index(codepoint: Int) -> Int {
  { codepoint - complete_hangul_start } % number_of_jongseong
}
