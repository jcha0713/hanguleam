import startest/expect

import hanguleam/core/disassemble

pub fn remove_last_character_korean_syllables_test() {
  // Simple CV syllable (초성 + 중성)
  disassemble.remove_last_character("아") |> expect.to_equal("ㅇ")

  // Compound vowel cases (복합 모음)  
  disassemble.remove_last_character("점괘") |> expect.to_equal("점고")
  disassemble.remove_last_character("전화") |> expect.to_equal("전호")
  disassemble.remove_last_character("과") |> expect.to_equal("고")

  // Simple CVC syllable (초성 + 중성 + 종성)
  disassemble.remove_last_character("수박") |> expect.to_equal("수바")

  // Compound CVC
  disassemble.remove_last_character("괌") |> expect.to_equal("과")

  // Complex batchim cases (복합 받침)
  disassemble.remove_last_character("값") |> expect.to_equal("갑")
  disassemble.remove_last_character("여덟") |> expect.to_equal("여덜")

  // Compound complex batchim cases
  disassemble.remove_last_character("홟") |> expect.to_equal("활")
}

pub fn remove_last_character_edge_cases_test() {
  // Empty input
  disassemble.remove_last_character("") |> expect.to_equal("")

  // Single jamo characters - remove entirely  
  disassemble.remove_last_character("ㅏ") |> expect.to_equal("")
  disassemble.remove_last_character("ㅇ") |> expect.to_equal("")
  disassemble.remove_last_character("ㄱ") |> expect.to_equal("")

  // Compound jamo sequences - remove last component
  disassemble.remove_last_character("ㄱㅅ") |> expect.to_equal("ㄱ")
  disassemble.remove_last_character("ㅗㅏ") |> expect.to_equal("ㅗ")
}

pub fn remove_last_character_non_hangul_test() {
  // Latin characters - remove last character normally
  disassemble.remove_last_character("a") |> expect.to_equal("")
  disassemble.remove_last_character("Hello") |> expect.to_equal("Hell")

  // Numbers and punctuation - remove last character normally
  disassemble.remove_last_character("123") |> expect.to_equal("12")
  disassemble.remove_last_character("!") |> expect.to_equal("")

  // Mixed content - remove last character regardless of type
  disassemble.remove_last_character("한글a") |> expect.to_equal("한글")
  disassemble.remove_last_character("풀잎!") |> expect.to_equal("풀잎")
  disassemble.remove_last_character("Hello가") |> expect.to_equal("Helloㄱ")
}
