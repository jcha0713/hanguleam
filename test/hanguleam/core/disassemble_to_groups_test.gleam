import startest.{describe, it}
import startest/expect
import hanguleam/core/disassemble

pub fn disassemble_to_groups_tests() {
  describe("disassemble_to_groups module", [
    describe("basic functionality", [
      it("should handle simple characters", fn() {
        let result = disassemble.disassemble_to_groups("사과")
        result |> expect.to_equal([["ㅅ", "ㅏ"], ["ㄱ", "ㅗ", "ㅏ"]])
      }),
      it("should handle complex jongseong", fn() {
        let result = disassemble.disassemble_to_groups("값")
        result |> expect.to_equal([["ㄱ", "ㅏ", "ㅂ", "ㅅ"]])
      }),
      it("should handle mixed characters", fn() {
        let result = disassemble.disassemble_to_groups("가ㅘㄵ")
        result |> expect.to_equal([["ㄱ", "ㅏ"], ["ㅗ", "ㅏ"], ["ㄴ", "ㅈ"]])
      }),
    ]),
    describe("compound vowels", [
      it("should decompose compound vowels", fn() {
        let result = disassemble.disassemble_to_groups("ㅘ")
        result |> expect.to_equal([["ㅗ", "ㅏ"]])
      }),
      it("should handle various compound vowels", fn() {
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
      }),
    ]),
    describe("compound consonants", [
      it("should decompose compound consonants", fn() {
        let result = disassemble.disassemble_to_groups("ㄵ")
        result |> expect.to_equal([["ㄴ", "ㅈ"]])
      }),
      it("should handle various compound consonants", fn() {
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
      }),
    ]),
    describe("edge cases", [
      it("should handle empty string", fn() {
        let result = disassemble.disassemble_to_groups("")
        result |> expect.to_equal([])
      }),
      it("should handle non-hangul characters", fn() {
        let result = disassemble.disassemble_to_groups("a1!")
        result |> expect.to_equal([["a"], ["1"], ["!"]])
      }),
      it("should handle mixed content", fn() {
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
      }),
    ]),
  ])
}