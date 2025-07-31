import gleeunit/should
import hanguleam/core/assemble

pub fn combine_vowels_valid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅏ")
  |> should.equal("ㅘ")
  
  assemble.combine_vowels("ㅗ", "ㅐ")
  |> should.equal("ㅙ")
  
  assemble.combine_vowels("ㅗ", "ㅣ")
  |> should.equal("ㅚ")
  
  assemble.combine_vowels("ㅜ", "ㅓ")
  |> should.equal("ㅝ")
  
  assemble.combine_vowels("ㅜ", "ㅔ")
  |> should.equal("ㅞ")
  
  assemble.combine_vowels("ㅜ", "ㅣ")
  |> should.equal("ㅟ")
  
  assemble.combine_vowels("ㅡ", "ㅣ")
  |> should.equal("ㅢ")
}

pub fn combine_vowels_invalid_combinations_test() {
  assemble.combine_vowels("ㅗ", "ㅛ")
  |> should.equal("ㅗㅛ")
  
  assemble.combine_vowels("ㅏ", "ㅓ")
  |> should.equal("ㅏㅓ")
  
  assemble.combine_vowels("ㅣ", "ㅏ")
  |> should.equal("ㅣㅏ")
  
  assemble.combine_vowels("ㅜ", "ㅏ")
  |> should.equal("ㅜㅏ")
}

pub fn combine_vowels_single_vowels_test() {
  assemble.combine_vowels("ㅏ", "")
  |> should.equal("ㅏ")
  
  assemble.combine_vowels("", "ㅓ")
  |> should.equal("ㅓ")
  
  assemble.combine_vowels("", "")
  |> should.equal("")
}