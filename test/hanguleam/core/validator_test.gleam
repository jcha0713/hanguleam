import hanguleam/core/validator
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
    ]),
  ])
}
