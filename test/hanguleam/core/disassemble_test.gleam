import gleeunit/should
import hanguleam/core/disassemble.{EmptyInput, IncompleteHangul, NonHangul}
import hanguleam/internal/types.{Choseong, HangulSyllable, Jongseong, Jungseong}

// Test successful disassembly cases
pub fn disassemble_complete_hangul_with_jongseong_test() {
  let result = disassemble.disassemble_complete_character("몽")
  result
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㅁ"), Jungseong("ㅗ"), Jongseong("ㅇ"))),
  )
}

pub fn disassemble_complete_hangul_without_jongseong_test() {
  let result = disassemble.disassemble_complete_character("가")
  result
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong(""))),
  )
}

pub fn disassemble_complex_jongseong_test() {
  let result = disassemble.disassemble_complete_character("쀍")
  result
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㅃ"), Jungseong("ㅞ"), Jongseong("ㄹㄱ"))),
  )
}

pub fn disassemble_first_hangul_character_test() {
  // Test first complete Hangul character (가)
  let result = disassemble.disassemble_complete_character("가")
  result
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong(""))),
  )
}

pub fn disassemble_last_hangul_character_test() {
  // Test last complete Hangul character (힣)
  let result = disassemble.disassemble_complete_character("힣")
  result
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㅎ"), Jungseong("ㅣ"), Jongseong("ㅎ"))),
  )
}

pub fn disassemble_various_choseong_test() {
  // Test different choseong characters
  let result1 = disassemble.disassemble_complete_character("나")
  result1
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄴ"), Jungseong("ㅏ"), Jongseong(""))),
  )

  let result2 = disassemble.disassemble_complete_character("다")
  result2
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄷ"), Jungseong("ㅏ"), Jongseong(""))),
  )

  let result3 = disassemble.disassemble_complete_character("싸")
  result3
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㅆ"), Jungseong("ㅏ"), Jongseong(""))),
  )
}

pub fn disassemble_various_jungseong_test() {
  // Test different jungseong characters
  let result1 = disassemble.disassemble_complete_character("고")
  result1
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅗ"), Jongseong(""))),
  )

  let result2 = disassemble.disassemble_complete_character("구")
  result2
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅜ"), Jongseong(""))),
  )

  let result3 = disassemble.disassemble_complete_character("괘")
  result3
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅙ"), Jongseong(""))),
  )
}

// Test error cases
pub fn disassemble_empty_string_test() {
  let result = disassemble.disassemble_complete_character("")
  result |> should.equal(Error(EmptyInput))
}

pub fn disassemble_incomplete_hangul_choseong_test() {
  // Test individual jamo (choseong)
  let result = disassemble.disassemble_complete_character("ㄱ")
  result |> should.equal(Error(IncompleteHangul))
}

pub fn disassemble_incomplete_hangul_jungseong_test() {
  // Test individual jamo (jungseong)
  let result = disassemble.disassemble_complete_character("ㅏ")
  result |> should.equal(Error(IncompleteHangul))
}

pub fn disassemble_incomplete_hangul_jongseong_test() {
  // Test individual jamo (jongseong)
  let result = disassemble.disassemble_complete_character("ㅇ")
  result |> should.equal(Error(IncompleteHangul))
}

pub fn disassemble_non_hangul_latin_test() {
  // Test Latin characters
  let result = disassemble.disassemble_complete_character("a")
  result |> should.equal(Error(NonHangul))
}

pub fn disassemble_non_hangul_number_test() {
  // Test numbers
  let result = disassemble.disassemble_complete_character("1")
  result |> should.equal(Error(NonHangul))
}

pub fn disassemble_non_hangul_symbol_test() {
  // Test symbols
  let result = disassemble.disassemble_complete_character("!")
  result |> should.equal(Error(NonHangul))
}

pub fn disassemble_non_hangul_space_test() {
  // Test space character
  let result = disassemble.disassemble_complete_character(" ")
  result |> should.equal(Error(NonHangul))
}

pub fn disassemble_non_hangul_chinese_test() {
  // Test Chinese characters
  let result = disassemble.disassemble_complete_character("中")
  result |> should.equal(Error(NonHangul))
}

pub fn disassemble_non_hangul_japanese_test() {
  // Test Japanese characters
  let result = disassemble.disassemble_complete_character("あ")
  result |> should.equal(Error(NonHangul))
}

// Test edge cases with complex jongseong
pub fn disassemble_complex_jongseong_cases_test() {
  // Test various complex jongseong
  let result1 = disassemble.disassemble_complete_character("갃")
  // ㄳ
  result1
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄱㅅ"))),
  )

  let result2 = disassemble.disassemble_complete_character("갅")
  // ㄵ
  result2
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄴㅈ"))),
  )

  let result3 = disassemble.disassemble_complete_character("갊")
  // ㄻ
  result3
  |> should.equal(
    Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄹㅁ"))),
  )
}
