import gleeunit/should
import hanguleam/core/disassemble.{EmptyInput, IncompleteHangul, NonHangul}
import hanguleam/internal/types.{
  type HangulSyllable, Choseong, HangulSyllable, Jongseong, Jungseong,
}

// Helper function to reduce repetition
fn assert_disassemble_ok(input: String, expected: HangulSyllable) {
  disassemble.disassemble_complete_character(input)
  |> should.equal(Ok(expected))
}

fn assert_disassemble_error(
  input: String,
  expected_error: disassemble.DisassembleError,
) {
  disassemble.disassemble_complete_character(input)
  |> should.equal(Error(expected_error))
}

// === SUCCESS CASES ===

pub fn disassemble_complete_character_with_jongseong_test() {
  assert_disassemble_ok(
    "몽",
    HangulSyllable(Choseong("ㅁ"), Jungseong("ㅗ"), Jongseong("ㅇ")),
  )
}

pub fn disassemble_complete_character_without_jongseong_test() {
  assert_disassemble_ok(
    "가",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("")),
  )
}

pub fn disassemble_complete_character_complex_jongseong_test() {
  assert_disassemble_ok(
    "쀍",
    HangulSyllable(Choseong("ㅃ"), Jungseong("ㅞ"), Jongseong("ㄹㄱ")),
  )
}

pub fn disassemble_complete_character_first_hangul_test() {
  // Test first complete Hangul character (가)
  assert_disassemble_ok(
    "가",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("")),
  )
}

pub fn disassemble_complete_character_last_hangul_test() {
  // Test last complete Hangul character (힣)
  assert_disassemble_ok(
    "힣",
    HangulSyllable(Choseong("ㅎ"), Jungseong("ㅣ"), Jongseong("ㅎ")),
  )
}

pub fn disassemble_complete_character_various_choseong_test() {
  // Test different choseong characters
  assert_disassemble_ok(
    "나",
    HangulSyllable(Choseong("ㄴ"), Jungseong("ㅏ"), Jongseong("")),
  )

  assert_disassemble_ok(
    "다",
    HangulSyllable(Choseong("ㄷ"), Jungseong("ㅏ"), Jongseong("")),
  )

  assert_disassemble_ok(
    "싸",
    HangulSyllable(Choseong("ㅆ"), Jungseong("ㅏ"), Jongseong("")),
  )
}

pub fn disassemble_complete_character_various_jungseong_test() {
  // Test different jungseong characters
  assert_disassemble_ok(
    "고",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅗ"), Jongseong("")),
  )

  assert_disassemble_ok(
    "구",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅜ"), Jongseong("")),
  )

  assert_disassemble_ok(
    "괘",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅙ"), Jongseong("")),
  )
}

pub fn disassemble_complete_character_complex_jongseong_cases_test() {
  // Test various complex jongseong
  assert_disassemble_ok(
    "갃",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄱㅅ")),
  )

  assert_disassemble_ok(
    "갅",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄴㅈ")),
  )

  assert_disassemble_ok(
    "갊",
    HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄹㅁ")),
  )
}

// === ERROR CASES ===

pub fn disassemble_complete_character_empty_string_test() {
  assert_disassemble_error("", EmptyInput)
}

pub fn disassemble_complete_character_incomplete_hangul_test() {
  // Test individual jamo
  assert_disassemble_error("ㄱ", IncompleteHangul)
  assert_disassemble_error("ㅏ", IncompleteHangul)
  assert_disassemble_error("ㅇ", IncompleteHangul)
}

pub fn disassemble_complete_character_non_hangul_test() {
  // Test non-Hangul characters
  assert_disassemble_error("a", NonHangul)
  assert_disassemble_error("1", NonHangul)
  assert_disassemble_error("!", NonHangul)
  assert_disassemble_error(" ", NonHangul)
  assert_disassemble_error("中", NonHangul)
  assert_disassemble_error("あ", NonHangul)
}
