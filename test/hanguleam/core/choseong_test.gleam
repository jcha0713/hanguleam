import gleeunit/should
import hanguleam/core/choseong

// Test basic choseong extraction
pub fn get_choseong_basic_test() {
  choseong.get_choseong("사과")
  |> should.equal("ㅅㄱ")
}

// Test choseong extraction with spaces
pub fn get_choseong_with_spaces_test() {
  choseong.get_choseong("띄어 쓰기")
  |> should.equal("ㄸㅇ ㅆㄱ")
}

// Test empty string
pub fn get_choseong_empty_test() {
  choseong.get_choseong("")
  |> should.equal("")
}

// Test single character
pub fn get_choseong_single_char_test() {
  choseong.get_choseong("가")
  |> should.equal("ㄱ")
}

// Test non-Korean characters
pub fn get_choseong_non_korean_test() {
  choseong.get_choseong("hello")
  |> should.equal("")
}

// Test mixed Korean and non-Korean
pub fn get_choseong_mixed_test() {
  choseong.get_choseong("안녕hello")
  |> should.equal("ㅇㄴ")
}

// Test with tabs and newlines
pub fn get_choseong_whitespace_test() {
  choseong.get_choseong("안\t녕\n하세요")
  |> should.equal("ㅇ\tㄴ\nㅎㅅㅇ")
}

pub fn malformed_utf8_test() {
  choseong.get_choseong("�") |> should.equal("")
}

pub fn zero_width_test() {
  choseong.get_choseong("안\u{200B}녕") |> should.equal("ㅇㄴ")
}
