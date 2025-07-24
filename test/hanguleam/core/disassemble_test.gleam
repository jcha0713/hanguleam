// Main disassemble module tests
// This file can be used for integration tests or module-level tests
// Individual function tests are in separate files:
// - disassemble_complete_character_test.gleam
// - disassemble_to_groups_test.gleam

import gleeunit/should
import hanguleam/core/disassemble

// Integration test example - testing multiple functions together
pub fn disassemble_integration_test() {
  // Test that disassemble_complete_character and disassemble_to_groups work together
  let char = "값"
  
  // Test complete character disassembly
  let complete_result = disassemble.disassemble_complete_character(char)
  complete_result |> should.be_ok()
  
  // Test groups disassembly
  let groups_result = disassemble.disassemble_to_groups(char)
  groups_result |> should.equal([["ㄱ", "ㅏ", "ㅂ", "ㅅ"]])
}