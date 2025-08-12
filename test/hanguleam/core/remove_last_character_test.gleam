import hanguleam/editor
import startest.{describe, it}
import startest/expect

pub fn remove_last_character_tests() {
  describe("remove_last_character function", [
    describe("korean syllables", [
      it("should handle simple CV syllables", fn() {
        editor.remove_last_character("아") |> expect.to_equal("ㅇ")
      }),
      it("should handle compound vowel cases", fn() {
        editor.remove_last_character("점괘") |> expect.to_equal("점고")
        editor.remove_last_character("전화") |> expect.to_equal("전호")
        editor.remove_last_character("과") |> expect.to_equal("고")
      }),
      it("should handle simple CVC syllables", fn() {
        editor.remove_last_character("수박") |> expect.to_equal("수바")
      }),
      it("should handle compound CVC", fn() {
        editor.remove_last_character("괌") |> expect.to_equal("과")
      }),
      it("should handle complex batchim cases", fn() {
        editor.remove_last_character("값") |> expect.to_equal("갑")
        editor.remove_last_character("여덟") |> expect.to_equal("여덜")
      }),
      it("should handle compound complex batchim cases", fn() {
        editor.remove_last_character("홟") |> expect.to_equal("활")
      }),
    ]),
    describe("edge cases", [
      it("should handle empty input", fn() {
        editor.remove_last_character("") |> expect.to_equal("")
      }),
      it("should remove single jamo characters entirely", fn() {
        editor.remove_last_character("ㅏ") |> expect.to_equal("")
        editor.remove_last_character("ㅇ") |> expect.to_equal("")
        editor.remove_last_character("ㄱ") |> expect.to_equal("")
      }),
      it("should remove last component from compound jamo", fn() {
        editor.remove_last_character("ㄱㅅ") |> expect.to_equal("ㄱ")
        editor.remove_last_character("ㅗㅏ") |> expect.to_equal("ㅗ")
      }),
    ]),
    describe("non-hangul characters", [
      it("should handle latin characters normally", fn() {
        editor.remove_last_character("a") |> expect.to_equal("")
        editor.remove_last_character("Hello") |> expect.to_equal("Hell")
      }),
      it("should handle numbers and punctuation", fn() {
        editor.remove_last_character("123") |> expect.to_equal("12")
        editor.remove_last_character("!") |> expect.to_equal("")
      }),
      it("should handle mixed content", fn() {
        editor.remove_last_character("한글a") |> expect.to_equal("한글")
        editor.remove_last_character("풀잎!") |> expect.to_equal("풀잎")
        editor.remove_last_character("Hello가") |> expect.to_equal("Helloㄱ")
      }),
    ]),
  ])
}
