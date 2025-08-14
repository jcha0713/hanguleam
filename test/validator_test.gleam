import hanguleam/validator
import startest.{describe, it}
import startest/expect

pub fn validator_tests() {
  describe("validator module", [
    describe("choseong validation", [
      it("should validator valid choseong", fn() {
        validator.can_be_choseong("ㄱ") |> expect.to_equal(True)
        validator.can_be_choseong("ㅃ") |> expect.to_equal(True)
      }),
      it("should reject invalid choseong", fn() {
        validator.can_be_choseong("ㄱㅅ") |> expect.to_equal(False)
        validator.can_be_choseong("ㅏ") |> expect.to_equal(False)
        validator.can_be_choseong("가") |> expect.to_equal(False)
        validator.can_be_choseong("ㄱa") |> expect.to_equal(False)
      }),
      it("should validate modern jamo choseong", fn() {
        // Modern jamo equivalents of compatibility jamo using Unicode literals
        validator.can_be_choseong("\u{1100}") |> expect.to_equal(True)
        // ᄀ (ㄱ)
        validator.can_be_choseong("\u{1101}") |> expect.to_equal(True)
        // ᄁ (ㄲ)
        validator.can_be_choseong("\u{1102}") |> expect.to_equal(True)
        // ᄂ (ㄴ)
        validator.can_be_choseong("\u{1112}") |> expect.to_equal(True)
        // ᄒ (ㅎ)
      }),
    ]),
    describe("jungseong validation", [
      it("should validator valid jungseong", fn() {
        validator.can_be_jungseong("ㅏ") |> expect.to_equal(True)
        validator.can_be_jungseong("ㅗㅏ") |> expect.to_equal(True)
        validator.can_be_jungseong("ㅘ") |> expect.to_equal(True)
      }),
      it("should reject invalid jungseong", fn() {
        validator.can_be_jungseong("ㅏㅗ") |> expect.to_equal(False)
        validator.can_be_jungseong("ㄱ") |> expect.to_equal(False)
        validator.can_be_jungseong("ㄱㅅ") |> expect.to_equal(False)
        validator.can_be_jungseong("가") |> expect.to_equal(False)
      }),
      it("should validate modern jamo jungseong", fn() {
        // Modern jamo equivalents of compatibility jamo using Unicode literals
        validator.can_be_jungseong("\u{1161}") |> expect.to_equal(True)
        // ᅡ (ㅏ)
        validator.can_be_jungseong("\u{1162}") |> expect.to_equal(True)
        // ᅢ (ㅐ)
        validator.can_be_jungseong("\u{1169}") |> expect.to_equal(True)
        // ᅩ (ㅗ)
        validator.can_be_jungseong("\u{1175}") |> expect.to_equal(True)
        // ᅵ (ㅣ)
      }),
    ]),
    describe("jongseong validation", [
      it("should validator valid jongseong", fn() {
        validator.can_be_jongseong("ㄱ") |> expect.to_equal(True)
        validator.can_be_jongseong("ㄱㅅ") |> expect.to_equal(True)
        validator.can_be_jongseong("ㄳ") |> expect.to_equal(True)
        validator.can_be_jongseong("ㄹㅎ") |> expect.to_equal(True)
      }),
      it("should reject invalid jongseong", fn() {
        validator.can_be_jongseong("ㅎㄹ") |> expect.to_equal(False)
        validator.can_be_jongseong("가") |> expect.to_equal(False)
        validator.can_be_jongseong("ㅏ") |> expect.to_equal(False)
        validator.can_be_jongseong("ㅗㅏ") |> expect.to_equal(False)
      }),
      it("should validate modern jamo jongseong", fn() {
        // Modern jamo equivalents of compatibility jamo using Unicode literals
        validator.can_be_jongseong("\u{11A8}") |> expect.to_equal(True)
        // ᆨ (ㄱ)
        validator.can_be_jongseong("\u{11AB}") |> expect.to_equal(True)
        // ᆫ (ㄴ)
        validator.can_be_jongseong("\u{11AF}") |> expect.to_equal(True)
        // ᆯ (ㄹ)
        validator.can_be_jongseong("\u{11C2}") |> expect.to_equal(True)
        // ᇂ (ㅎ)
      }),
    ]),
  ])
}
