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
