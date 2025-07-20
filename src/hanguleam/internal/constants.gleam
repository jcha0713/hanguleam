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

pub type BatchimData {
  BatchimData(components: List(String))
}

pub fn get_batchim_data() {
  dict.from_list([
    #("", BatchimData([])),
    #("ㄱ", BatchimData(["ㄱ"])),
    #("ㄲ", BatchimData(["ㄲ"])),
    #("ㄳ", BatchimData(["ㄱ", "ㅅ"])),
    #("ㄴ", BatchimData(["ㄴ"])),
    #("ㄵ", BatchimData(["ㄴ", "ㅈ"])),
    #("ㄶ", BatchimData(["ㄴ", "ㅎ"])),
    #("ㄷ", BatchimData(["ㄷ"])),
    #("ㄹ", BatchimData(["ㄹ"])),
    #("ㄺ", BatchimData(["ㄹ", "ㄱ"])),
    #("ㄻ", BatchimData(["ㄹ", "ㅁ"])),
    #("ㄼ", BatchimData(["ㄹ", "ㅂ"])),
    #("ㄽ", BatchimData(["ㄹ", "ㅅ"])),
    #("ㄾ", BatchimData(["ㄹ", "ㅌ"])),
    #("ㄿ", BatchimData(["ㄹ", "ㅍ"])),
    #("ㅀ", BatchimData(["ㄹ", "ㅎ"])),
    #("ㅁ", BatchimData(["ㅁ"])),
    #("ㅂ", BatchimData(["ㅂ"])),
    #("ㅃ", BatchimData(["ㅃ"])),
    #("ㅄ", BatchimData(["ㅂ", "ㅅ"])),
    #("ㅅ", BatchimData(["ㅅ"])),
    #("ㅆ", BatchimData(["ㅆ"])),
    #("ㅇ", BatchimData(["ㅇ"])),
    #("ㅈ", BatchimData(["ㅈ"])),
    #("ㅉ", BatchimData(["ㅉ"])),
    #("ㅊ", BatchimData(["ㅊ"])),
    #("ㅋ", BatchimData(["ㅋ"])),
    #("ㅌ", BatchimData(["ㅌ"])),
    #("ㅍ", BatchimData(["ㅍ"])),
    #("ㅎ", BatchimData(["ㅎ"])),
  ])
}
