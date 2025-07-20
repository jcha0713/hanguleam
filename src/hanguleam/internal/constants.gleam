import gleam/dict

// 가
pub const complete_hangul_start = 0xAC00

// 힣
pub const complete_hangul_end = 0xD7A3

pub const number_of_jongseong = 28

pub const number_of_jungseong = 21

pub const choseongs = [
  "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ",
  "ㅌ", "ㅍ", "ㅎ",
]

pub const jongseongs = [
  "", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ",
  "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ",
]

pub type JongseongInfo {
  JongseongInfo(components: List(String))
}

pub fn get_jongseong_info() {
  dict.from_list([
    #("", JongseongInfo([])),
    #("ㄱ", JongseongInfo(["ㄱ"])),
    #("ㄲ", JongseongInfo(["ㄲ"])),
    #("ㄳ", JongseongInfo(["ㄱ", "ㅅ"])),
    #("ㄴ", JongseongInfo(["ㄴ"])),
    #("ㄵ", JongseongInfo(["ㄴ", "ㅈ"])),
    #("ㄶ", JongseongInfo(["ㄴ", "ㅎ"])),
    #("ㄷ", JongseongInfo(["ㄷ"])),
    #("ㄹ", JongseongInfo(["ㄹ"])),
    #("ㄺ", JongseongInfo(["ㄹ", "ㄱ"])),
    #("ㄻ", JongseongInfo(["ㄹ", "ㅁ"])),
    #("ㄼ", JongseongInfo(["ㄹ", "ㅂ"])),
    #("ㄽ", JongseongInfo(["ㄹ", "ㅅ"])),
    #("ㄾ", JongseongInfo(["ㄹ", "ㅌ"])),
    #("ㄿ", JongseongInfo(["ㄹ", "ㅍ"])),
    #("ㅀ", JongseongInfo(["ㄹ", "ㅎ"])),
    #("ㅁ", JongseongInfo(["ㅁ"])),
    #("ㅂ", JongseongInfo(["ㅂ"])),
    #("ㅃ", JongseongInfo(["ㅃ"])),
    #("ㅄ", JongseongInfo(["ㅂ", "ㅅ"])),
    #("ㅅ", JongseongInfo(["ㅅ"])),
    #("ㅆ", JongseongInfo(["ㅆ"])),
    #("ㅇ", JongseongInfo(["ㅇ"])),
    #("ㅈ", JongseongInfo(["ㅈ"])),
    #("ㅉ", JongseongInfo(["ㅉ"])),
    #("ㅊ", JongseongInfo(["ㅊ"])),
    #("ㅋ", JongseongInfo(["ㅋ"])),
    #("ㅌ", JongseongInfo(["ㅌ"])),
    #("ㅍ", JongseongInfo(["ㅍ"])),
    #("ㅎ", JongseongInfo(["ㅎ"])),
  ])
}
