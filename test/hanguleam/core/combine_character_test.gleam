import gleeunit/should
import hanguleam/core/assemble

pub fn combine_character_valid_test() {
  assemble.combine_character("ㄱ", "ㅏ", "")
  |> should.equal(Ok("가"))

  assemble.combine_character("ㄴ", "ㅏ", "ㄴ")
  |> should.equal(Ok("난"))
}

pub fn combine_character_invalid_choseong_test() {
  assemble.combine_character("ㅏ", "ㅏ", "")
  |> should.equal(Error(assemble.InvalidChoseong("ㅏ")))
}

pub fn combine_character_invalid_jungseong_test() {
  assemble.combine_character("ㄱ", "ㄱ", "")
  |> should.equal(Error(assemble.InvalidJungseong("ㄱ")))
}

pub fn combine_character_invalid_jongseong_test() {
  assemble.combine_character("ㄱ", "ㅏ", "ㅏ")
  |> should.equal(Error(assemble.InvalidJongseong("ㅏ")))
}

pub fn combine_character_first_characters_test() {
  assemble.combine_character("ㄱ", "ㅏ", "ㄱ")
  |> should.equal(Ok("각"))
}

pub fn combine_character_last_characters_test() {
  assemble.combine_character("ㅎ", "ㅣ", "ㅎ")
  |> should.equal(Ok("힣"))
}

pub fn combine_character_complex_vowel_empty_jongseong_test() {
  assemble.combine_character("ㄱ", "ㅘ", "")
  |> should.equal(Ok("과"))

  assemble.combine_character("ㄱ", "ㅗㅏ", "")
  |> should.equal(Ok("과"))
}

pub fn combine_character_complex_test() {
  assemble.combine_character("ㄱ", "ㅘ", "ㄼ")
  |> should.equal(Ok("괇"))

  assemble.combine_character("ㄱ", "ㅗㅏ", "ㄹㅂ")
  |> should.equal(Ok("괇"))
}
