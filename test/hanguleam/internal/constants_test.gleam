import gleeunit/should
import gleam/dict
import gleam/string
import hanguleam/internal/constants

// Test that the mapping table works correctly
pub fn disassembled_consonants_basic_test() {
  let mapping = constants.get_disassembled_consonants()
  
  // Test single consonants
  dict.get(mapping, "ㄱ")
  |> should.equal(Ok("ㄱ"))
  
  dict.get(mapping, "ㄴ")
  |> should.equal(Ok("ㄴ"))
}

// Test compound consonants
pub fn disassembled_consonants_compound_test() {
  let mapping = constants.get_disassembled_consonants()
  
  // Test compound consonants have length > 1
  dict.get(mapping, "ㄳ")
  |> should.equal(Ok("ㄱㅅ"))
  
  dict.get(mapping, "ㄵ")
  |> should.equal(Ok("ㄴㅈ"))
  
  dict.get(mapping, "ㅄ")
  |> should.equal(Ok("ㅂㅅ"))
}

// Test that compound consonants have length > 1
pub fn compound_consonants_length_test() {
  let mapping = constants.get_disassembled_consonants()
  
  let assert Ok(disassembled) = dict.get(mapping, "ㄳ")
  string.length(disassembled)
  |> should.equal(2)
  
  let assert Ok(disassembled) = dict.get(mapping, "ㄺ")
  string.length(disassembled)
  |> should.equal(2)
}

// Test that single consonants have length = 1
pub fn single_consonants_length_test() {
  let mapping = constants.get_disassembled_consonants()
  
  let assert Ok(disassembled) = dict.get(mapping, "ㄱ")
  string.length(disassembled)
  |> should.equal(1)
  
  let assert Ok(disassembled) = dict.get(mapping, "ㅇ")
  string.length(disassembled)
  |> should.equal(1)
}

// Test empty string
pub fn empty_consonant_test() {
  let mapping = constants.get_disassembled_consonants()
  
  dict.get(mapping, "")
  |> should.equal(Ok(""))
}