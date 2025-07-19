import gleam/option.{None, Some}
import gleeunit/should
import hanguleam/core/batchim

// Test character with batchim
pub fn has_batchim_with_batchim_test() {
  batchim.has_batchim("강", options: None)
  |> should.equal(True)
}

// Test character without batchim
pub fn has_batchim_without_batchim_test() {
  batchim.has_batchim("가", options: None)
  |> should.equal(False)
}

// Test empty string
pub fn has_batchim_empty_test() {
  batchim.has_batchim("", options: None)
  |> should.equal(False)
}

// Test non-Korean character
pub fn has_batchim_non_korean_test() {
  batchim.has_batchim("a", options: None)
  |> should.equal(False)
}

// Test single batchim filter - characters with single batchim
pub fn has_single_batchim_true_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim("강", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(True)
  
  // "한" has ㄴ (single batchim)
  batchim.has_batchim("한", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(True)
  
  // "밥" has ㅂ (single batchim)
  batchim.has_batchim("밥", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(True)
}

// Test single batchim filter - characters with double/compound batchim should fail
pub fn has_single_batchim_false_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim("닭", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(False)
  
  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim("앉", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(False)
}

// Test double batchim filter - characters with compound batchim
pub fn has_double_batchim_true_test() {
  // "닭" has ㄺ (compound: ㄹ+ㄱ)
  batchim.has_batchim("닭", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(True)
  
  // "앉" has ㄵ (compound: ㄴ+ㅈ)
  batchim.has_batchim("앉", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(True)
  
  // "값" has ㅄ (compound: ㅂ+ㅅ)
  batchim.has_batchim("값", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(True)
}

// Test double batchim filter - characters with single batchim should fail
pub fn has_double_batchim_false_test() {
  // "강" has ㅇ (single batchim)
  batchim.has_batchim("강", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(False)
  
  // "한" has ㄴ (single batchim)
  batchim.has_batchim("한", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(False)
}

// Test characters without batchim should fail both filters
pub fn no_batchim_filters_test() {
  // "가" has no batchim
  batchim.has_batchim("가", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Single))))
  |> should.equal(False)
  
  batchim.has_batchim("가", options: Some(batchim.HasBatchimOptions(only: Some(batchim.Double))))
  |> should.equal(False)
}
