import gleam/dict

// 가
pub const complete_hangul_start = 0xAC00

// 힣
pub const complete_hangul_end = 0xD7A3

// ㄱ (Hangul compatibility jamo start)
pub const hangul_jamo_start = 0x3131

// ㅣ (Hangul compatibility jamo end)
pub const hangul_jamo_end = 0x3163

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

pub type JongseongData {
  JongseongData(components: List(String))
}

pub fn get_jongseong_data() {
  dict.from_list([
    #("", JongseongData([])),
    #("ㄱ", JongseongData(["ㄱ"])),
    #("ㄲ", JongseongData(["ㄲ"])),
    #("ㄳ", JongseongData(["ㄱ", "ㅅ"])),
    #("ㄴ", JongseongData(["ㄴ"])),
    #("ㄵ", JongseongData(["ㄴ", "ㅈ"])),
    #("ㄶ", JongseongData(["ㄴ", "ㅎ"])),
    #("ㄷ", JongseongData(["ㄷ"])),
    #("ㄹ", JongseongData(["ㄹ"])),
    #("ㄺ", JongseongData(["ㄹ", "ㄱ"])),
    #("ㄻ", JongseongData(["ㄹ", "ㅁ"])),
    #("ㄼ", JongseongData(["ㄹ", "ㅂ"])),
    #("ㄽ", JongseongData(["ㄹ", "ㅅ"])),
    #("ㄾ", JongseongData(["ㄹ", "ㅌ"])),
    #("ㄿ", JongseongData(["ㄹ", "ㅍ"])),
    #("ㅀ", JongseongData(["ㄹ", "ㅎ"])),
    #("ㅁ", JongseongData(["ㅁ"])),
    #("ㅂ", JongseongData(["ㅂ"])),
    #("ㅃ", JongseongData(["ㅃ"])),
    #("ㅄ", JongseongData(["ㅂ", "ㅅ"])),
    #("ㅅ", JongseongData(["ㅅ"])),
    #("ㅆ", JongseongData(["ㅆ"])),
    #("ㅇ", JongseongData(["ㅇ"])),
    #("ㅈ", JongseongData(["ㅈ"])),
    #("ㅉ", JongseongData(["ㅉ"])),
    #("ㅊ", JongseongData(["ㅊ"])),
    #("ㅋ", JongseongData(["ㅋ"])),
    #("ㅌ", JongseongData(["ㅌ"])),
    #("ㅍ", JongseongData(["ㅍ"])),
    #("ㅎ", JongseongData(["ㅎ"])),
  ])
}
