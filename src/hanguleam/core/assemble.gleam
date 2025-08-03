import gleam/result
import gleam/string

import hanguleam/core/validate
import hanguleam/internal/constants.{
  complete_hangul_start, number_of_jongseong, number_of_jungseong,
}
import hanguleam/internal/utils

pub fn combine_vowels(vowel1: String, vowel2: String) -> String {
  let combination = vowel1 <> vowel2

  case constants.assemble_vowel_string(combination) {
    Ok(assembled) -> assembled
    Error(_) -> combination
  }
}

pub type AssembleError {
  InvalidChoseong(String)
  InvalidJungseong(String)
  InvalidJongseong(String)
}

pub fn combine_character(
  choseong choseong: String,
  jungseong jungseong: String,
  jongseong jongseong: String,
) -> Result(String, AssembleError) {
  case
    validate.can_be_choseong(choseong),
    validate.can_be_jungseong(jungseong),
    validate.can_be_jongseong(jongseong)
  {
    True, True, True -> Ok(do_combine(choseong, jungseong, jongseong))
    False, _, _ -> Error(InvalidChoseong(choseong))
    _, False, _ -> Error(InvalidJungseong(jungseong))
    _, _, False -> Error(InvalidJongseong(jongseong))
  }
}

fn do_combine(choseong: String, jungseong: String, jongseong: String) -> String {
  let result = {
    use choseong_idx <- result.try(utils.find_index(
      constants.choseongs,
      choseong,
    ))
    use jungseong_idx <- result.try(utils.find_index(
      constants.jungseongs,
      jungseong,
    ))
    use jongseong_idx <- result.try(utils.find_index(
      constants.jongseongs,
      jongseong,
    ))

    Ok(#(choseong_idx, jungseong_idx, jongseong_idx))
  }

  case result {
    Ok(#(cho, jung, jong)) -> {
      let codepoint_int =
        complete_hangul_start
        + cho
        * number_of_jungseong
        * number_of_jongseong
        + jung
        * number_of_jongseong
        + jong

      case string.utf_codepoint(codepoint_int) {
        Ok(codepoint) -> string.from_utf_codepoints([codepoint])
        Error(_) -> ""
      }
    }
    Error(_) -> ""
  }
}
