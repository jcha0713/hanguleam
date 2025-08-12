import startest.{describe, it}
import startest/expect
import hanguleam/composer

pub fn assemble_character_tests() {
  describe("assemble character functions", [
    describe("combine_vowels", [
      describe("valid combinations", [
        it("should combine vowels to form compound vowels", fn() {
          composer.combine_vowels("ㅗ", "ㅏ")
          |> expect.to_equal("ㅘ")

          composer.combine_vowels("ㅗ", "ㅐ")
          |> expect.to_equal("ㅙ")

          composer.combine_vowels("ㅗ", "ㅣ")
          |> expect.to_equal("ㅚ")

          composer.combine_vowels("ㅜ", "ㅓ")
          |> expect.to_equal("ㅝ")

          composer.combine_vowels("ㅜ", "ㅔ")
          |> expect.to_equal("ㅞ")

          composer.combine_vowels("ㅜ", "ㅣ")
          |> expect.to_equal("ㅟ")

          composer.combine_vowels("ㅡ", "ㅣ")
          |> expect.to_equal("ㅢ")
        }),
        it("should form complex vowels", fn() {
          composer.combine_vowels("ㅗ", "ㅏ")
          |> expect.to_equal("ㅘ")

          composer.combine_vowels("ㅜ", "ㅓ")
          |> expect.to_equal("ㅝ")

          composer.combine_vowels("ㅡ", "ㅣ")
          |> expect.to_equal("ㅢ")
        }),
      ]),
      describe("invalid combinations", [
        it("should not combine incompatible vowels", fn() {
          composer.combine_vowels("ㅗ", "ㅛ")
          |> expect.to_equal("ㅗㅛ")

          composer.combine_vowels("ㅏ", "ㅓ")
          |> expect.to_equal("ㅏㅓ")

          composer.combine_vowels("ㅣ", "ㅏ")
          |> expect.to_equal("ㅣㅏ")

          composer.combine_vowels("ㅜ", "ㅏ")
          |> expect.to_equal("ㅜㅏ")
        }),
      ]),
      describe("edge cases", [
        it("should handle single vowels", fn() {
          composer.combine_vowels("ㅏ", "")
          |> expect.to_equal("ㅏ")

          composer.combine_vowels("", "ㅓ")
          |> expect.to_equal("ㅓ")

          composer.combine_vowels("", "")
          |> expect.to_equal("")
        }),
        it("should handle already combined vowels", fn() {
          composer.combine_vowels("ㅘ", "")
          |> expect.to_equal("ㅘ")

          composer.combine_vowels("", "ㅢ")
          |> expect.to_equal("ㅢ")
        }),
      ]),
    ]),
    describe("combine_character", [
      describe("valid combinations", [
        it("should combine valid jamo into characters", fn() {
          composer.combine_character("ㄱ", "ㅏ", "")
          |> expect.to_equal(Ok("가"))

          composer.combine_character("ㄴ", "ㅏ", "ㄴ")
          |> expect.to_equal(Ok("난"))
        }),
        it("should handle first and last hangul characters", fn() {
          composer.combine_character("ㄱ", "ㅏ", "ㄱ")
          |> expect.to_equal(Ok("각"))

          composer.combine_character("ㅎ", "ㅣ", "ㅎ")
          |> expect.to_equal(Ok("힣"))
        }),
        it("should handle complex vowels", fn() {
          composer.combine_character("ㄱ", "ㅘ", "")
          |> expect.to_equal(Ok("과"))

          composer.combine_character("ㄱ", "ㅗㅏ", "")
          |> expect.to_equal(Ok("과"))
        }),
        it("should handle complex combinations", fn() {
          composer.combine_character("ㄱ", "ㅘ", "ㄼ")
          |> expect.to_equal(Ok("괇"))

          composer.combine_character("ㄱ", "ㅗㅏ", "ㄹㅂ")
          |> expect.to_equal(Ok("괇"))
        }),
      ]),
      describe("invalid combinations", [
        it("should reject invalid choseong", fn() {
          composer.combine_character("ㅏ", "ㅏ", "")
          |> expect.to_equal(Error(composer.InvalidChoseong("ㅏ")))
        }),
        it("should reject invalid jungseong", fn() {
          composer.combine_character("ㄱ", "ㄱ", "")
          |> expect.to_equal(Error(composer.InvalidJungseong("ㄱ")))
        }),
        it("should reject invalid jongseong", fn() {
          composer.combine_character("ㄱ", "ㅏ", "ㅏ")
          |> expect.to_equal(Error(composer.InvalidJongseong("ㅏ")))
        }),
      ]),
    ]),
    describe("combine_character_unsafe", [
      it("should combine valid jamo into characters without validation", fn() {
        composer.combine_character_unsafe("ㄱ", "ㅏ", "")
        |> expect.to_equal("가")

        composer.combine_character_unsafe("ㄴ", "ㅏ", "ㄴ")
        |> expect.to_equal("난")

        composer.combine_character_unsafe("ㄱ", "ㅘ", "ㄼ")
        |> expect.to_equal("괇")

        composer.combine_character_unsafe("ㅎ", "ㅣ", "ㅎ")
        |> expect.to_equal("힣")
      }),
    ]),
  ])
}