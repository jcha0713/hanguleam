///
/// # Unicode Module - Korean Hangul Character Processing
///
/// This module provides foundational Unicode support for Korean Hangul characters,
/// including constants, classification functions, and character manipulation utilities.
///
/// ## Unicode Ranges Covered
///
/// ### Complete Hangul Syllables (U+AC00-U+D7A3)
/// - Range: 가 (U+AC00) to 힣 (U+D7A3)
/// - Pre-composed syllables that combine choseong + jungseong + optional jongseong
/// - Total: 11,172 possible syllables
///
/// ### Modern Hangul Jamo (U+1100-U+11FF) 
/// - Combining forms used in Unicode composition and modern text processing
/// - Choseong (Initial): U+1100-U+1112 (ᄀ to ᄒ) - 19 characters
/// - Jungseong (Medial): U+1161-U+1175 (ᅡ to ᅵ) - 21 characters  
/// - Jongseong (Final): U+11A8-U+11C2 (ᆨ to ᇂ) - 27 characters
/// - Used by IMEs and modern text processing systems
///
/// ### Compatibility Hangul Jamo (U+3131-U+3163)
/// - Standalone display forms for individual jamo characters
/// - Range: ㄱ (U+3131) to ㅣ (U+3163)
/// - Used for displaying individual consonants and vowels
/// - Jungseong subset: U+314F-U+3163 (ㅏ to ㅣ)
///
/// ## Character Composition
///
/// Korean syllables follow the pattern: Choseong + Jungseong + (optional) Jongseong
/// - Choseong: 19 initial consonants
/// - Jungseong: 21 vowels (including complex vowels like ㅘ, ㅝ)
/// - Jongseong: 28 final consonants (including "" for no final consonant)
/// - Formula: 19 × 21 × 28 = 11,172 total syllables
///
/// ## Functions Overview
///
/// - **Classification**: `is_complete_hangul()`, `is_modern_jamo()`, `is_compatibility_jamo()`
/// - **Validation**: `is_modern_choseong()`, `is_compatibility_jungseong()`, etc.
/// - **Assembly/Disassembly**: `assemble_vowel_string()`, `disassemble_consonant_string()`
/// - **Normalization**: `normalize_modern_jamo()` (modern → compatibility conversion)
/// - **Utilities**: `get_codepoint_result_from_char()` for codepoint extraction
///
import gleam/list
import gleam/string

pub const complete_hangul_start = 0xAC00

pub const complete_hangul_end = 0xD7A3

pub const modern_jamo_start = 0x1100

pub const modern_jamo_end = 0x11FF

pub const modern_choseong_start = 0x1100

pub const modern_choseong_end = 0x1112

pub const modern_jungseong_start = 0x1161

pub const modern_jungseong_end = 0x1175

pub const modern_jongseong_start = 0x11A8

pub const modern_jongseong_end = 0x11C2

pub const hangul_jamo_start = 0x3131

pub const hangul_jamo_end = 0x3163

pub const jungseong_start = 0x314F

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

/// Extract codepoint from a single character string
pub fn get_codepoint_result_from_char(char: String) -> Result(Int, Nil) {
  case string.to_utf_codepoints(char) |> list.first {
    Ok(codepoint) -> Ok(string.utf_codepoint_to_int(codepoint))
    Error(_) -> Error(Nil)
  }
}

/// Check if a codepoint represents a complete Hangul syllable (U+AC00-U+D7A3)
pub fn is_complete_hangul(codepoint: Int) -> Bool {
  complete_hangul_start <= codepoint && codepoint <= complete_hangul_end
}

/// Check if a codepoint represents modern Hangul jamo (U+1100-U+11FF) - combining forms
pub fn is_modern_jamo(codepoint: Int) -> Bool {
  modern_jamo_start <= codepoint && codepoint <= modern_jamo_end
}

/// Check if a codepoint represents compatibility Hangul jamo (U+3131-U+3163) - standalone forms
pub fn is_compatibility_jamo(codepoint: Int) -> Bool {
  hangul_jamo_start <= codepoint && codepoint <= hangul_jamo_end
}

/// Check if a codepoint represents any Hangul jamo (both modern and compatibility forms)
pub fn is_hangul_alphabet(codepoint: Int) -> Bool {
  is_modern_jamo(codepoint) || is_compatibility_jamo(codepoint)
}

/// Check if a codepoint represents vowels within compatibility jamo range (U+314F-U+3163)
pub fn is_jungseong_range(codepoint: Int) -> Bool {
  codepoint >= jungseong_start && codepoint <= jungseong_end
}

/// Check if a codepoint represents any Hangul character (complete syllables + any jamo)
pub fn is_hangul(codepoint: Int) -> Bool {
  is_complete_hangul(codepoint) || is_hangul_alphabet(codepoint)
}

/// Check if a single character is a modern choseong (U+1100-U+1112)
pub fn is_modern_choseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) ->
      codepoint >= modern_choseong_start && codepoint <= modern_choseong_end
    Error(_) -> False
  }
}

/// Check if a single character is a compatibility choseong
pub fn is_compatibility_choseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) ->
      codepoint >= 0x3131
      && codepoint <= 0x314E
      && list.contains(choseongs, char)
    Error(_) -> False
  }
}

/// Check if a single character is a modern jungseong (U+1161-U+1175)
pub fn is_modern_jungseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) ->
      codepoint >= modern_jungseong_start && codepoint <= modern_jungseong_end
    Error(_) -> False
  }
}

/// Check if a single character is a compatibility jungseong
pub fn is_compatibility_jungseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) -> codepoint >= jungseong_start && codepoint <= jungseong_end
    Error(_) -> False
  }
}

/// Check if a single character is a modern jongseong (U+11A8-U+11C2)
pub fn is_modern_jongseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) ->
      codepoint >= modern_jongseong_start && codepoint <= modern_jongseong_end
    Error(_) -> False
  }
}

/// Check if a single character is a compatibility jongseong
pub fn is_compatibility_jongseong(char: String) -> Bool {
  case get_codepoint_result_from_char(char) {
    Ok(codepoint) ->
      codepoint >= 0x3131
      && codepoint <= 0x314E
      && list.contains(jongseongs, char)
    Error(_) -> False
  }
}

/// Normalize modern jamo (U+1100-U+11FF) to compatibility jamo (U+3131-U+3163)
/// This enables consistent processing regardless of input source (different IMEs, copy/paste, etc.)
pub fn normalize_modern_jamo(jamo: String) -> String {
  case jamo {
    "ᄀ" -> "ㄱ"
    "ᄁ" -> "ㄲ"
    "ᄂ" -> "ㄴ"
    "ᄃ" -> "ㄷ"
    "ᄄ" -> "ㄸ"
    "ᄅ" -> "ㄹ"
    "ᄆ" -> "ㅁ"
    "ᄇ" -> "ㅂ"
    "ᄈ" -> "ㅃ"
    "ᄉ" -> "ㅅ"
    "ᄊ" -> "ㅆ"
    "ᄋ" -> "ㅇ"
    "ᄌ" -> "ㅈ"
    "ᄍ" -> "ㅉ"
    "ᄎ" -> "ㅊ"
    "ᄏ" -> "ㅋ"
    "ᄐ" -> "ㅌ"
    "ᄑ" -> "ㅍ"
    "ᄒ" -> "ㅎ"
    "ᅡ" -> "ㅏ"
    "ᅢ" -> "ㅐ"
    "ᅣ" -> "ㅑ"
    "ᅤ" -> "ㅒ"
    "ᅥ" -> "ㅓ"
    "ᅦ" -> "ㅔ"
    "ᅧ" -> "ㅕ"
    "ᅨ" -> "ㅖ"
    "ᅩ" -> "ㅗ"
    "ᅪ" -> "ㅘ"
    "ᅫ" -> "ㅙ"
    "ᅬ" -> "ㅚ"
    "ᅭ" -> "ㅛ"
    "ᅮ" -> "ㅜ"
    "ᅯ" -> "ㅝ"
    "ᅰ" -> "ㅞ"
    "ᅱ" -> "ㅟ"
    "ᅲ" -> "ㅠ"
    "ᅳ" -> "ㅡ"
    "ᅴ" -> "ㅢ"
    "ᅵ" -> "ㅣ"
    "ᆨ" -> "ㄱ"
    "ᆩ" -> "ㄲ"
    "ᆪ" -> "ㄳ"
    "ᆫ" -> "ㄴ"
    "ᆬ" -> "ㄵ"
    "ᆭ" -> "ㄶ"
    "ᆮ" -> "ㄷ"
    "ᆯ" -> "ㄹ"
    "ᆰ" -> "ㄺ"
    "ᆱ" -> "ㄻ"
    "ᆲ" -> "ㄼ"
    "ᆳ" -> "ㄽ"
    "ᆴ" -> "ㄾ"
    "ᆵ" -> "ㄿ"
    "ᆶ" -> "ㅀ"
    "ᆷ" -> "ㅁ"
    "ᆸ" -> "ㅂ"
    "ᆹ" -> "ㅄ"
    "ᆺ" -> "ㅅ"
    "ᆻ" -> "ㅆ"
    "ᆼ" -> "ㅇ"
    "ᆽ" -> "ㅈ"
    "ᆾ" -> "ㅊ"
    "ᆿ" -> "ㅋ"
    "ᇀ" -> "ㅌ"
    "ᇁ" -> "ㅍ"
    "ᇂ" -> "ㅎ"
    _ -> jamo
  }
}
