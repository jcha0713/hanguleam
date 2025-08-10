import startest.{describe, it}
import startest/expect
import hanguleam/core/assemble

pub fn assemble_character_tests() {
  describe("assemble character functions", [
    describe("combine_vowels", [
      describe("valid combinations", [
        it("should combine vowels to form compound vowels", fn() {
          assemble.combine_vowels("ㅗ", "ㅏ")
          |> expect.to_equal("ㅘ")

          assemble.combine_vowels("ㅗ", "ㅐ")
          |> expect.to_equal("ㅙ")

          assemble.combine_vowels("ㅗ", "ㅣ")
          |> expect.to_equal("ㅚ")

          assemble.combine_vowels("ㅜ", "ㅓ")
          |> expect.to_equal("ㅝ")

          assemble.combine_vowels("ㅜ", "ㅔ")
          |> expect.to_equal("ㅞ")

          assemble.combine_vowels("ㅜ", "ㅣ")
          |> expect.to_equal("ㅟ")

          assemble.combine_vowels("ㅡ", "ㅣ")
          |> expect.to_equal("ㅢ")
        }),
        it("should form complex vowels", fn() {
          assemble.combine_vowels("ㅗ", "ㅏ")
          |> expect.to_equal("ㅘ")

          assemble.combine_vowels("ㅜ", "ㅓ")
          |> expect.to_equal("ㅝ")

          assemble.combine_vowels("ㅡ", "ㅣ")
          |> expect.to_equal("ㅢ")
        }),
      ]),
      describe("invalid combinations", [
        it("should not combine incompatible vowels", fn() {
          assemble.combine_vowels("ㅗ", "ㅛ")
          |> expect.to_equal("ㅗㅛ")

          assemble.combine_vowels("ㅏ", "ㅓ")
          |> expect.to_equal("ㅏㅓ")

          assemble.combine_vowels("ㅣ", "ㅏ")
          |> expect.to_equal("ㅣㅏ")

          assemble.combine_vowels("ㅜ", "ㅏ")
          |> expect.to_equal("ㅜㅏ")
        }),
      ]),
      describe("edge cases", [
        it("should handle single vowels", fn() {
          assemble.combine_vowels("ㅏ", "")
          |> expect.to_equal("ㅏ")

          assemble.combine_vowels("", "ㅓ")
          |> expect.to_equal("ㅓ")

          assemble.combine_vowels("", "")
          |> expect.to_equal("")
        }),
        it("should handle already combined vowels", fn() {
          assemble.combine_vowels("ㅘ", "")
          |> expect.to_equal("ㅘ")

          assemble.combine_vowels("", "ㅢ")
          |> expect.to_equal("ㅢ")
        }),
      ]),
    ]),
    describe("combine_character", [
      describe("valid combinations", [
        it("should combine valid jamo into characters", fn() {
          assemble.combine_character("ㄱ", "ㅏ", "")
          |> expect.to_equal(Ok("가"))

          assemble.combine_character("ㄴ", "ㅏ", "ㄴ")
          |> expect.to_equal(Ok("난"))
        }),
        it("should handle first and last hangul characters", fn() {
          assemble.combine_character("ㄱ", "ㅏ", "ㄱ")
          |> expect.to_equal(Ok("각"))

          assemble.combine_character("ㅎ", "ㅣ", "ㅎ")
          |> expect.to_equal(Ok("힣"))
        }),
        it("should handle complex vowels", fn() {
          assemble.combine_character("ㄱ", "ㅘ", "")
          |> expect.to_equal(Ok("과"))

          assemble.combine_character("ㄱ", "ㅗㅏ", "")
          |> expect.to_equal(Ok("과"))
        }),
        it("should handle complex combinations", fn() {
          assemble.combine_character("ㄱ", "ㅘ", "ㄼ")
          |> expect.to_equal(Ok("괇"))

          assemble.combine_character("ㄱ", "ㅗㅏ", "ㄹㅂ")
          |> expect.to_equal(Ok("괇"))
        }),
      ]),
      describe("invalid combinations", [
        it("should reject invalid choseong", fn() {
          assemble.combine_character("ㅏ", "ㅏ", "")
          |> expect.to_equal(Error(assemble.InvalidChoseong("ㅏ")))
        }),
        it("should reject invalid jungseong", fn() {
          assemble.combine_character("ㄱ", "ㄱ", "")
          |> expect.to_equal(Error(assemble.InvalidJungseong("ㄱ")))
        }),
        it("should reject invalid jongseong", fn() {
          assemble.combine_character("ㄱ", "ㅏ", "ㅏ")
          |> expect.to_equal(Error(assemble.InvalidJongseong("ㅏ")))
        }),
      ]),
    ]),
    describe("combine_character_unsafe", [
      it("should combine valid jamo into characters without validation", fn() {
        assemble.combine_character_unsafe("ㄱ", "ㅏ", "")
        |> expect.to_equal("가")

        assemble.combine_character_unsafe("ㄴ", "ㅏ", "ㄴ")
        |> expect.to_equal("난")

        assemble.combine_character_unsafe("ㄱ", "ㅘ", "ㄼ")
        |> expect.to_equal("괇")

        assemble.combine_character_unsafe("ㅎ", "ㅣ", "ㅎ")
        |> expect.to_equal("힣")
      }),
    ]),
  ])
}