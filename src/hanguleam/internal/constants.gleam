// 가
pub const complete_hangul_start = 0xAC00

// 힣
pub const complete_hangul_end = 0xD7A3

// ㄱ (Hangul compatibility jamo start)
pub const hangul_jamo_start = 0x3131

// ㅣ (Hangul compatibility jamo end)
pub const hangul_jamo_end = 0x3163

// ㅏ (Jungseong compatibility jamo start)
pub const jungseong_start = 0x314F

// ㅣ (Jungseong compatibility jamo end)
pub const jungseong_end = 0x3163

pub const number_of_jongseong = 28

pub const number_of_jungseong = 21

pub const choseongs = [
  "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ",
  "ㅌ", "ㅍ", "ㅎ",
]

pub const jungseongs = [
  "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ",
  "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ",
]

pub const jongseongs = [
  "", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ",
  "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ",
]

pub fn disassemble_vowel_string(vowel: String) -> String {
  case vowel {
    "ㅏ" -> "ㅏ"
    "ㅐ" -> "ㅐ"
    "ㅑ" -> "ㅑ"
    "ㅒ" -> "ㅒ"
    "ㅓ" -> "ㅓ"
    "ㅔ" -> "ㅔ"
    "ㅕ" -> "ㅕ"
    "ㅖ" -> "ㅖ"
    "ㅗ" -> "ㅗ"
    "ㅘ" -> "ㅗㅏ"
    "ㅙ" -> "ㅗㅐ"
    "ㅚ" -> "ㅗㅣ"
    "ㅛ" -> "ㅛ"
    "ㅜ" -> "ㅜ"
    "ㅝ" -> "ㅜㅓ"
    "ㅞ" -> "ㅜㅔ"
    "ㅟ" -> "ㅜㅣ"
    "ㅠ" -> "ㅠ"
    "ㅡ" -> "ㅡ"
    "ㅢ" -> "ㅡㅣ"
    "ㅣ" -> "ㅣ"
    _ -> vowel
  }
}

pub fn assemble_vowel_string(vowel: String) -> String {
  case vowel {
    "ㅏ" -> "ㅏ"
    "ㅐ" -> "ㅐ"
    "ㅑ" -> "ㅑ"
    "ㅒ" -> "ㅒ"
    "ㅓ" -> "ㅓ"
    "ㅔ" -> "ㅔ"
    "ㅕ" -> "ㅕ"
    "ㅖ" -> "ㅖ"
    "ㅗ" -> "ㅗ"
    "ㅗㅏ" -> "ㅘ"
    "ㅗㅐ" -> "ㅙ"
    "ㅗㅣ" -> "ㅚ"
    "ㅛ" -> "ㅛ"
    "ㅜ" -> "ㅜ"
    "ㅜㅓ" -> "ㅝ"
    "ㅜㅔ" -> "ㅞ"
    "ㅜㅣ" -> "ㅟ"
    "ㅠ" -> "ㅠ"
    "ㅡ" -> "ㅡ"
    "ㅡㅣ" -> "ㅢ"
    "ㅣ" -> "ㅣ"
    _ -> vowel
  }
}

pub fn disassemble_consonant_string(consonant: String) -> String {
  case consonant {
    "" -> ""
    "ㄱ" -> "ㄱ"
    "ㄲ" -> "ㄲ"
    "ㄳ" -> "ㄱㅅ"
    "ㄴ" -> "ㄴ"
    "ㄵ" -> "ㄴㅈ"
    "ㄶ" -> "ㄴㅎ"
    "ㄷ" -> "ㄷ"
    "ㄸ" -> "ㄸ"
    "ㄹ" -> "ㄹ"
    "ㄺ" -> "ㄹㄱ"
    "ㄻ" -> "ㄹㅁ"
    "ㄼ" -> "ㄹㅂ"
    "ㄽ" -> "ㄹㅅ"
    "ㄾ" -> "ㄹㅌ"
    "ㄿ" -> "ㄹㅍ"
    "ㅀ" -> "ㄹㅎ"
    "ㅁ" -> "ㅁ"
    "ㅂ" -> "ㅂ"
    "ㅃ" -> "ㅃ"
    "ㅄ" -> "ㅂㅅ"
    "ㅅ" -> "ㅅ"
    "ㅆ" -> "ㅆ"
    "ㅇ" -> "ㅇ"
    "ㅈ" -> "ㅈ"
    "ㅉ" -> "ㅉ"
    "ㅊ" -> "ㅊ"
    "ㅋ" -> "ㅋ"
    "ㅌ" -> "ㅌ"
    "ㅍ" -> "ㅍ"
    "ㅎ" -> "ㅎ"
    _ -> consonant
  }
}

pub fn assemble_consonant_string(consonant: String) -> String {
  case consonant {
    "" -> ""
    "ㄱ" -> "ㄱ"
    "ㄲ" -> "ㄲ"
    "ㄱㅅ" -> "ㄳ"
    "ㄴ" -> "ㄴ"
    "ㄴㅈ" -> "ㄵ"
    "ㄴㅎ" -> "ㄶ"
    "ㄷ" -> "ㄷ"
    "ㄸ" -> "ㄸ"
    "ㄹ" -> "ㄹ"
    "ㄹㄱ" -> "ㄺ"
    "ㄹㅁ" -> "ㄻ"
    "ㄹㅂ" -> "ㄼ"
    "ㄹㅅ" -> "ㄽ"
    "ㄹㅌ" -> "ㄾ"
    "ㄹㅍ" -> "ㄿ"
    "ㄹㅎ" -> "ㅀ"
    "ㅁ" -> "ㅁ"
    "ㅂ" -> "ㅂ"
    "ㅃ" -> "ㅃ"
    "ㅂㅅ" -> "ㅄ"
    "ㅅ" -> "ㅅ"
    "ㅆ" -> "ㅆ"
    "ㅇ" -> "ㅇ"
    "ㅈ" -> "ㅈ"
    "ㅉ" -> "ㅉ"
    "ㅊ" -> "ㅊ"
    "ㅋ" -> "ㅋ"
    "ㅌ" -> "ㅌ"
    "ㅍ" -> "ㅍ"
    "ㅎ" -> "ㅎ"
    _ -> consonant
  }
}
