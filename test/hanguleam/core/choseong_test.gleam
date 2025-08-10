import startest.{describe, it}
import startest/expect
import hanguleam/core/choseong

pub fn choseong_tests() {
  describe("choseong module", [
    describe("basic functionality", [
      it("should extract choseong from basic text", fn() {
        choseong.get_choseong("사과")
        |> expect.to_equal("ㅅㄱ")
      }),
      it("should handle single character", fn() {
        choseong.get_choseong("가")
        |> expect.to_equal("ㄱ")
      }),
      it("should handle empty string", fn() {
        choseong.get_choseong("")
        |> expect.to_equal("")
      }),
    ]),
    describe("mixed content", [
      it("should handle text with spaces", fn() {
        choseong.get_choseong("띄어 쓰기")
        |> expect.to_equal("ㄸㅇ ㅆㄱ")
      }),
      it("should handle non-korean characters", fn() {
        choseong.get_choseong("hello")
        |> expect.to_equal("")
      }),
      it("should handle mixed korean and non-korean", fn() {
        choseong.get_choseong("안녕hello")
        |> expect.to_equal("ㅇㄴ")
      }),
    ]),
    describe("whitespace handling", [
      it("should preserve tabs and newlines", fn() {
        choseong.get_choseong("안\t녕\n하세요")
        |> expect.to_equal("ㅇ\tㄴ\nㅎㅅㅇ")
      }),
    ]),
    describe("edge cases", [
      it("should handle malformed utf8", fn() {
        choseong.get_choseong("�") |> expect.to_equal("")
      }),
      it("should handle zero width characters", fn() {
        choseong.get_choseong("안\u{200B}녕") |> expect.to_equal("ㅇㄴ")
      }),
    ]),
  ])
}