import startest.{describe, it}
import gleam/list
import gleam/string
import startest/expect
import hanguleam/core/disassemble

pub fn disassemble_tests() {
  describe("disassemble module", [
    describe("basic functionality", [
      it("should disassemble simple characters", fn() {
        let result = disassemble.disassemble("사과")
        result |> expect.to_equal("ㅅㅏㄱㅗㅏ")
      }),
      it("should disassemble single character", fn() {
        let result = disassemble.disassemble("가")
        result |> expect.to_equal("ㄱㅏ")
      }),
      it("should disassemble character with jongseong", fn() {
        let result = disassemble.disassemble("간")
        result |> expect.to_equal("ㄱㅏㄴ")
      }),
      it("should disassemble complex jongseong", fn() {
        let result = disassemble.disassemble("값")
        result |> expect.to_equal("ㄱㅏㅂㅅ")
      }),
    ]),
    describe("standalone jamo", [
      describe("choseong", [
        it("should handle basic choseong characters", fn() {
          let result = disassemble.disassemble("ㄱㄴㄷㄸ")
          result |> expect.to_equal("ㄱㄴㄷㄸ")
        }),
        it("should handle all choseong characters", fn() {
          let result = disassemble.disassemble("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
          result |> expect.to_equal("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
        }),
      ]),
      describe("jungseong", [
        it("should handle basic jungseong characters", fn() {
          let result = disassemble.disassemble("ㅏㅓㅗㅜ")
          result |> expect.to_equal("ㅏㅓㅗㅜ")
        }),
        it("should handle all jungseong characters", fn() {
          let result = disassemble.disassemble("ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ")
          result |> expect.to_equal("ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅗㅏㅗㅐㅗㅣㅛㅜㅜㅓㅜㅔㅜㅣㅠㅡㅡㅣㅣ")
        }),
      ]),
      describe("jongseong", [
        it("should handle basic jongseong characters", fn() {
          let result = disassemble.disassemble("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ")
          result |> expect.to_equal("ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ")
        }),
        it("should handle complex jongseong that decompose", fn() {
          let result = disassemble.disassemble("ㄳㄵㄶㄺㄻㄼㄽㄾㄿㅀㅄ")
          result |> expect.to_equal("ㄱㅅㄴㅈㄴㅎㄹㄱㄹㅁㄹㅂㄹㅅㄹㅌㄹㅍㄹㅎㅂㅅ")
        }),
      ]),
    ]),
    describe("mixed jamo", [
      it("should handle mixed all jamo types", fn() {
        let result = disassemble.disassemble("ㄱㅏㄴㅗㅘㄵ")
        result |> expect.to_equal("ㄱㅏㄴㅗㅗㅏㄴㅈ")
      }),
      it("should handle complete characters mixed with individual jamo", fn() {
        let result = disassemble.disassemble("가ㄱㅏㄴ간")
        result |> expect.to_equal("ㄱㅏㄱㅏㄴㄱㅏㄴ")
      }),
    ]),
    describe("compound vowels", [
      it("should decompose ㅘ → ㅗㅏ", fn() {
        let result = disassemble.disassemble("과")
        result |> expect.to_equal("ㄱㅗㅏ")
      }),
      it("should decompose ㅙ → ㅗㅐ", fn() {
        let result = disassemble.disassemble("괘")
        result |> expect.to_equal("ㄱㅗㅐ")
      }),
      it("should decompose ㅚ → ㅗㅣ", fn() {
        let result = disassemble.disassemble("괴")
        result |> expect.to_equal("ㄱㅗㅣ")
      }),
      it("should decompose ㅝ → ㅜㅓ", fn() {
        let result = disassemble.disassemble("궈")
        result |> expect.to_equal("ㄱㅜㅓ")
      }),
      it("should decompose ㅞ → ㅜㅔ", fn() {
        let result = disassemble.disassemble("궤")
        result |> expect.to_equal("ㄱㅜㅔ")
      }),
      it("should decompose ㅟ → ㅜㅣ", fn() {
        let result = disassemble.disassemble("귀")
        result |> expect.to_equal("ㄱㅜㅣ")
      }),
      it("should decompose ㅢ → ㅡㅣ", fn() {
        let result = disassemble.disassemble("긔")
        result |> expect.to_equal("ㄱㅡㅣ")
      }),
    ]),
    describe("complex jongseong", [
      it("should decompose ㄳ → ㄱㅅ", fn() {
        let result = disassemble.disassemble("몫")
        result |> expect.to_equal("ㅁㅗㄱㅅ")
      }),
      it("should decompose ㄵ → ㄴㅈ", fn() {
        let result = disassemble.disassemble("앉")
        result |> expect.to_equal("ㅇㅏㄴㅈ")
      }),
      it("should decompose ㄶ → ㄴㅎ", fn() {
        let result = disassemble.disassemble("많")
        result |> expect.to_equal("ㅁㅏㄴㅎ")
      }),
      it("should decompose ㄺ → ㄹㄱ", fn() {
        let result = disassemble.disassemble("닭")
        result |> expect.to_equal("ㄷㅏㄹㄱ")
      }),
      it("should decompose ㄻ → ㄹㅁ", fn() {
        let result = disassemble.disassemble("삶")
        result |> expect.to_equal("ㅅㅏㄹㅁ")
      }),
      it("should decompose ㄼ → ㄹㅂ", fn() {
        let result = disassemble.disassemble("넓")
        result |> expect.to_equal("ㄴㅓㄹㅂ")
      }),
      it("should decompose ㄽ → ㄹㅅ", fn() {
        let result = disassemble.disassemble("외곬")
        result |> expect.to_equal("ㅇㅗㅣㄱㅗㄹㅅ")
      }),
      it("should decompose ㄾ → ㄹㅌ", fn() {
        let result = disassemble.disassemble("핥")
        result |> expect.to_equal("ㅎㅏㄹㅌ")
      }),
      it("should decompose ㄿ → ㄹㅍ", fn() {
        let result = disassemble.disassemble("읊")
        result |> expect.to_equal("ㅇㅡㄹㅍ")
      }),
      it("should decompose ㅀ → ㄹㅎ", fn() {
        let result = disassemble.disassemble("싫")
        result |> expect.to_equal("ㅅㅣㄹㅎ")
      }),
      it("should decompose ㅄ → ㅂㅅ", fn() {
        let result = disassemble.disassemble("없")
        result |> expect.to_equal("ㅇㅓㅂㅅ")
      }),
    ]),
    describe("mixed content", [
      it("should handle mixed hangul and non-hangul", fn() {
        let result = disassemble.disassemble("안녕a세계!")
        result |> expect.to_equal("ㅇㅏㄴㄴㅕㅇaㅅㅔㄱㅖ!")
      }),
      it("should handle only non-hangul", fn() {
        let result = disassemble.disassemble("Hello123!")
        result |> expect.to_equal("Hello123!")
      }),
      it("should handle mixed content with spaces", fn() {
        let result = disassemble.disassemble("한글 Korean 123")
        result |> expect.to_equal("ㅎㅏㄴㄱㅡㄹ Korean 123")
      }),
      it("should handle mixed content with punctuation", fn() {
        let result = disassemble.disassemble("안녕하세요, 세계!")
        result |> expect.to_equal("ㅇㅏㄴㄴㅕㅇㅎㅏㅅㅔㅇㅛ, ㅅㅔㄱㅖ!")
      }),
    ]),
    describe("edge cases", [
      it("should handle empty string", fn() {
        let result = disassemble.disassemble("")
        result |> expect.to_equal("")
      }),
      it("should handle single space", fn() {
        let result = disassemble.disassemble(" ")
        result |> expect.to_equal(" ")
      }),
      it("should handle multiple spaces", fn() {
        let result = disassemble.disassemble("   ")
        result |> expect.to_equal("   ")
      }),
      it("should handle newline", fn() {
        let result = disassemble.disassemble("\n")
        result |> expect.to_equal("\n")
      }),
      it("should handle tab", fn() {
        let result = disassemble.disassemble("\t")
        result |> expect.to_equal("\t")
      }),
    ]),
    describe("unicode edge cases", [
      it("should handle unicode emoji", fn() {
        let result = disassemble.disassemble("안녕😊세계")
        result |> expect.to_equal("ㅇㅏㄴㄴㅕㅇ😊ㅅㅔㄱㅖ")
      }),
      it("should handle unicode symbols", fn() {
        let result = disassemble.disassemble("한글★♥♦")
        result |> expect.to_equal("ㅎㅏㄴㄱㅡㄹ★♥♦")
      }),
    ]),
    describe("real world examples", [
      it("should handle korean word", fn() {
        let result = disassemble.disassemble("한글")
        result |> expect.to_equal("ㅎㅏㄴㄱㅡㄹ")
      }),
      it("should handle korean sentence", fn() {
        let result = disassemble.disassemble("안녕 세계")
        result |> expect.to_equal("ㅇㅏㄴㄴㅕㅇ ㅅㅔㄱㅖ")
      }),
      it("should handle complex korean word", fn() {
        let result = disassemble.disassemble("굽었던")
        result |> expect.to_equal("ㄱㅜㅂㅇㅓㅆㄷㅓㄴ")
      }),
      it("should handle korean name", fn() {
        let result = disassemble.disassemble("김철수")
        result |> expect.to_equal("ㄱㅣㅁㅊㅓㄹㅅㅜ")
      }),
    ]),
    describe("comprehensive tests", [
      it("should handle all compound vowels", fn() {
        let result = disassemble.disassemble("과괘괴궈궤귀긔")
        result |> expect.to_equal("ㄱㅗㅏㄱㅗㅐㄱㅗㅣㄱㅜㅓㄱㅜㅔㄱㅜㅣㄱㅡㅣ")
      }),
      it("should handle multiple complex jongseong", fn() {
        let result = disassemble.disassemble("몫앉많닭")
        result |> expect.to_equal("ㅁㅗㄱㅅㅇㅏㄴㅈㅁㅏㄴㅎㄷㅏㄹㄱ")
      }),
    ]),
    describe("stress tests", [
      it("should handle long text", fn() {
        let result = disassemble.disassemble("대한민국의 아름다운 한글은 세종대왕이 만드셨습니다")
        result
        |> expect.to_equal(
          "ㄷㅐㅎㅏㄴㅁㅣㄴㄱㅜㄱㅇㅡㅣ ㅇㅏㄹㅡㅁㄷㅏㅇㅜㄴ ㅎㅏㄴㄱㅡㄹㅇㅡㄴ ㅅㅔㅈㅗㅇㄷㅐㅇㅗㅏㅇㅇㅣ ㅁㅏㄴㄷㅡㅅㅕㅆㅅㅡㅂㄴㅣㄷㅏ",
        )
      }),
      it("should handle repeated characters", fn() {
        let result = disassemble.disassemble("가가가나나나")
        result |> expect.to_equal("ㄱㅏㄱㅏㄱㅏㄴㅏㄴㅏㄴㅏ")
      }),
    ]),
    describe("boundary tests", [
      it("should handle first complete hangul character", fn() {
        let result = disassemble.disassemble("가")
        result |> expect.to_equal("ㄱㅏ")
      }),
      it("should handle last complete hangul character", fn() {
        let result = disassemble.disassemble("힣")
        result |> expect.to_equal("ㅎㅣㅎ")
      }),
    ]),
    describe("integration test", [
      it("should be consistent with disassemble_to_groups", fn() {
        let text = "값진 한글"
        let disassemble_result = disassemble.disassemble(text)
        let groups_result =
          disassemble.disassemble_to_groups(text)
          |> list.flatten
          |> string.join("")

        disassemble_result |> expect.to_equal(groups_result)
        disassemble_result |> expect.to_equal("ㄱㅏㅂㅅㅈㅣㄴ ㅎㅏㄴㄱㅡㄹ")
      }),
    ]),
  ])
}