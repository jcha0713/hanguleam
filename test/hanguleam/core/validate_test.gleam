import gleeunit/should
import hanguleam/core/validate

pub fn validate_choseong_test() {
  validate.can_be_choseong("ㄱ") |> should.equal(True)
  validate.can_be_choseong("ㅃ") |> should.equal(True)

  validate.can_be_choseong("ㄱㅅ") |> should.equal(False)
  validate.can_be_choseong("ㅏ") |> should.equal(False)
  validate.can_be_choseong("가") |> should.equal(False)
  validate.can_be_choseong("ㄱa") |> should.equal(False)
}

pub fn validate_jungseong_test() {
  validate.can_be_jungseong("ㅏ") |> should.equal(True)
  validate.can_be_jungseong("ㅗㅏ") |> should.equal(True)
  validate.can_be_jungseong("ㅘ") |> should.equal(True)

  validate.can_be_jungseong("ㅏㅗ") |> should.equal(False)
  validate.can_be_jungseong("ㄱ") |> should.equal(False)
  validate.can_be_jungseong("ㄱㅅ") |> should.equal(False)
  validate.can_be_jungseong("가") |> should.equal(False)
}

pub fn validate_jongseong_test() {
  validate.can_be_jongseong("ㄱ") |> should.equal(True)
  validate.can_be_jongseong("ㄱㅅ") |> should.equal(True)
  validate.can_be_jongseong("ㄳ") |> should.equal(True)
  validate.can_be_jongseong("ㄹㅎ") |> should.equal(True)

  validate.can_be_jongseong("ㅎㄹ") |> should.equal(False)
  validate.can_be_jongseong("가") |> should.equal(False)
  validate.can_be_jongseong("ㅏ") |> should.equal(False)
  validate.can_be_jongseong("ㅗㅏ") |> should.equal(False)
}
