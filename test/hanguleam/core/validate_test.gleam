import hanguleam/core/validate
import startest.{describe, it}
import startest/expect

pub fn validate_tests() {
  describe("validate module", [
    describe("choseong validation", [
      it("should validate valid choseong", fn() {
        validate.can_be_choseong("ㄱ") |> expect.to_equal(True)
        validate.can_be_choseong("ㅃ") |> expect.to_equal(True)
      }),
      it("should reject invalid choseong", fn() {
        validate.can_be_choseong("ㄱㅅ") |> expect.to_equal(False)
        validate.can_be_choseong("ㅏ") |> expect.to_equal(False)
        validate.can_be_choseong("가") |> expect.to_equal(False)
        validate.can_be_choseong("ㄱa") |> expect.to_equal(False)
      }),
    ]),
    describe("jungseong validation", [
      it("should validate valid jungseong", fn() {
        validate.can_be_jungseong("ㅏ") |> expect.to_equal(True)
        validate.can_be_jungseong("ㅗㅏ") |> expect.to_equal(True)
        validate.can_be_jungseong("ㅘ") |> expect.to_equal(True)
      }),
      it("should reject invalid jungseong", fn() {
        validate.can_be_jungseong("ㅏㅗ") |> expect.to_equal(False)
        validate.can_be_jungseong("ㄱ") |> expect.to_equal(False)
        validate.can_be_jungseong("ㄱㅅ") |> expect.to_equal(False)
        validate.can_be_jungseong("가") |> expect.to_equal(False)
      }),
    ]),
    describe("jongseong validation", [
      it("should validate valid jongseong", fn() {
        validate.can_be_jongseong("ㄱ") |> expect.to_equal(True)
        validate.can_be_jongseong("ㄱㅅ") |> expect.to_equal(True)
        validate.can_be_jongseong("ㄳ") |> expect.to_equal(True)
        validate.can_be_jongseong("ㄹㅎ") |> expect.to_equal(True)
      }),
      it("should reject invalid jongseong", fn() {
        validate.can_be_jongseong("ㅎㄹ") |> expect.to_equal(False)
        validate.can_be_jongseong("가") |> expect.to_equal(False)
        validate.can_be_jongseong("ㅏ") |> expect.to_equal(False)
        validate.can_be_jongseong("ㅗㅏ") |> expect.to_equal(False)
      }),
    ]),
  ])
}
