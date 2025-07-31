import hanguleam/internal/constants

pub fn combine_vowels(vowel1: String, vowel2: String) -> String {
  let combination = vowel1 <> vowel2

  case constants.assemble_vowel_string(combination) {
    Ok(assembled) -> assembled
    Error(_) -> combination
  }
}
