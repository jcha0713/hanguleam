import startest/expect
import hanguleam/core/validate

pub fn validate_choseong_test() {
  validate.can_be_choseong("ㄱ") |> expect.to_equal(True)
  validate.can_be_choseong("ㅃ") |> expect.to_equal(True)

  validate.can_be_choseong("ㄱㅅ") |> expect.to_equal(False)
  validate.can_be_choseong("ㅏ") |> expect.to_equal(False)
  validate.can_be_choseong("가") |> expect.to_equal(False)
  validate.can_be_choseong("ㄱa") |> expect.to_equal(False)
}

pub fn validate_jungseong_test() {
  validate.can_be_jungseong("ㅏ") |> expect.to_equal(True)
  validate.can_be_jungseong("ㅗㅏ") |> expect.to_equal(True)
  validate.can_be_jungseong("ㅘ") |> expect.to_equal(True)

  validate.can_be_jungseong("ㅏㅗ") |> expect.to_equal(False)
  validate.can_be_jungseong("ㄱ") |> expect.to_equal(False)
  validate.can_be_jungseong("ㄱㅅ") |> expect.to_equal(False)
  validate.can_be_jungseong("가") |> expect.to_equal(False)
}

pub fn validate_jongseong_test() {
  validate.can_be_jongseong("ㄱ") |> expect.to_equal(True)
  validate.can_be_jongseong("ㄱㅅ") |> expect.to_equal(True)
  validate.can_be_jongseong("ㄳ") |> expect.to_equal(True)
  validate.can_be_jongseong("ㄹㅎ") |> expect.to_equal(True)

  validate.can_be_jongseong("ㅎㄹ") |> expect.to_equal(False)
  validate.can_be_jongseong("가") |> expect.to_equal(False)
  validate.can_be_jongseong("ㅏ") |> expect.to_equal(False)
  validate.can_be_jongseong("ㅗㅏ") |> expect.to_equal(False)
}
