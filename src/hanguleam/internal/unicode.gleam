import gleam/list
import gleam/string

// 가
pub const complete_hangul_start = 0xAC00

// 힣
pub const complete_hangul_end = 0xD7A3

// Modern Hangul Jamo (U+1100-U+11FF) - combining forms used in composition
pub const modern_jamo_start = 0x1100

// ᄀ
pub const modern_jamo_end = 0x11FF

// Modern jamo sub-ranges
pub const modern_choseong_start = 0x1100

// ᄀ (leading consonants)
pub const modern_choseong_end = 0x1112

// ᄒ
pub const modern_jungseong_start = 0x1161

// ᅡ (vowels)
pub const modern_jungseong_end = 0x1175

// ᅵ
pub const modern_jongseong_start = 0x11A8

// ᆨ (trailing consonants) 
pub const modern_jongseong_end = 0x11C2

// Hangul Compatibility Jamo (U+3131-U+3163) - standalone display forms
// ㄱ
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
    // Modern Choseong (U+1100-U+1112) -> Compatibility Jamo
    "ᄀ" -> "ㄱ"
    // U+1100 -> U+3131
    "ᄁ" -> "ㄲ"
    // U+1101 -> U+3132
    "ᄂ" -> "ㄴ"
    // U+1102 -> U+3134
    "ᄃ" -> "ㄷ"
    // U+1103 -> U+3137
    "ᄄ" -> "ㄸ"
    // U+1104 -> U+3138
    "ᄅ" -> "ㄹ"
    // U+1105 -> U+3139
    "ᄆ" -> "ㅁ"
    // U+1106 -> U+3141
    "ᄇ" -> "ㅂ"
    // U+1107 -> U+3142
    "ᄈ" -> "ㅃ"
    // U+1108 -> U+3143
    "ᄉ" -> "ㅅ"
    // U+1109 -> U+3145
    "ᄊ" -> "ㅆ"
    // U+110A -> U+3146
    "ᄋ" -> "ㅇ"
    // U+110B -> U+3147
    "ᄌ" -> "ㅈ"
    // U+110C -> U+3148
    "ᄍ" -> "ㅉ"
    // U+110D -> U+3149
    "ᄎ" -> "ㅊ"
    // U+110E -> U+314A
    "ᄏ" -> "ㅋ"
    // U+110F -> U+314B
    "ᄐ" -> "ㅌ"
    // U+1110 -> U+314C
    "ᄑ" -> "ㅍ"
    // U+1111 -> U+314D
    "ᄒ" -> "ㅎ"

    // U+1112 -> U+314E
    // Modern Jungseong (U+1161-U+1175) -> Compatibility Jamo
    "ᅡ" -> "ㅏ"
    // U+1161 -> U+314F
    "ᅢ" -> "ㅐ"
    // U+1162 -> U+3150
    "ᅣ" -> "ㅑ"
    // U+1163 -> U+3151
    "ᅤ" -> "ㅒ"
    // U+1164 -> U+3152
    "ᅥ" -> "ㅓ"
    // U+1165 -> U+3153
    "ᅦ" -> "ㅔ"
    // U+1166 -> U+3154
    "ᅧ" -> "ㅕ"
    // U+1167 -> U+3155
    "ᅨ" -> "ㅖ"
    // U+1168 -> U+3156
    "ᅩ" -> "ㅗ"
    // U+1169 -> U+3157
    "ᅪ" -> "ㅘ"
    // U+116A -> U+3158
    "ᅫ" -> "ㅙ"
    // U+116B -> U+3159
    "ᅬ" -> "ㅚ"
    // U+116C -> U+315A
    "ᅭ" -> "ㅛ"
    // U+116D -> U+315B
    "ᅮ" -> "ㅜ"
    // U+116E -> U+315C
    "ᅯ" -> "ㅝ"
    // U+116F -> U+315D
    "ᅰ" -> "ㅞ"
    // U+1170 -> U+315E
    "ᅱ" -> "ㅟ"
    // U+1171 -> U+315F
    "ᅲ" -> "ㅠ"
    // U+1172 -> U+3160
    "ᅳ" -> "ㅡ"
    // U+1173 -> U+3161
    "ᅴ" -> "ㅢ"
    // U+1174 -> U+3162
    "ᅵ" -> "ㅣ"

    // U+1175 -> U+3163
    // Modern Jongseong (U+11A8-U+11C2) -> Compatibility Jamo
    "ᆨ" -> "ㄱ"
    // U+11A8 -> U+3131
    "ᆩ" -> "ㄲ"
    // U+11A9 -> U+3132
    "ᆪ" -> "ㄳ"
    // U+11AA -> U+3133 (compound)
    "ᆫ" -> "ㄴ"
    // U+11AB -> U+3134
    "ᆬ" -> "ㄵ"
    // U+11AC -> U+3135 (compound)
    "ᆭ" -> "ㄶ"
    // U+11AD -> U+3136 (compound)
    "ᆮ" -> "ㄷ"
    // U+11AE -> U+3137
    "ᆯ" -> "ㄹ"
    // U+11AF -> U+3139
    "ᆰ" -> "ㄺ"
    // U+11B0 -> U+313A (compound)
    "ᆱ" -> "ㄻ"
    // U+11B1 -> U+313B (compound)
    "ᆲ" -> "ㄼ"
    // U+11B2 -> U+313C (compound)
    "ᆳ" -> "ㄽ"
    // U+11B3 -> U+313D (compound)
    "ᆴ" -> "ㄾ"
    // U+11B4 -> U+313E (compound)
    "ᆵ" -> "ㄿ"
    // U+11B5 -> U+313F (compound)
    "ᆶ" -> "ㅀ"
    // U+11B6 -> U+3140 (compound)
    "ᆷ" -> "ㅁ"
    // U+11B7 -> U+3141
    "ᆸ" -> "ㅂ"
    // U+11B8 -> U+3142
    "ᆹ" -> "ㅄ"
    // U+11B9 -> U+3144 (compound)
    "ᆺ" -> "ㅅ"
    // U+11BA -> U+3145
    "ᆻ" -> "ㅆ"
    // U+11BB -> U+3146
    "ᆼ" -> "ㅇ"
    // U+11BC -> U+3147
    "ᆽ" -> "ㅈ"
    // U+11BD -> U+3148
    "ᆾ" -> "ㅊ"
    // U+11BE -> U+314A
    "ᆿ" -> "ㅋ"
    // U+11BF -> U+314B
    "ᇀ" -> "ㅌ"
    // U+11C0 -> U+314C
    "ᇁ" -> "ㅍ"
    // U+11C1 -> U+314D
    "ᇂ" -> "ㅎ"

    // U+11C2 -> U+314E
    // Already compatibility jamo or non-jamo - return as-is
    _ -> jamo
  }
}
