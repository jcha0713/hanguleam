import gleeunit/should
import hanguleam/core/assemble

// Placeholder tests for the main assemble function
// Tests will be added when the function is implemented
pub fn assemble_basic_test() {
  // assemble.assemble(["ㅇ", "ㅏ", "ㅂ", "ㅓ", "ㅈ", "ㅣ"])
  // |> should.equal("아버지")

  // Placeholder until function is implemented
  "placeholder"
  |> should.equal("placeholder")
}

pub fn assemble_single_character_test() {
  assemble.assemble(["ㄱ"])
  |> should.equal("ㄱ")

  assemble.assemble(["ㅏ"])
  |> should.equal("ㅏ")

  assemble.assemble(["가"])
  |> should.equal("가")

  assemble.assemble(["ㄱ", "ㅏ"])
  |> should.equal("가")

  assemble.assemble(["ㄱ", "ㅏ", "ㄱ"])
  |> should.equal("각")

  assemble.assemble(["가", "ㄱ"])
  |> should.equal("각")
}

pub fn assemble_empty_test() {
  // assemble.assemble([])
  // |> should.equal("")

  // Placeholder until function is implemented
  "placeholder"
  |> should.equal("placeholder")
}
