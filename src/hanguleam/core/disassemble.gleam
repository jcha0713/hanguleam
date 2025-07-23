import gleam/option
import gleam/result
import hanguleam/internal/constants.{
  choseongs, complete_hangul_start, jongseongs, jungseongs, number_of_jongseong,
  number_of_jungseong,
}
import hanguleam/internal/types.{
  type CompleteCharacterComponents, Choseong, CompleteCharacterComponents,
  Jongseong, Jungseong,
}
import hanguleam/internal/utils

pub fn disassemble(char: String) {
  let codepoint_int = utils.get_codepoint_value_from_char(char)
  case utils.is_complete_hangul(codepoint_int) {
    False -> Error("")
    True -> do_disassemble(codepoint_int)
  }
}

fn do_disassemble(
  codepoint_int: Int,
) -> Result(CompleteCharacterComponents, String) {
  let base = codepoint_int - complete_hangul_start

  let choseong_idx = base / { number_of_jungseong * number_of_jongseong }

  let jungseong_idx =
    base % { number_of_jungseong * number_of_jongseong } / number_of_jongseong

  let jongseong_idx = base % number_of_jongseong

  use choseong <- result.try(
    utils.get_value_by_index(choseong_idx, choseongs)
    |> option.to_result("No Choseong"),
  )
  use jungseong <- result.try(
    utils.get_value_by_index(jungseong_idx, jungseongs)
    |> option.to_result("No jungseong"),
  )
  use jongseong <- result.try(
    utils.get_value_by_index(jongseong_idx, jongseongs)
    |> option.to_result("No jongseong"),
  )

  Ok(CompleteCharacterComponents(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(jongseong),
  ))
}
