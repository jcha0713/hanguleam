import gleeunit/should
import hanguleam/core/assemble

pub fn combine_character_unsafe_valid_test() {
  assemble.combine_character_unsafe("ㄱ", "ㅏ", "")
  |> should.equal("가")

  assemble.combine_character_unsafe("ㄴ", "ㅏ", "ㄴ")
  |> should.equal("난")

  assemble.combine_character_unsafe("ㄱ", "ㅘ", "ㄼ")
  |> should.equal("괇")

  assemble.combine_character_unsafe("ㅎ", "ㅣ", "ㅎ")
  |> should.equal("힣")
}