import startest/expect
import hanguleam/core/disassemble

// === BASIC FUNCTIONALITY TESTS ===

pub fn disassemble_to_groups_simple_characters_test() {
  // Test simple characters without compound jamo
  let result = disassemble.disassemble_to_groups("사과")
  result |> expect.to_equal([["ㅅ", "ㅏ"], ["ㄱ", "ㅗ", "ㅏ"]])
}

pub fn disassemble_to_groups_complex_jongseong_test() {
  // Test character with complex jongseong
  let result = disassemble.disassemble_to_groups("값")
  result |> expect.to_equal([["ㄱ", "ㅏ", "ㅂ", "ㅅ"]])
}

pub fn disassemble_to_groups_mixed_characters_test() {
  // Test mixed complete characters and jamo
  let result = disassemble.disassemble_to_groups("가ㅘㄵ")
  result |> expect.to_equal([["ㄱ", "ㅏ"], ["ㅗ", "ㅏ"], ["ㄴ", "ㅈ"]])
}

// === COMPOUND VOWEL TESTS ===

pub fn disassemble_to_groups_compound_vowel_test() {
  // Test compound vowel ㅘ → [ㅗ, ㅏ]
  let result = disassemble.disassemble_to_groups("ㅘ")
  result |> expect.to_equal([["ㅗ", "ㅏ"]])
}

pub fn disassemble_to_groups_various_compound_vowels_test() {
  // Test various compound vowels
  let result1 = disassemble.disassemble_to_groups("ㅙ")
  result1 |> expect.to_equal([["ㅗ", "ㅐ"]])

  let result2 = disassemble.disassemble_to_groups("ㅚ")
  result2 |> expect.to_equal([["ㅗ", "ㅣ"]])

  let result3 = disassemble.disassemble_to_groups("ㅝ")
  result3 |> expect.to_equal([["ㅜ", "ㅓ"]])

  let result4 = disassemble.disassemble_to_groups("ㅞ")
  result4 |> expect.to_equal([["ㅜ", "ㅔ"]])

  let result5 = disassemble.disassemble_to_groups("ㅟ")
  result5 |> expect.to_equal([["ㅜ", "ㅣ"]])

  let result6 = disassemble.disassemble_to_groups("ㅢ")
  result6 |> expect.to_equal([["ㅡ", "ㅣ"]])
}

// === COMPOUND CONSONANT TESTS ===

pub fn disassemble_to_groups_compound_consonant_test() {
  // Test compound consonant ㄵ → [ㄴ, ㅈ]
  let result = disassemble.disassemble_to_groups("ㄵ")
  result |> expect.to_equal([["ㄴ", "ㅈ"]])
}

pub fn disassemble_to_groups_various_compound_consonants_test() {
  // Test various compound consonants
  let result1 = disassemble.disassemble_to_groups("ㄳ")
  result1 |> expect.to_equal([["ㄱ", "ㅅ"]])

  let result2 = disassemble.disassemble_to_groups("ㄶ")
  result2 |> expect.to_equal([["ㄴ", "ㅎ"]])

  let result3 = disassemble.disassemble_to_groups("ㄺ")
  result3 |> expect.to_equal([["ㄹ", "ㄱ"]])

  let result4 = disassemble.disassemble_to_groups("ㄻ")
  result4 |> expect.to_equal([["ㄹ", "ㅁ"]])

  let result5 = disassemble.disassemble_to_groups("ㅄ")
  result5 |> expect.to_equal([["ㅂ", "ㅅ"]])
}

// === EDGE CASES ===

pub fn disassemble_to_groups_empty_string_test() {
  // Test empty string
  let result = disassemble.disassemble_to_groups("")
  result |> expect.to_equal([])
}

pub fn disassemble_to_groups_non_hangul_test() {
  // Test non-Hangul characters (should return as-is)
  let result = disassemble.disassemble_to_groups("a1!")
  result |> expect.to_equal([["a"], ["1"], ["!"]])
}

pub fn disassemble_to_groups_mixed_content_test() {
  // Test mixed Hangul and non-Hangul content
  let result = disassemble.disassemble_to_groups("안녕 world!")
  result
  |> expect.to_equal([
    ["ㅇ", "ㅏ", "ㄴ"],
    ["ㄴ", "ㅕ", "ㅇ"],
    [" "],
    ["w"],
    ["o"],
    ["r"],
    ["l"],
    ["d"],
    ["!"],
  ])
}
