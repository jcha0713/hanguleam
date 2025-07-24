import gleam/dict

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

pub type JamoData {
  JamoData(components: List(String))
}

pub fn get_jungseong_data() -> dict.Dict(String, JamoData) {
  dict.from_list([
    // Simple vowels (single component)
    #("ㅏ", JamoData(["ㅏ"])),
    #("ㅐ", JamoData(["ㅐ"])),
    #("ㅑ", JamoData(["ㅑ"])),
    #("ㅒ", JamoData(["ㅒ"])),
    #("ㅓ", JamoData(["ㅓ"])),
    #("ㅔ", JamoData(["ㅔ"])),
    #("ㅕ", JamoData(["ㅕ"])),
    #("ㅖ", JamoData(["ㅖ"])),
    #("ㅗ", JamoData(["ㅗ"])),
    #("ㅛ", JamoData(["ㅛ"])),
    #("ㅜ", JamoData(["ㅜ"])),
    #("ㅠ", JamoData(["ㅠ"])),
    #("ㅡ", JamoData(["ㅡ"])),
    #("ㅣ", JamoData(["ㅣ"])),
    // Compound vowels (multiple components)
    #("ㅘ", JamoData(["ㅗ", "ㅏ"])),
    #("ㅙ", JamoData(["ㅗ", "ㅐ"])),
    #("ㅚ", JamoData(["ㅗ", "ㅣ"])),
    #("ㅝ", JamoData(["ㅜ", "ㅓ"])),
    #("ㅞ", JamoData(["ㅜ", "ㅔ"])),
    #("ㅟ", JamoData(["ㅜ", "ㅣ"])),
    #("ㅢ", JamoData(["ㅡ", "ㅣ"])),
  ])
}

pub fn get_jongseong_data() -> dict.Dict(String, JamoData) {
  dict.from_list([
    #("", JamoData([])),
    #("ㄱ", JamoData(["ㄱ"])),
    #("ㄲ", JamoData(["ㄲ"])),
    #("ㄳ", JamoData(["ㄱ", "ㅅ"])),
    #("ㄴ", JamoData(["ㄴ"])),
    #("ㄵ", JamoData(["ㄴ", "ㅈ"])),
    #("ㄶ", JamoData(["ㄴ", "ㅎ"])),
    #("ㄷ", JamoData(["ㄷ"])),
    #("ㄹ", JamoData(["ㄹ"])),
    #("ㄺ", JamoData(["ㄹ", "ㄱ"])),
    #("ㄻ", JamoData(["ㄹ", "ㅁ"])),
    #("ㄼ", JamoData(["ㄹ", "ㅂ"])),
    #("ㄽ", JamoData(["ㄹ", "ㅅ"])),
    #("ㄾ", JamoData(["ㄹ", "ㅌ"])),
    #("ㄿ", JamoData(["ㄹ", "ㅍ"])),
    #("ㅀ", JamoData(["ㄹ", "ㅎ"])),
    #("ㅁ", JamoData(["ㅁ"])),
    #("ㅂ", JamoData(["ㅂ"])),
    #("ㅃ", JamoData(["ㅃ"])),
    #("ㅄ", JamoData(["ㅂ", "ㅅ"])),
    #("ㅅ", JamoData(["ㅅ"])),
    #("ㅆ", JamoData(["ㅆ"])),
    #("ㅇ", JamoData(["ㅇ"])),
    #("ㅈ", JamoData(["ㅈ"])),
    #("ㅉ", JamoData(["ㅉ"])),
    #("ㅊ", JamoData(["ㅊ"])),
    #("ㅋ", JamoData(["ㅋ"])),
    #("ㅌ", JamoData(["ㅌ"])),
    #("ㅍ", JamoData(["ㅍ"])),
    #("ㅎ", JamoData(["ㅎ"])),
  ])
}
