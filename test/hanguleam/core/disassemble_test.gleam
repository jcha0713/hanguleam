import gleam/list
import gleam/string
import gleeunit/should
import hanguleam/core/disassemble

// === BASIC FUNCTIONALITY TESTS ===

pub fn disassemble_simple_characters_test() {
  // Test simple characters without compound jamo
  let result = disassemble.disassemble("사과")
  result |> should.equal("ㅅㅏㄱㅗㅏ")
}

pub fn disassemble_single_character_test() {
  // Test single complete character
  let result = disassemble.disassemble("가")
  result |> should.equal("ㄱㅏ")
}

pub fn disassemble_character_with_jongseong_test() {
  // Test character with simple jongseong
  let result = disassemble.disassemble("간")
  result |> should.equal("ㄱㅏㄴ")
}

pub fn disassemble_complex_jongseong_test() {
  // Test character with complex jongseong that decomposes
  let result = disassemble.disassemble("값")
  result |> should.equal("ㄱㅏㅂㅅ")
}

// === STANDALONE JAMO TESTS (Critical for catching choseong bug) ===

pub fn disassemble_standalone_choseong_basic_test() {
  // Test basic choseong characters
  let result = disassemble.disassemble("ㄱㄴㄷㄸ")
  result |> should.equal("ㄱㄴㄷㄸ")
}

pub fn disassemble_standalone_choseong_all_test() {
  // Test all choseong characters
  let result = disassemble.disassemble("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
  result |> should.equal("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
}

pub fn disassemble_standalone_jungseong_basic_test() {
  // Test basic jungseong characters
  let result = disassemble.disassemble("ㅏㅓㅗㅜ")
  result |> should.equal("ㅏㅓㅗㅜ")
}

pub fn disassemble_standalone_jungseong_all_test() {
  // Test all jungseong characters
  let result = disassemble.disassemble("ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ")
  result |> should.equal("ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅗㅏㅗㅐㅗㅣㅛㅜㅜㅓㅜㅔㅜㅣㅠㅡㅡㅣㅣ")
}

pub fn disassemble_standalone_jongseong_basic_test() {
  // Test basic jongseong characters (excluding empty)
  let result = disassemble.disassemble("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ")
  result |> should.equal("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ")
}

pub fn disassemble_standalone_jongseong_complex_test() {
  // Test complex jongseong that should decompose
  let result = disassemble.disassemble("ㄳㄵㄶㄺㄻㄼㄽㄾㄿㅀㅄ")
  result |> should.equal("ㄱㅅㄴㅈㄴㅎㄹㄱㄹㅁㄹㅂㄹㅅㄹㅌㄹㅍㄹㅎㅂㅅ")
}

// === MIXED JAMO TESTS ===

pub fn disassemble_mixed_all_jamo_types_test() {
  // Test mixing choseong, jungseong, and jongseong
  let result = disassemble.disassemble("ㄱㅏㄴㅗㅘㄵ")
  result |> should.equal("ㄱㅏㄴㅗㅗㅏㄴㅈ")
}

pub fn disassemble_mixed_complete_and_jamo_test() {
  // Test complete characters mixed with individual jamo
  let result = disassemble.disassemble("가ㄱㅏㄴ간")
  result |> should.equal("ㄱㅏㄱㅏㄴㄱㅏㄴ")
}

// === COMPOUND VOWEL TESTS ===

pub fn disassemble_compound_vowel_wa_test() {
  // Test compound vowel ㅘ → ㅗㅏ
  let result = disassemble.disassemble("과")
  result |> should.equal("ㄱㅗㅏ")
}

pub fn disassemble_compound_vowel_wae_test() {
  // Test compound vowel ㅙ → ㅗㅐ
  let result = disassemble.disassemble("괘")
  result |> should.equal("ㄱㅗㅐ")
}

pub fn disassemble_compound_vowel_oe_test() {
  // Test compound vowel ㅚ → ㅗㅣ
  let result = disassemble.disassemble("괴")
  result |> should.equal("ㄱㅗㅣ")
}

pub fn disassemble_compound_vowel_wo_test() {
  // Test compound vowel ㅝ → ㅜㅓ
  let result = disassemble.disassemble("궈")
  result |> should.equal("ㄱㅜㅓ")
}

pub fn disassemble_compound_vowel_we_test() {
  // Test compound vowel ㅞ → ㅜㅔ
  let result = disassemble.disassemble("궤")
  result |> should.equal("ㄱㅜㅔ")
}

pub fn disassemble_compound_vowel_wi_test() {
  // Test compound vowel ㅟ → ㅜㅣ
  let result = disassemble.disassemble("귀")
  result |> should.equal("ㄱㅜㅣ")
}

pub fn disassemble_compound_vowel_ui_test() {
  // Test compound vowel ㅢ → ㅡㅣ
  let result = disassemble.disassemble("긔")
  result |> should.equal("ㄱㅡㅣ")
}

// === COMPLEX JONGSEONG TESTS ===

pub fn disassemble_jongseong_gs_test() {
  // Test ㄳ → ㄱㅅ
  let result = disassemble.disassemble("몫")
  result |> should.equal("ㅁㅗㄱㅅ")
}

pub fn disassemble_jongseong_nj_test() {
  // Test ㄵ → ㄴㅈ
  let result = disassemble.disassemble("앉")
  result |> should.equal("ㅇㅏㄴㅈ")
}

pub fn disassemble_jongseong_nh_test() {
  // Test ㄶ → ㄴㅎ
  let result = disassemble.disassemble("많")
  result |> should.equal("ㅁㅏㄴㅎ")
}

pub fn disassemble_jongseong_lg_test() {
  // Test ㄺ → ㄹㄱ
  let result = disassemble.disassemble("닭")
  result |> should.equal("ㄷㅏㄹㄱ")
}

pub fn disassemble_jongseong_lm_test() {
  // Test ㄻ → ㄹㅁ
  let result = disassemble.disassemble("삶")
  result |> should.equal("ㅅㅏㄹㅁ")
}

pub fn disassemble_jongseong_lb_test() {
  // Test ㄼ → ㄹㅂ
  let result = disassemble.disassemble("넓")
  result |> should.equal("ㄴㅓㄹㅂ")
}

pub fn disassemble_jongseong_ls_test() {
  // Test ㄽ → ㄹㅅ
  let result = disassemble.disassemble("외곬")
  result |> should.equal("ㅇㅗㅣㄱㅗㄹㅅ")
}

pub fn disassemble_jongseong_lt_test() {
  // Test ㄾ → ㄹㅌ
  let result = disassemble.disassemble("핥")
  result |> should.equal("ㅎㅏㄹㅌ")
}

pub fn disassemble_jongseong_lp_test() {
  // Test ㄿ → ㄹㅍ
  let result = disassemble.disassemble("읊")
  result |> should.equal("ㅇㅡㄹㅍ")
}

pub fn disassemble_jongseong_lh_test() {
  // Test ㅀ → ㄹㅎ
  let result = disassemble.disassemble("싫")
  result |> should.equal("ㅅㅣㄹㅎ")
}

pub fn disassemble_jongseong_bs_test() {
  // Test ㅄ → ㅂㅅ
  let result = disassemble.disassemble("없")
  result |> should.equal("ㅇㅓㅂㅅ")
}

// === MIXED CONTENT TESTS ===

pub fn disassemble_mixed_hangul_and_non_hangul_test() {
  // Test mixed Hangul and non-Hangul characters
  let result = disassemble.disassemble("안녕a세계!")
  result |> should.equal("ㅇㅏㄴㄴㅕㅇaㅅㅔㄱㅖ!")
}

pub fn disassemble_only_non_hangul_test() {
  // Test string with only non-Hangul characters
  let result = disassemble.disassemble("Hello123!")
  result |> should.equal("Hello123!")
}

pub fn disassemble_mixed_with_spaces_test() {
  // Test mixed content with spaces
  let result = disassemble.disassemble("한글 Korean 123")
  result |> should.equal("ㅎㅏㄴㄱㅡㄹ Korean 123")
}

pub fn disassemble_mixed_with_punctuation_test() {
  // Test mixed content with punctuation
  let result = disassemble.disassemble("안녕하세요, 세계!")
  result |> should.equal("ㅇㅏㄴㄴㅕㅇㅎㅏㅅㅔㅇㅛ, ㅅㅔㄱㅖ!")
}

// === EDGE CASES ===

pub fn disassemble_empty_string_test() {
  // Test empty string
  let result = disassemble.disassemble("")
  result |> should.equal("")
}

pub fn disassemble_single_space_test() {
  // Test single space
  let result = disassemble.disassemble(" ")
  result |> should.equal(" ")
}

pub fn disassemble_multiple_spaces_test() {
  // Test multiple spaces
  let result = disassemble.disassemble("   ")
  result |> should.equal("   ")
}

pub fn disassemble_newline_test() {
  // Test newline character
  let result = disassemble.disassemble("\n")
  result |> should.equal("\n")
}

pub fn disassemble_tab_test() {
  // Test tab character
  let result = disassemble.disassemble("\t")
  result |> should.equal("\t")
}

// === UNICODE EDGE CASES ===

pub fn disassemble_unicode_emoji_test() {
  // Test Unicode emoji mixed with Hangul
  let result = disassemble.disassemble("안녕😊세계")
  result |> should.equal("ㅇㅏㄴㄴㅕㅇ😊ㅅㅔㄱㅖ")
}

pub fn disassemble_unicode_symbols_test() {
  // Test Unicode symbols
  let result = disassemble.disassemble("한글★♥♦")
  result |> should.equal("ㅎㅏㄴㄱㅡㄹ★♥♦")
}

// === REAL WORLD EXAMPLES ===

pub fn disassemble_korean_word_test() {
  // Test common Korean word
  let result = disassemble.disassemble("한글")
  result |> should.equal("ㅎㅏㄴㄱㅡㄹ")
}

pub fn disassemble_korean_sentence_test() {
  // Test Korean sentence with spaces
  let result = disassemble.disassemble("안녕 세계")
  result |> should.equal("ㅇㅏㄴㄴㅕㅇ ㅅㅔㄱㅖ")
}

pub fn disassemble_complex_korean_word_test() {
  // Test word with multiple complex components
  let result = disassemble.disassemble("굽었던")
  result |> should.equal("ㄱㅜㅂㅇㅓㅆㄷㅓㄴ")
}

pub fn disassemble_korean_name_test() {
  // Test Korean name
  let result = disassemble.disassemble("김철수")
  result |> should.equal("ㄱㅣㅁㅊㅓㄹㅅㅜ")
}

// === COMPREHENSIVE TESTS ===

pub fn disassemble_all_compound_vowels_test() {
  // Test all compound vowels in one string
  let result = disassemble.disassemble("과괘괴궈궤귀긔")
  result |> should.equal("ㄱㅗㅏㄱㅗㅐㄱㅗㅣㄱㅜㅓㄱㅜㅔㄱㅜㅣㄱㅡㅣ")
}

pub fn disassemble_all_complex_jongseong_test() {
  // Test multiple complex jongseong
  let result = disassemble.disassemble("몫앉많닭")
  result |> should.equal("ㅁㅗㄱㅅㅇㅏㄴㅈㅁㅏㄴㅎㄷㅏㄹㄱ")
}

// === STRESS TESTS ===

pub fn disassemble_long_text_test() {
  // Test longer text with various components
  let result = disassemble.disassemble("대한민국의 아름다운 한글은 세종대왕이 만드셨습니다")
  result
  |> should.equal(
    "ㄷㅐㅎㅏㄴㅁㅣㄴㄱㅜㄱㅇㅡㅣ ㅇㅏㄹㅡㅁㄷㅏㅇㅜㄴ ㅎㅏㄴㄱㅡㄹㅇㅡㄴ ㅅㅔㅈㅗㅇㄷㅐㅇㅗㅏㅇㅇㅣ ㅁㅏㄴㄷㅡㅅㅕㅆㅅㅡㅂㄴㅣㄷㅏ",
  )
}

pub fn disassemble_repeated_characters_test() {
  // Test repeated characters
  let result = disassemble.disassemble("가가가나나나")
  result |> should.equal("ㄱㅏㄱㅏㄱㅏㄴㅏㄴㅏㄴㅏ")
}

// === BOUNDARY TESTS ===

pub fn disassemble_hangul_boundary_start_test() {
  // Test first complete Hangul character (가)
  let result = disassemble.disassemble("가")
  result |> should.equal("ㄱㅏ")
}

pub fn disassemble_hangul_boundary_end_test() {
  // Test last complete Hangul character (힣)
  let result = disassemble.disassemble("힣")
  result |> should.equal("ㅎㅣㅎ")
}

// === INTEGRATION TEST ===

pub fn disassemble_integration_test() {
  // Test that disassemble and disassemble_to_groups are consistent
  let text = "값진 한글"
  let disassemble_result = disassemble.disassemble(text)
  let groups_result =
    disassemble.disassemble_to_groups(text)
    |> list.flatten
    |> string.join("")

  disassemble_result |> should.equal(groups_result)
  disassemble_result |> should.equal("ㄱㅏㅂㅅㅈㅣㄴ ㅎㅏㄴㄱㅡㄹ")
}
