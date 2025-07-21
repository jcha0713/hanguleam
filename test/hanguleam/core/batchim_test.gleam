import gleam/option.{Some}
import gleeunit/should
import hanguleam/core/batchim

// Test character with batchim
pub fn has_batchim_with_batchim_test() {
  batchim.has_batchim("강")
  |> should.equal(True)
}

// Test character without batchim
pub fn has_batchim_without_batchim_test() {
  batchim.has_batchim("가")
  |> should.equal(False)
}

// Test empty string
pub fn has_batchim_empty_test() {
  batchim.has_batchim("")
  |> should.equal(False)
}

// Test non-Korean character
pub fn has_batchim_non_korean_test() {
  batchim.has_batchim("a")
  |> should.equal(False)
}

// Test single batchim filter - characters with single batchim
pub fn has_single_batchim_true_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim_with_options(
    "강",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(True)

  // "한" has ㄴ (single batchim)
  batchim.has_batchim_with_options(
    "한",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(True)

  // "밥" has ㅂ (single batchim)
  batchim.has_batchim_with_options(
    "밥",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(True)
}

// Test single batchim filter - characters with double/compound batchim should fail
pub fn has_single_batchim_false_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim_with_options(
    "닭",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(False)

  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim_with_options(
    "앉",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(False)
}

// Test double batchim filter - characters with compound batchim
pub fn has_double_batchim_true_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim_with_options(
    "닭",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(True)

  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim_with_options(
    "앉",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(True)

  // "값" has ㅄ (compound: ㅂ+ㅅ)
  batchim.has_batchim_with_options(
    "값",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(True)
}

// Test double batchim filter - characters with single batchim should fail
pub fn has_double_batchim_false_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim_with_options(
    "강",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(False)

  // "한" has ㄴ (single batchim)
  batchim.has_batchim_with_options(
    "한",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(False)
}

// Test characters without batchim should fail both filters
pub fn no_batchim_filters_test() {
  // "가" has no batchim
  batchim.has_batchim_with_options(
    "가",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> should.equal(False)

  batchim.has_batchim_with_options(
    "가",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> should.equal(False)
}

// Test simple has_batchim function (without options)
pub fn has_batchim_simple_with_batchim_test() {
  batchim.has_batchim("강") |> should.equal(True)
  batchim.has_batchim("닭") |> should.equal(True)
  batchim.has_batchim("값") |> should.equal(True)
}

pub fn has_batchim_simple_without_batchim_test() {
  batchim.has_batchim("가") |> should.equal(False)
  batchim.has_batchim("토") |> should.equal(False)
}

// ===== get_batchim function tests =====

// Test get_batchim with character that has no batchim
pub fn get_batchim_no_batchim_test() {
  case batchim.get_batchim("가") {
    Ok(info) -> {
      info.character |> should.equal("가")
      info.batchim_type |> should.equal(batchim.NoBatchim)
      info.components |> should.equal([])
    }
    Error(_) -> should.fail()
  }
}

// Test get_batchim with character that has single batchim
pub fn get_batchim_single_batchim_test() {
  case batchim.get_batchim("강") {
    Ok(info) -> {
      info.character |> should.equal("강")
      info.batchim_type |> should.equal(batchim.Single)
      info.components |> should.equal(["ㅇ"])
    }
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("한") {
    Ok(info) -> {
      info.character |> should.equal("한")
      info.batchim_type |> should.equal(batchim.Single)
      info.components |> should.equal(["ㄴ"])
    }
    Error(_) -> should.fail()
  }
}

// Test get_batchim with character that has double batchim
pub fn get_batchim_double_batchim_test() {
  case batchim.get_batchim("닭") {
    Ok(info) -> {
      info.character |> should.equal("닭")
      info.batchim_type |> should.equal(batchim.Double)
      info.components |> should.equal(["ㄹ", "ㄱ"])
    }
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("값") {
    Ok(info) -> {
      info.character |> should.equal("값")
      info.batchim_type |> should.equal(batchim.Double)
      info.components |> should.equal(["ㅂ", "ㅅ"])
    }
    Error(_) -> should.fail()
  }
}

// Test get_batchim error cases
pub fn get_batchim_empty_string_test() {
  case batchim.get_batchim("") {
    Ok(_) -> should.fail()
    Error(batchim.EmptyString) -> should.be_true(True)
    Error(_) -> should.fail()
  }
}

pub fn get_batchim_not_complete_hangul_test() {
  case batchim.get_batchim("ㄱ") {
    Ok(_) -> should.fail()
    Error(batchim.InvalidCharacter("ㄱ")) -> should.be_true(True)
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("ㅏ") {
    Ok(_) -> should.fail()
    Error(batchim.InvalidCharacter("ㅏ")) -> should.be_true(True)
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("a") {
    Ok(_) -> should.fail()
    Error(batchim.InvalidCharacter("a")) -> should.be_true(True)
    Error(_) -> should.fail()
  }
}

// Test get_batchim with multi-character strings (should use last character)
pub fn get_batchim_multi_character_test() {
  case batchim.get_batchim("안녕하세요") {
    Ok(info) -> {
      info.character |> should.equal("요")
      info.batchim_type |> should.equal(batchim.NoBatchim)
      info.components |> should.equal([])
    }
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("한글") {
    Ok(info) -> {
      info.character |> should.equal("글")
      info.batchim_type |> should.equal(batchim.Single)
      info.components |> should.equal(["ㄹ"])
    }
    Error(_) -> should.fail()
  }

  case batchim.get_batchim("화가 난 까닭") {
    Ok(info) -> {
      info.character |> should.equal("닭")
      info.batchim_type |> should.equal(batchim.Double)
      info.components |> should.equal(["ㄹ", "ㄱ"])
    }
    Error(_) -> should.fail()
  }
}
