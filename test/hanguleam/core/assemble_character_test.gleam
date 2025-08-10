import startest/expect
import hanguleam/core/assemble

// === VOWEL COMBINATION TESTS ===

pub fn combine_vowels_valid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅏ")
  |> expect.to_equal("ㅘ")

  assemble.combine_vowels("ㅗ", "ㅐ")
  |> expect.to_equal("ㅙ")

  assemble.combine_vowels("ㅗ", "ㅣ")
  |> expect.to_equal("ㅚ")

  assemble.combine_vowels("ㅜ", "ㅓ")
  |> expect.to_equal("ㅝ")

  assemble.combine_vowels("ㅜ", "ㅔ")
  |> expect.to_equal("ㅞ")

  assemble.combine_vowels("ㅜ", "ㅣ")
  |> expect.to_equal("ㅟ")

  assemble.combine_vowels("ㅡ", "ㅣ")
  |> expect.to_equal("ㅢ")
}

pub fn combine_vowels_invalid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅛ")
  |> expect.to_equal("ㅗㅛ")

  assemble.combine_vowels("ㅏ", "ㅓ")
  |> expect.to_equal("ㅏㅓ")

  assemble.combine_vowels("ㅣ", "ㅏ")
  |> expect.to_equal("ㅣㅏ")

  assemble.combine_vowels("ㅜ", "ㅏ")
  |> expect.to_equal("ㅜㅏ")
}

pub fn combine_vowels_single_vowels_test() {
  assemble.combine_vowels("ㅏ", "")
  |> expect.to_equal("ㅏ")

  assemble.combine_vowels("", "ㅓ")
  |> expect.to_equal("ㅓ")

  assemble.combine_vowels("", "")
  |> expect.to_equal("")
}

pub fn combine_vowels_complex_vowel_combinations_test() {
  // Test vowel combinations that form complex vowels
  assemble.combine_vowels("ㅗ", "ㅏ")
  |> expect.to_equal("ㅘ")

  assemble.combine_vowels("ㅜ", "ㅓ")
  |> expect.to_equal("ㅝ")

  assemble.combine_vowels("ㅡ", "ㅣ")
  |> expect.to_equal("ㅢ")
}

pub fn combine_vowels_edge_cases_test() {
  // Test with already combined vowels
  assemble.combine_vowels("ㅘ", "")
  |> expect.to_equal("ㅘ")

  assemble.combine_vowels("", "ㅢ")
  |> expect.to_equal("ㅢ")
}

// === CHARACTER COMBINATION TESTS ===

pub fn combine_character_valid_test() {
  assemble.combine_character("ㄱ", "ㅏ", "")
  |> expect.to_equal(Ok("가"))

  assemble.combine_character("ㄴ", "ㅏ", "ㄴ")
  |> expect.to_equal(Ok("난"))
}

pub fn combine_character_invalid_choseong_test() {
  assemble.combine_character("ㅏ", "ㅏ", "")
  |> expect.to_equal(Error(assemble.InvalidChoseong("ㅏ")))
}

pub fn combine_character_invalid_jungseong_test() {
  assemble.combine_character("ㄱ", "ㄱ", "")
  |> expect.to_equal(Error(assemble.InvalidJungseong("ㄱ")))
}

pub fn combine_character_invalid_jongseong_test() {
  assemble.combine_character("ㄱ", "ㅏ", "ㅏ")
  |> expect.to_equal(Error(assemble.InvalidJongseong("ㅏ")))
}

pub fn combine_character_first_characters_test() {
  assemble.combine_character("ㄱ", "ㅏ", "ㄱ")
  |> expect.to_equal(Ok("각"))
}

pub fn combine_character_last_characters_test() {
  assemble.combine_character("ㅎ", "ㅣ", "ㅎ")
  |> expect.to_equal(Ok("힣"))
}

pub fn combine_character_complex_vowel_empty_jongseong_test() {
  assemble.combine_character("ㄱ", "ㅘ", "")
  |> expect.to_equal(Ok("과"))

  assemble.combine_character("ㄱ", "ㅗㅏ", "")
  |> expect.to_equal(Ok("과"))
}

pub fn combine_character_complex_test() {
  assemble.combine_character("ㄱ", "ㅘ", "ㄼ")
  |> expect.to_equal(Ok("괇"))

  assemble.combine_character("ㄱ", "ㅗㅏ", "ㄹㅂ")
  |> expect.to_equal(Ok("괇"))
}

// === UNSAFE CHARACTER COMBINATION TESTS ===

pub fn combine_character_unsafe_valid_test() {
  assemble.combine_character_unsafe("ㄱ", "ㅏ", "")
  |> expect.to_equal("가")

  assemble.combine_character_unsafe("ㄴ", "ㅏ", "ㄴ")
  |> expect.to_equal("난")

  assemble.combine_character_unsafe("ㄱ", "ㅘ", "ㄼ")
  |> expect.to_equal("괇")

  assemble.combine_character_unsafe("ㅎ", "ㅣ", "ㅎ")
  |> expect.to_equal("힣")
}