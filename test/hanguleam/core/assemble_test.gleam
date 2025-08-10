import hanguleam/core/assemble
import startest.{describe, it}
import startest/expect

pub fn assemble_tests() {
  describe("assemble module", [
    describe("basic combinations", [
      it("should assemble CV (consonant-vowel)", fn() {
        assemble.assemble(["ㄱ", "ㅏ"])
        |> expect.to_equal("가")
      }),
      it("should assemble CVC (consonant-vowel-consonant)", fn() {
        assemble.assemble(["ㄴ", "ㅏ", "ㄴ"])
        |> expect.to_equal("난")
      }),
      it("should assemble complex vowel", fn() {
        assemble.assemble(["ㄱ", "ㅗ", "ㅏ"])
        |> expect.to_equal("과")
      }),
      it("should assemble two syllables", fn() {
        assemble.assemble(["ㄱ", "ㅏ", "ㄴ", "ㅏ"])
        |> expect.to_equal("가나")
      }),
      it("should assemble korean word", fn() {
        assemble.assemble(["ㅎ", "ㅏ", "ㄴ", "ㄱ", "ㅡ", "ㄹ"])
        |> expect.to_equal("한글")
      }),
    ]),
    describe("vowel combinations", [
      it("should combine ㅗ + ㅏ", fn() {
        assemble.assemble(["ㅗ", "ㅏ"])
        |> expect.to_equal("ㅘ")
      }),
      it("should combine ㅜ + ㅓ", fn() {
        assemble.assemble(["ㅜ", "ㅓ"])
        |> expect.to_equal("ㅝ")
      }),
      it("should combine ㅡ + ㅣ", fn() {
        assemble.assemble(["ㅡ", "ㅣ"])
        |> expect.to_equal("ㅢ")
      }),
      it("should not combine invalid vowel combinations", fn() {
        assemble.assemble(["ㅏ", "ㅓ"])
        |> expect.to_equal("ㅏㅓ")
      }),
      it("should not combine ㅣ + ㅏ", fn() {
        assemble.assemble(["ㅣ", "ㅏ"])
        |> expect.to_equal("ㅣㅏ")
      }),
    ]),
    describe("linking (연음)", [
      it("should handle 수박 + ㅏ linking", fn() {
        assemble.assemble(["수박", "ㅏ"])
        |> expect.to_equal("수바가")

        assemble.assemble(["깎", "ㅏ"])
        |> expect.to_equal("까까")
      }),
      it("should handle 값 + ㅜ linking", fn() {
        assemble.assemble(["값", "ㅜ"])
        |> expect.to_equal("갑수")
      }),
    ]),
    describe("batchim addition", [
      it("should add single batchim", fn() {
        assemble.assemble(["가", "ㄱ"])
        |> expect.to_equal("각")
      }),
      it("should add ㄴ batchim", fn() {
        assemble.assemble(["나", "ㄴ"])
        |> expect.to_equal("난")
      }),
      it("should add complex batchim ㄹㅂ", fn() {
        assemble.assemble(["가", "ㄹ", "ㅂ"])
        |> expect.to_equal("갋")
      }),
      it("should add complex batchim ㄹㅅ", fn() {
        assemble.assemble(["나", "ㄹ", "ㅅ"])
        |> expect.to_equal("낤")
      }),
      it("should not add vowel as batchim", fn() {
        assemble.assemble(["가", "ㅏ"])
        |> expect.to_equal("가ㅏ")
      }),
    ]),
    describe("sentence assembly", [
      it("should handle sentence without combination", fn() {
        assemble.assemble(["안녕하", "ㅏ"])
        |> expect.to_equal("안녕하ㅏ")
      }),
      it("should assemble sentences", fn() {
        assemble.assemble(["안녕", "ㅎ", "ㅏ"])
        |> expect.to_equal("안녕하")
      }),
      it("should handle sentence with spaces", fn() {
        assemble.assemble(["아버지가", " ", "방ㅇ", "ㅔ ", "들ㅇ", "ㅓ갑니다"])
        |> expect.to_equal("아버지가 방에 들어갑니다")

        assemble.assemble(["아버지가", " ", "방에", " ", "들어갑니다"])
        |> expect.to_equal("아버지가 방에 들어갑니다")

        assemble.assemble([
          "ㅇ", "ㅏ", "ㅂ", "ㅓ", "ㅈ", "ㅣ", "ㄱ", "ㅏ", " ", "ㅂ", "ㅏ", "ㅇ", "ㅇ", "ㅔ",
          " ", "ㄷ", "ㅡ", "ㄹ", "ㅇ", "ㅓ", "ㄱ", "ㅏ", "ㅂ", "ㄴ", "ㅣ", "ㄷ", "ㅏ",
        ])
        |> expect.to_equal("아버지가 방에 들어갑니다")
      }),
      it("should handle mixed text", fn() {
        assemble.assemble(["Hello", "ㄱ", "ㅏ"])
        |> expect.to_equal("Hello가")
      }),
      it("should handle numbers and hangul", fn() {
        assemble.assemble(["123", "ㄴ", "ㅏ"])
        |> expect.to_equal("123나")
      }),
    ]),
    describe("edge cases", [
      it("should handle empty list", fn() {
        assemble.assemble([])
        |> expect.to_equal("")
      }),
      it("should handle single empty string", fn() {
        assemble.assemble([""])
        |> expect.to_equal("")
      }),
      it("should handle multiple empty strings", fn() {
        assemble.assemble(["", ""])
        |> expect.to_equal("")
      }),
      it("should handle single consonant", fn() {
        assemble.assemble(["ㄱ"])
        |> expect.to_equal("ㄱ")
      }),
      it("should handle single vowel", fn() {
        assemble.assemble(["ㅏ"])
        |> expect.to_equal("ㅏ")
      }),
      it("should handle single complete character", fn() {
        assemble.assemble(["가"])
        |> expect.to_equal("가")
      }),
      it("should handle space character", fn() {
        assemble.assemble([" "])
        |> expect.to_equal(" ")
      }),
      it("should handle special char with hangul", fn() {
        assemble.assemble(["!", "ㄱ", "ㅏ"])
        |> expect.to_equal("!가")
      }),
      it("should not combine vowel and consonant", fn() {
        assemble.assemble(["ㅏ", "ㄱ"])
        |> expect.to_equal("ㅏㄱ")
      }),
      it("should not combine consonant and consonant", fn() {
        assemble.assemble(["ㄱ", "ㄴ"])
        |> expect.to_equal("ㄱㄴ")
      }),
      it("should handle long sequence", fn() {
        assemble.assemble(["ㄱ", "ㅏ", "ㄴ", "ㅏ", "ㄷ", "ㅏ"])
        |> expect.to_equal("가나다")
      }),
      it("should handle repeated consonant", fn() {
        assemble.assemble(["ㄱ", "ㄱ", "ㅏ"])
        |> expect.to_equal("ㄱ가")
      }),
      it("should handle repeated vowel", fn() {
        assemble.assemble(["ㅏ", "ㅏ"])
        |> expect.to_equal("ㅏㅏ")
      }),
      it("should handle complete char with consonant", fn() {
        assemble.assemble(["강", "ㅎ"])
        |> expect.to_equal("강ㅎ")
      }),
      it("should handle complete char with vowel", fn() {
        assemble.assemble(["한", "ㅏ"])
        |> expect.to_equal("하나")
      }),
    ]),
  ])
}
