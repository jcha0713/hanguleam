import startest/expect
import hanguleam/core/assemble

// Basic combination tests
pub fn assemble_basic_cv_test() {
  assemble.assemble(["ㄱ", "ㅏ"])
  |> expect.to_equal("가")
}

pub fn assemble_basic_cvc_test() {
  assemble.assemble(["ㄴ", "ㅏ", "ㄴ"])
  |> expect.to_equal("난")
}

pub fn assemble_complex_vowel_test() {
  assemble.assemble(["ㄱ", "ㅗ", "ㅏ"])
  |> expect.to_equal("과")
}

pub fn assemble_two_syllables_test() {
  assemble.assemble(["ㄱ", "ㅏ", "ㄴ", "ㅏ"])
  |> expect.to_equal("가나")
}

pub fn assemble_korean_word_test() {
  assemble.assemble(["ㅎ", "ㅏ", "ㄴ", "ㄱ", "ㅡ", "ㄹ"])
  |> expect.to_equal("한글")
}

// Vowel combination tests
pub fn assemble_vowel_combination_oa_test() {
  assemble.assemble(["ㅗ", "ㅏ"])
  |> expect.to_equal("ㅘ")
}

pub fn assemble_vowel_combination_ue_test() {
  assemble.assemble(["ㅜ", "ㅓ"])
  |> expect.to_equal("ㅝ")
}

pub fn assemble_vowel_combination_ui_test() {
  assemble.assemble(["ㅡ", "ㅣ"])
  |> expect.to_equal("ㅢ")
}

pub fn assemble_invalid_vowel_combination_test() {
  assemble.assemble(["ㅏ", "ㅓ"])
  |> expect.to_equal("ㅏㅓ")
}

pub fn assemble_invalid_vowel_combination_ia_test() {
  assemble.assemble(["ㅣ", "ㅏ"])
  |> expect.to_equal("ㅣㅏ")
}

// Linking tests (연음)
pub fn assemble_linking_subok_a_test() {
  assemble.assemble(["수박", "ㅏ"])
  |> expect.to_equal("수바가")

  assemble.assemble(["깎", "ㅏ"])
  |> expect.to_equal("까까")
}

pub fn assemble_linking_gab_u_test() {
  assemble.assemble(["값", "ㅜ"])
  |> expect.to_equal("갑수")
}

// Batchim addition tests
pub fn assemble_add_single_batchim_test() {
  assemble.assemble(["가", "ㄱ"])
  |> expect.to_equal("각")
}

pub fn assemble_add_batchim_n_test() {
  assemble.assemble(["나", "ㄴ"])
  |> expect.to_equal("난")
}

pub fn assemble_complex_batchim_lb_test() {
  assemble.assemble(["가", "ㄹ", "ㅂ"])
  |> expect.to_equal("갋")
}

pub fn assemble_complex_batchim_ls_test() {
  assemble.assemble(["나", "ㄹ", "ㅅ"])
  |> expect.to_equal("낤")
}

pub fn assemble_cannot_add_vowel_as_batchim_test() {
  assemble.assemble(["가", "ㅏ"])
  |> expect.to_equal("가ㅏ")
}

// Sentence assembly tests
pub fn assemble_sentence_no_combination_test() {
  assemble.assemble(["안녕하", "ㅏ"])
  |> expect.to_equal("안녕하ㅏ")
}

pub fn assemble_sentence_assembly_test() {
  assemble.assemble(["안녕", "ㅎ", "ㅏ"])
  |> expect.to_equal("안녕하")
}

pub fn assemble_sentence_with_space_test() {
  assemble.assemble(["아버지가", " ", "방ㅇ", "ㅔ ", "들ㅇ", "ㅓ갑니다"])
  |> expect.to_equal("아버지가 방에 들어갑니다")

  assemble.assemble(["아버지가", " ", "방에", " ", "들어갑니다"])
  |> expect.to_equal("아버지가 방에 들어갑니다")

  assemble.assemble([
    "ㅇ", "ㅏ", "ㅂ", "ㅓ", "ㅈ", "ㅣ", "ㄱ", "ㅏ", " ", "ㅂ", "ㅏ", "ㅇ", "ㅇ", "ㅔ", " ",
    "ㄷ", "ㅡ", "ㄹ", "ㅇ", "ㅓ", "ㄱ", "ㅏ", "ㅂ", "ㄴ", "ㅣ", "ㄷ", "ㅏ",
  ])
  |> expect.to_equal("아버지가 방에 들어갑니다")
}

pub fn assemble_mixed_text_test() {
  assemble.assemble(["Hello", "ㄱ", "ㅏ"])
  |> expect.to_equal("Hello가")
}

pub fn assemble_numbers_and_hangul_test() {
  assemble.assemble(["123", "ㄴ", "ㅏ"])
  |> expect.to_equal("123나")
}

// Edge case tests
pub fn assemble_empty_list_test() {
  assemble.assemble([])
  |> expect.to_equal("")
}

pub fn assemble_single_empty_string_test() {
  assemble.assemble([""])
  |> expect.to_equal("")
}

pub fn assemble_multiple_empty_strings_test() {
  assemble.assemble(["", ""])
  |> expect.to_equal("")
}

pub fn assemble_single_consonant_test() {
  assemble.assemble(["ㄱ"])
  |> expect.to_equal("ㄱ")
}

pub fn assemble_single_vowel_test() {
  assemble.assemble(["ㅏ"])
  |> expect.to_equal("ㅏ")
}

pub fn assemble_single_complete_character_test() {
  assemble.assemble(["가"])
  |> expect.to_equal("가")
}

pub fn assemble_space_character_test() {
  assemble.assemble([" "])
  |> expect.to_equal(" ")
}

pub fn assemble_special_char_hangul_test() {
  assemble.assemble(["!", "ㄱ", "ㅏ"])
  |> expect.to_equal("!가")
}

pub fn assemble_vowel_consonant_no_combination_test() {
  assemble.assemble(["ㅏ", "ㄱ"])
  |> expect.to_equal("ㅏㄱ")
}

pub fn assemble_consonant_consonant_no_combination_test() {
  assemble.assemble(["ㄱ", "ㄴ"])
  |> expect.to_equal("ㄱㄴ")
}

pub fn assemble_long_sequence_test() {
  assemble.assemble(["ㄱ", "ㅏ", "ㄴ", "ㅏ", "ㄷ", "ㅏ"])
  |> expect.to_equal("가나다")
}

pub fn assemble_repeated_consonant_test() {
  assemble.assemble(["ㄱ", "ㄱ", "ㅏ"])
  |> expect.to_equal("ㄱ가")
}

pub fn assemble_repeated_vowel_test() {
  assemble.assemble(["ㅏ", "ㅏ"])
  |> expect.to_equal("ㅏㅏ")
}

pub fn assemble_complete_char_consonant_test() {
  assemble.assemble(["강", "ㅎ"])
  |> expect.to_equal("강ㅎ")
}

pub fn assemble_complete_char_vowel_test() {
  assemble.assemble(["한", "ㅏ"])
  |> expect.to_equal("하나")
}