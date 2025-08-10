import startest.{describe, it}
import startest/expect
import hanguleam/core/disassemble.{
  type DisassembleError, EmptyString, IncompleteHangul, NonHangulCharacter,
}
import hanguleam/internal/types.{
  type HangulSyllable, Choseong, HangulSyllable, Jongseong, Jungseong,
}

// Helper functions to reduce repetition
fn assert_disassemble_ok(input: String, expected: HangulSyllable) {
  disassemble.disassemble_complete_character(input)
  |> expect.to_equal(Ok(expected))
}

fn assert_disassemble_error(input: String, expected_error: DisassembleError) {
  disassemble.disassemble_complete_character(input)
  |> expect.to_equal(Error(expected_error))
}

pub fn disassemble_complete_character_tests() {
  describe("disassemble_complete_character function", [
    describe("success cases", [
      it("should handle character with jongseong", fn() {
        assert_disassemble_ok(
          "몽",
          HangulSyllable(Choseong("ㅁ"), Jungseong("ㅗ"), Jongseong("ㅇ")),
        )
      }),
      it("should handle character without jongseong", fn() {
        assert_disassemble_ok(
          "가",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("")),
        )
      }),
      it("should handle complex jongseong", fn() {
        assert_disassemble_ok(
          "쀍",
          HangulSyllable(Choseong("ㅃ"), Jungseong("ㅜㅔ"), Jongseong("ㄹㄱ")),
        )
      }),
      it("should handle first hangul character", fn() {
        assert_disassemble_ok(
          "가",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("")),
        )
      }),
      it("should handle last hangul character", fn() {
        assert_disassemble_ok(
          "힣",
          HangulSyllable(Choseong("ㅎ"), Jungseong("ㅣ"), Jongseong("ㅎ")),
        )
      }),
    ]),
    describe("various jamo", [
      it("should handle various choseong", fn() {
        assert_disassemble_ok(
          "나",
          HangulSyllable(Choseong("ㄴ"), Jungseong("ㅏ"), Jongseong("")),
        )

        assert_disassemble_ok(
          "다",
          HangulSyllable(Choseong("ㄷ"), Jungseong("ㅏ"), Jongseong("")),
        )

        assert_disassemble_ok(
          "싸",
          HangulSyllable(Choseong("ㅆ"), Jungseong("ㅏ"), Jongseong("")),
        )

        assert_disassemble_ok(
          "강아지",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㅇ")),
        )
      }),
      it("should handle various jungseong", fn() {
        assert_disassemble_ok(
          "고",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅗ"), Jongseong("")),
        )

        assert_disassemble_ok(
          "구",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅜ"), Jongseong("")),
        )

        assert_disassemble_ok(
          "괘",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅗㅐ"), Jongseong("")),
        )
      }),
      it("should handle complex jongseong cases", fn() {
        assert_disassemble_ok(
          "갃",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄱㅅ")),
        )

        assert_disassemble_ok(
          "갅",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄴㅈ")),
        )

        assert_disassemble_ok(
          "갊",
          HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㄹㅁ")),
        )
      }),
    ]),
    describe("error cases", [
      it("should handle empty string", fn() {
        assert_disassemble_error("", EmptyString)
      }),
      it("should handle incomplete hangul", fn() {
        assert_disassemble_error("ㄱ", IncompleteHangul)
        assert_disassemble_error("ㅏ", IncompleteHangul)
        assert_disassemble_error("ㅇ", IncompleteHangul)
      }),
      it("should handle non-hangul characters", fn() {
        assert_disassemble_error("a", NonHangulCharacter)
        assert_disassemble_error("1", NonHangulCharacter)
        assert_disassemble_error("!", NonHangulCharacter)
        assert_disassemble_error(" ", NonHangulCharacter)
        assert_disassemble_error("中", NonHangulCharacter)
        assert_disassemble_error("あ", NonHangulCharacter)
      }),
    ]),
  ])
}