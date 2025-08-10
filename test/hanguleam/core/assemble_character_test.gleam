import gleeunit/should
import hanguleam/core/assemble

// === VOWEL COMBINATION TESTS ===

pub fn combine_vowels_valid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅏ")
  |> should.equal("ㅘ")

  assemble.combine_vowels("ㅗ", "ㅐ")
  |> should.equal("ㅙ")

  assemble.combine_vowels("ㅗ", "ㅣ")
  |> should.equal("ㅚ")

  assemble.combine_vowels("ㅜ", "ㅓ")
  |> should.equal("ㅝ")

  assemble.combine_vowels("ㅜ", "ㅔ")
  |> should.equal("ㅞ")

  assemble.combine_vowels("ㅜ", "ㅣ")
  |> should.equal("ㅟ")

  assemble.combine_vowels("ㅡ", "ㅣ")
  |> should.equal("ㅢ")
}

pub fn combine_vowels_invalid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅛ")
  |> should.equal("ㅗㅛ")

  assemble.combine_vowels("ㅏ", "ㅓ")
  |> should.equal("ㅏㅓ")

  assemble.combine_vowels("ㅣ", "ㅏ")
  |> should.equal("ㅣㅏ")

  assemble.combine_vowels("ㅜ", "ㅏ")
  |> should.equal("ㅜㅏ")
}

pub fn combine_vowels_single_vowels_test() {
  assemble.combine_vowels("ㅏ", "")
  |> should.equal("ㅏ")

  assemble.combine_vowels("", "ㅓ")
  |> should.equal("ㅓ")

  assemble.combine_vowels("", "")
  |> should.equal("")
}

pub fn combine_vowels_complex_vowel_combinations_test() {
  // Test vowel combinations that form complex vowels
  assemble.combine_vowels("ㅗ", "ㅏ")
  |> should.equal("ㅘ")

  assemble.combine_vowels("ㅜ", "ㅓ")
  |> should.equal("ㅝ")

  assemble.combine_vowels("ㅡ", "ㅣ")
  |> should.equal("ㅢ")
}

pub fn combine_vowels_edge_cases_test() {
  // Test with already combined vowels
  assemble.combine_vowels("ㅘ", "")
  |> should.equal("ㅘ")

  assemble.combine_vowels("", "ㅢ")
  |> should.equal("ㅢ")
}

// === CHARACTER COMBINATION TESTS ===

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

// === UNSAFE CHARACTER COMBINATION TESTS ===

pub fn combine_character_unsafe_valid_test() {
  assemble.combine_character_unsafe("ㄱ", "ㅏ", "")
  |> should.equal("가")

  assemble.combine_character_unsafe("ㄴ", "ㅏ", "ㄴ")
  |> should.equal("난")

  assemble.combine_character_unsafe("ㄱ", "ㅘ", "ㄼ")
  |> should.equal("괇")

  assemble.combine_character_unsafe("ㅎ", "ㅣ", "ㅎ")
  |> should.equal("힣")
}