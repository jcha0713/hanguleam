import startest/expect
import hanguleam/core/choseong

// Test basic choseong extraction
pub fn get_choseong_basic_test() {
  choseong.get_choseong("사과")
  |> expect.to_equal("ㅅㄱ")
}

// Test choseong extraction with spaces
pub fn get_choseong_with_spaces_test() {
  choseong.get_choseong("띄어 쓰기")
  |> expect.to_equal("ㄸㅇ ㅆㄱ")
}

// Test empty string
pub fn get_choseong_empty_test() {
  choseong.get_choseong("")
  |> expect.to_equal("")
}

// Test single character
pub fn get_choseong_single_char_test() {
  choseong.get_choseong("가")
  |> expect.to_equal("ㄱ")
}

// Test non-Korean characters
pub fn get_choseong_non_korean_test() {
  choseong.get_choseong("hello")
  |> expect.to_equal("")
}

// Test mixed Korean and non-Korean
pub fn get_choseong_mixed_test() {
  choseong.get_choseong("안녕hello")
  |> expect.to_equal("ㅇㄴ")
}

// Test with tabs and newlines
pub fn get_choseong_whitespace_test() {
  choseong.get_choseong("안\t녕\n하세요")
  |> expect.to_equal("ㅇ\tㄴ\nㅎㅅㅇ")
}

pub fn malformed_utf8_test() {
  choseong.get_choseong("�") |> expect.to_equal("")
}

pub fn zero_width_test() {
  choseong.get_choseong("안\u{200B}녕") |> expect.to_equal("ㅇㄴ")
}
