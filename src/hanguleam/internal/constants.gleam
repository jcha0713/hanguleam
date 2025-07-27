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

pub fn disassemble_vowel_string(char: String) -> Result(String, Nil) {
  case char {
    "ㅏ" -> Ok("ㅏ")
    "ㅐ" -> Ok("ㅐ")
    "ㅑ" -> Ok("ㅑ")
    "ㅒ" -> Ok("ㅒ")
    "ㅓ" -> Ok("ㅓ")
    "ㅔ" -> Ok("ㅔ")
    "ㅕ" -> Ok("ㅕ")
    "ㅖ" -> Ok("ㅖ")
    "ㅗ" -> Ok("ㅗ")
    "ㅘ" -> Ok("ㅗㅏ")
    "ㅙ" -> Ok("ㅗㅐ")
    "ㅚ" -> Ok("ㅗㅣ")
    "ㅛ" -> Ok("ㅛ")
    "ㅜ" -> Ok("ㅜ")
    "ㅝ" -> Ok("ㅜㅓ")
    "ㅞ" -> Ok("ㅜㅔ")
    "ㅟ" -> Ok("ㅜㅣ")
    "ㅠ" -> Ok("ㅠ")
    "ㅡ" -> Ok("ㅡ")
    "ㅢ" -> Ok("ㅡㅣ")
    "ㅣ" -> Ok("ㅣ")
    _ -> Error(Nil)
  }
}

pub fn assemble_vowel_string(components: String) -> Result(String, Nil) {
  case components {
    "ㅏ" -> Ok("ㅏ")
    "ㅐ" -> Ok("ㅐ")
    "ㅑ" -> Ok("ㅑ")
    "ㅒ" -> Ok("ㅒ")
    "ㅓ" -> Ok("ㅓ")
    "ㅔ" -> Ok("ㅔ")
    "ㅕ" -> Ok("ㅕ")
    "ㅖ" -> Ok("ㅖ")
    "ㅗ" -> Ok("ㅗ")
    "ㅗㅏ" -> Ok("ㅘ")
    "ㅗㅐ" -> Ok("ㅙ")
    "ㅗㅣ" -> Ok("ㅚ")
    "ㅛ" -> Ok("ㅛ")
    "ㅜ" -> Ok("ㅜ")
    "ㅜㅓ" -> Ok("ㅝ")
    "ㅜㅔ" -> Ok("ㅞ")
    "ㅜㅣ" -> Ok("ㅟ")
    "ㅠ" -> Ok("ㅠ")
    "ㅡ" -> Ok("ㅡ")
    "ㅡㅣ" -> Ok("ㅢ")
    "ㅣ" -> Ok("ㅣ")
    _ -> Error(Nil)
  }
}

pub fn disassemble_consonant_string(char: String) -> Result(String, Nil) {
  case char {
    "" -> Ok("")
    "ㄱ" -> Ok("ㄱ")
    "ㄲ" -> Ok("ㄲ")
    "ㄳ" -> Ok("ㄱㅅ")
    "ㄴ" -> Ok("ㄴ")
    "ㄵ" -> Ok("ㄴㅈ")
    "ㄶ" -> Ok("ㄴㅎ")
    "ㄷ" -> Ok("ㄷ")
    "ㄸ" -> Ok("ㄸ")
    "ㄹ" -> Ok("ㄹ")
    "ㄺ" -> Ok("ㄹㄱ")
    "ㄻ" -> Ok("ㄹㅁ")
    "ㄼ" -> Ok("ㄹㅂ")
    "ㄽ" -> Ok("ㄹㅅ")
    "ㄾ" -> Ok("ㄹㅌ")
    "ㄿ" -> Ok("ㄹㅍ")
    "ㅀ" -> Ok("ㄹㅎ")
    "ㅁ" -> Ok("ㅁ")
    "ㅂ" -> Ok("ㅂ")
    "ㅃ" -> Ok("ㅃ")
    "ㅄ" -> Ok("ㅂㅅ")
    "ㅅ" -> Ok("ㅅ")
    "ㅆ" -> Ok("ㅆ")
    "ㅇ" -> Ok("ㅇ")
    "ㅈ" -> Ok("ㅈ")
    "ㅉ" -> Ok("ㅉ")
    "ㅊ" -> Ok("ㅊ")
    "ㅋ" -> Ok("ㅋ")
    "ㅌ" -> Ok("ㅌ")
    "ㅍ" -> Ok("ㅍ")
    "ㅎ" -> Ok("ㅎ")
    _ -> Error(Nil)
  }
}

pub fn assemble_consonant_string(components: String) -> Result(String, Nil) {
  case components {
    "" -> Ok("")
    "ㄱ" -> Ok("ㄱ")
    "ㄲ" -> Ok("ㄲ")
    "ㄱㅅ" -> Ok("ㄳ")
    "ㄴ" -> Ok("ㄴ")
    "ㄴㅈ" -> Ok("ㄵ")
    "ㄴㅎ" -> Ok("ㄶ")
    "ㄷ" -> Ok("ㄷ")
    "ㄸ" -> Ok("ㄸ")
    "ㄹ" -> Ok("ㄹ")
    "ㄹㄱ" -> Ok("ㄺ")
    "ㄹㅁ" -> Ok("ㄻ")
    "ㄹㅂ" -> Ok("ㄼ")
    "ㄹㅅ" -> Ok("ㄽ")
    "ㄹㅌ" -> Ok("ㄾ")
    "ㄹㅍ" -> Ok("ㄿ")
    "ㄹㅎ" -> Ok("ㅀ")
    "ㅁ" -> Ok("ㅁ")
    "ㅂ" -> Ok("ㅂ")
    "ㅃ" -> Ok("ㅃ")
    "ㅂㅅ" -> Ok("ㅄ")
    "ㅅ" -> Ok("ㅅ")
    "ㅆ" -> Ok("ㅆ")
    "ㅇ" -> Ok("ㅇ")
    "ㅈ" -> Ok("ㅈ")
    "ㅉ" -> Ok("ㅉ")
    "ㅊ" -> Ok("ㅊ")
    "ㅋ" -> Ok("ㅋ")
    "ㅌ" -> Ok("ㅌ")
    "ㅍ" -> Ok("ㅍ")
    "ㅎ" -> Ok("ㅎ")
    _ -> Error(Nil)
  }
}
