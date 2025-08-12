import startest.{describe, it}
import startest/expect
import hanguleam/extractor

pub fn choseong_tests() {
  describe("choseong module", [
    describe("basic functionality", [
      it("should extract choseong from basic text", fn() {
        extractor.get_choseong("사과")
        |> expect.to_equal("ㅅㄱ")
      }),
      it("should handle single character", fn() {
        extractor.get_choseong("가")
        |> expect.to_equal("ㄱ")
      }),
      it("should handle empty string", fn() {
        extractor.get_choseong("")
        |> expect.to_equal("")
      }),
    ]),
    describe("mixed content", [
      it("should handle text with spaces", fn() {
        extractor.get_choseong("띄어 쓰기")
        |> expect.to_equal("ㄸㅇ ㅆㄱ")
      }),
      it("should handle non-korean characters", fn() {
        extractor.get_choseong("hello")
        |> expect.to_equal("")
      }),
      it("should handle mixed korean and non-korean", fn() {
        extractor.get_choseong("안녕hello")
        |> expect.to_equal("ㅇㄴ")
      }),
    ]),
    describe("whitespace handling", [
      it("should preserve tabs and newlines", fn() {
        extractor.get_choseong("안\t녕\n하세요")
        |> expect.to_equal("ㅇ\tㄴ\nㅎㅅㅇ")
      }),
    ]),
    describe("edge cases", [
      it("should handle malformed utf8", fn() {
        extractor.get_choseong("�") |> expect.to_equal("")
      }),
      it("should handle zero width characters", fn() {
        extractor.get_choseong("안\u{200B}녕") |> expect.to_equal("ㅇㄴ")
      }),
    ]),
  ])
}