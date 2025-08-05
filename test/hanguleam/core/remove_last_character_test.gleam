import gleeunit/should

import hanguleam/core/disassemble

pub fn remove_last_character_korean_syllables_test() {
  // Simple CV syllable (초성 + 중성)
  disassemble.remove_last_character("아") |> should.equal("ㅇ")

  // Compound vowel cases (복합 모음)  
  disassemble.remove_last_character("점괘") |> should.equal("점고")
  disassemble.remove_last_character("전화") |> should.equal("전호")
  disassemble.remove_last_character("과") |> should.equal("고")

  // Simple CVC syllable (초성 + 중성 + 종성)
  disassemble.remove_last_character("수박") |> should.equal("수바")

  // Compound CVC
  disassemble.remove_last_character("괌") |> should.equal("과")

  // Complex batchim cases (복합 받침)
  disassemble.remove_last_character("값") |> should.equal("갑")
  disassemble.remove_last_character("여덟") |> should.equal("여덜")

  // Compound complex batchim cases
  disassemble.remove_last_character("홟") |> should.equal("활")
}

pub fn remove_last_character_edge_cases_test() {
  // Empty input
  disassemble.remove_last_character("") |> should.equal("")

  // Single jamo characters - remove entirely  
  disassemble.remove_last_character("ㅏ") |> should.equal("")
  disassemble.remove_last_character("ㅇ") |> should.equal("")
  disassemble.remove_last_character("ㄱ") |> should.equal("")

  // Compound jamo sequences - remove last component
  disassemble.remove_last_character("ㄱㅅ") |> should.equal("ㄱ")
  disassemble.remove_last_character("ㅗㅏ") |> should.equal("ㅗ")
}

pub fn remove_last_character_non_hangul_test() {
  // Latin characters - remove last character normally
  disassemble.remove_last_character("a") |> should.equal("")
  disassemble.remove_last_character("Hello") |> should.equal("Hell")

  // Numbers and punctuation - remove last character normally
  disassemble.remove_last_character("123") |> should.equal("12")
  disassemble.remove_last_character("!") |> should.equal("")

  // Mixed content - remove last character regardless of type
  disassemble.remove_last_character("한글a") |> should.equal("한글")
  disassemble.remove_last_character("풀잎!") |> should.equal("풀잎")
  disassemble.remove_last_character("Hello가") |> should.equal("Helloㄱ")
}
