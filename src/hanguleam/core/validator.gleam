import gleam/list
import gleam/string

import hanguleam/internal/constants.{
  assemble_consonant_string, assemble_vowel_string, choseongs, jongseongs,
  jungseongs,
}

pub fn can_be_choseong(char: String) -> Bool {
  choseongs |> list.contains(char)
}

pub fn can_be_jungseong(char: String) -> Bool {
  case string.length(char) {
    1 -> list.contains(jungseongs, char)
    2 -> assemble_vowel_string(char) |> list.contains(jungseongs, _)
    _ -> False
  }
}

pub fn can_be_jongseong(char: String) -> Bool {
  case string.length(char) {
    0 -> True
    1 -> list.contains(jongseongs, char)
    2 -> assemble_consonant_string(char) |> list.contains(jongseongs, _)
    _ -> False
  }
}
