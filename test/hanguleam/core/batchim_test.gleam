import gleam/option.{Some}
import startest/expect
import hanguleam/core/batchim
import hanguleam/internal/types.{Double, NoBatchim, Single}

// Test character with batchim
pub fn has_batchim_with_batchim_test() {
  batchim.has_batchim("강")
  |> expect.to_equal(True)
}

// Test character without batchim
pub fn has_batchim_without_batchim_test() {
  batchim.has_batchim("가")
  |> expect.to_equal(False)
}

// Test empty string
pub fn has_batchim_empty_test() {
  batchim.has_batchim("")
  |> expect.to_equal(False)
}

// Test non-Korean character
pub fn has_batchim_non_korean_test() {
  batchim.has_batchim("a")
  |> expect.to_equal(False)
}

// Test single batchim filter - characters with single batchim
pub fn has_single_batchim_true_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim_with_options(
    "강",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(True)

  // "한" has ㄴ (single batchim)
  batchim.has_batchim_with_options(
    "한",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(True)

  // "밥" has ㅂ (single batchim)
  batchim.has_batchim_with_options(
    "밥",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(True)
}

// Test single batchim filter - characters with double/compound batchim should fail
pub fn has_single_batchim_false_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim_with_options(
    "닭",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(False)

  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim_with_options(
    "앉",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(False)
}

// Test double batchim filter - characters with compound batchim
pub fn has_double_batchim_true_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim_with_options(
    "닭",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(True)

  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim_with_options(
    "앉",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(True)

  // "값" has ㅄ (compound: ㅂ+ㅅ)
  batchim.has_batchim_with_options(
    "값",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(True)
}

// Test double batchim filter - characters with single batchim should fail
pub fn has_double_batchim_false_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim_with_options(
    "강",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(False)

  // "한" has ㄴ (single batchim)
  batchim.has_batchim_with_options(
    "한",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(False)
}

// Test characters without batchim should fail both filters
pub fn no_batchim_filters_test() {
  // "가" has no batchim
  batchim.has_batchim_with_options(
    "가",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
  )
  |> expect.to_equal(False)

  batchim.has_batchim_with_options(
    "가",
    options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
  )
  |> expect.to_equal(False)
}

// Test simple has_batchim function (without options)
pub fn has_batchim_simple_with_batchim_test() {
  batchim.has_batchim("강") |> expect.to_equal(True)
  batchim.has_batchim("닭") |> expect.to_equal(True)
  batchim.has_batchim("값") |> expect.to_equal(True)
}

pub fn has_batchim_simple_without_batchim_test() {
  batchim.has_batchim("가") |> expect.to_equal(False)
  batchim.has_batchim("토") |> expect.to_equal(False)
}

// ===== get_batchim function tests =====

// Test get_batchim with character that has no batchim
pub fn get_batchim_no_batchim_test() {
  case batchim.get_batchim("가") {
    Ok(info) -> {
      info.character |> expect.to_equal("가")
      info.batchim_type |> expect.to_equal(NoBatchim)
      info.components |> expect.to_equal([])
    }
    Error(_) -> expect.to_be_true(False)
  }
}

// Test get_batchim with character that has single batchim
pub fn get_batchim_single_batchim_test() {
  case batchim.get_batchim("강") {
    Ok(info) -> {
      info.character |> expect.to_equal("강")
      info.batchim_type |> expect.to_equal(Single)
      info.components |> expect.to_equal(["ㅇ"])
    }
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("한") {
    Ok(info) -> {
      info.character |> expect.to_equal("한")
      info.batchim_type |> expect.to_equal(Single)
      info.components |> expect.to_equal(["ㄴ"])
    }
    Error(_) -> expect.to_be_true(False)
  }
}

// Test get_batchim with character that has double batchim
pub fn get_batchim_double_batchim_test() {
  case batchim.get_batchim("닭") {
    Ok(info) -> {
      info.character |> expect.to_equal("닭")
      info.batchim_type |> expect.to_equal(Double)
      info.components |> expect.to_equal(["ㄹ", "ㄱ"])
    }
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("값") {
    Ok(info) -> {
      info.character |> expect.to_equal("값")
      info.batchim_type |> expect.to_equal(Double)
      info.components |> expect.to_equal(["ㅂ", "ㅅ"])
    }
    Error(_) -> expect.to_be_true(False)
  }
}

// Test get_batchim error cases
pub fn get_batchim_empty_string_test() {
  case batchim.get_batchim("") {
    Ok(_) -> expect.to_be_true(False)
    Error(batchim.EmptyString) -> expect.to_be_true(True)
    Error(_) -> expect.to_be_true(False)
  }
}

pub fn get_batchim_not_complete_hangul_test() {
  case batchim.get_batchim("ㄱ") {
    Ok(_) -> expect.to_be_true(False)
    Error(batchim.InvalidCharacter("ㄱ")) -> expect.to_be_true(True)
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("ㅏ") {
    Ok(_) -> expect.to_be_true(False)
    Error(batchim.InvalidCharacter("ㅏ")) -> expect.to_be_true(True)
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("a") {
    Ok(_) -> expect.to_be_true(False)
    Error(batchim.InvalidCharacter("a")) -> expect.to_be_true(True)
    Error(_) -> expect.to_be_true(False)
  }
}

// Test get_batchim with multi-character strings (should use last character)
pub fn get_batchim_multi_character_test() {
  case batchim.get_batchim("안녕하세요") {
    Ok(info) -> {
      info.character |> expect.to_equal("요")
      info.batchim_type |> expect.to_equal(NoBatchim)
      info.components |> expect.to_equal([])
    }
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("한글") {
    Ok(info) -> {
      info.character |> expect.to_equal("글")
      info.batchim_type |> expect.to_equal(Single)
      info.components |> expect.to_equal(["ㄹ"])
    }
    Error(_) -> expect.to_be_true(False)
  }

  case batchim.get_batchim("화가 난 까닭") {
    Ok(info) -> {
      info.character |> expect.to_equal("닭")
      info.batchim |> expect.to_equal("ㄺ")
      info.batchim_type |> expect.to_equal(Double)
      info.components |> expect.to_equal(["ㄹ", "ㄱ"])
    }
    Error(_) -> expect.to_be_true(False)
  }
}
