import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import hanguleam/internal/unicode.{
  complete_hangul_start, disassemble_consonant_string,
  get_codepoint_result_from_char, is_complete_hangul, jongseongs,
  number_of_jongseong,
}
import hanguleam/internal/utils
import hanguleam/types.{
  type BatchimInfo, type BatchimType, Double, NoBatchim, Single,
}

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

/// Extracts detailed batchim information from the last character of a Korean string.
/// Returns comprehensive information about the batchim including its type and components.
/// This is an enhanced version that provides more detail than `has_batchim`.
///
/// ## Return Value
///
/// - `Ok(BatchimInfo)`: Contains character, batchim type, and component breakdown
/// - `Error(EmptyString)`: Input string is empty
/// - `Error(InvalidCharacter(char))`: Last character is not complete Hangul
///
/// ## Examples
///
/// ```gleam
/// get_batchim("강")
/// // -> Ok(BatchimInfo(character: "강", batchim_type: Single, components: ["ㅇ"]))
/// 
/// get_batchim("값")
/// // -> Ok(BatchimInfo(character: "값", batchim_type: Double, components: ["ㅂ", "ㅅ"]))
/// 
/// get_batchim("가")
/// // -> Ok(BatchimInfo(character: "가", batchim_type: NoBatchim, components: []))
/// 
/// get_batchim("hello")
/// // -> Error(InvalidCharacter("o"))
/// 
/// get_batchim("")
/// // -> Error(EmptyString)
/// 
/// get_batchim("한글")
/// // -> Ok(BatchimInfo(character: "글", batchim_type: Single, components: ["ㄹ"]))
/// ```
pub fn get_batchim(text: String) -> Result(BatchimInfo, BatchimError) {
  use char <- result.try(
    string.last(text) |> result.map_error(fn(_) { EmptyString }),
  )

  use codepoint <- result.try(
    get_codepoint_result_from_char(char)
    |> result.map_error(fn(_) { InvalidCharacter(char) }),
  )

  case is_complete_hangul(codepoint) {
    False -> Error(InvalidCharacter(char))
    True -> {
      let batchim_index = get_batchim_index(codepoint)
      use batchim <- result.try(
        utils.get_value_by_index(batchim_index, jongseongs)
        |> result.map_error(fn(_) { InvalidCharacter(char) }),
      )
      let components =
        batchim |> disassemble_consonant_string |> string.to_graphemes
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

/// Checks if the last character of a Korean string has a batchim (final consonant).
/// Returns `False` for empty strings, non-Korean characters, or incomplete Hangul.
///
/// ## Examples
///
/// ```gleam
/// has_batchim("값")
/// // -> True
/// 
/// has_batchim("토")
/// // -> False
/// 
/// has_batchim("hello")
/// // -> False
/// ```
pub fn has_batchim(text: String) -> Bool {
  has_batchim_with_options(text, None)
}

/// Checks if the last character of a Korean string has a batchim (final consonant) with filtering options.
/// Returns `False` for empty strings, non-Korean characters, or incomplete Hangul.
/// 
/// ## Options
/// 
/// - `None`: Checks for any batchim (single or double)
/// - `Some(HasBatchimOptions(only: Some(SingleOnly)))`: Only single batchim
/// - `Some(HasBatchimOptions(only: Some(DoubleOnly)))`: Only double batchim
///
/// ## Examples
///
/// ```gleam
/// import hanguleam/batchim.{HasBatchimOptions, SingleOnly, DoubleOnly}
/// import gleam/option.{None, Some}
/// 
/// has_batchim_with_options("값", None)
/// // -> True
/// 
/// has_batchim_with_options("갑", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> True
/// 
/// has_batchim_with_options("값", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> False (값 has double batchim ㅂ+ㅅ)
/// 
/// has_batchim_with_options("값", Some(HasBatchimOptions(only: Some(DoubleOnly))))
/// // -> True
/// ```
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
