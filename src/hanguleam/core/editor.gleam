import gleam/result
import gleam/string
import hanguleam/core/composer
import hanguleam/internal/character
import hanguleam/internal/types.{
  type HangulCharacter, Choseong, ComplexBatchim, CompoundCV, CompoundCVC,
  CompoundComplexBatchim, Jongseong, Jungseong, SimpleCV, SimpleCVC,
}

pub fn remove_last_character(text: String) -> String {
  case string.last(text) {
    Error(_) -> text
    Ok(last_char) -> remove_character_component(text, last_char)
  }
}

fn remove_character_component(text: String, last_char: String) -> String {
  let prefix = string.drop_end(text, 1)

  last_char
  |> disassemble_complete_character
  |> result.map(character.parse_hangul_syllable)
  |> result.map(reduce_syllable)
  |> result.unwrap("")
  |> string.append(prefix, _)
}

fn disassemble_complete_character(char: String) {
  case character.get_character_type(char) {
    types.Empty -> Error(Nil)
    types.NonHangul -> Error(Nil)
    types.IncompleteHangul(_) -> Error(Nil)
    types.CompleteHangul(char) -> Ok(char)
  }
}

fn reduce_syllable(disassembled: HangulCharacter) -> String {
  case disassembled {
    SimpleCV(Choseong(cho), _) -> cho
    CompoundCV(Choseong(cho), Jungseong(jung)) -> {
      composer.combine_character_unsafe(cho, string.slice(jung, 0, 1), "")
    }
    SimpleCVC(Choseong(cho), Jungseong(jung), Jongseong(_)) -> {
      composer.combine_character_unsafe(cho, jung, "")
    }
    CompoundCVC(Choseong(cho), Jungseong(jung), Jongseong(_)) -> {
      composer.combine_character_unsafe(cho, jung, "")
    }
    ComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong)) -> {
      composer.combine_character_unsafe(cho, jung, string.slice(jong, 0, 1))
    }
    CompoundComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong)) -> {
      composer.combine_character_unsafe(cho, jung, string.slice(jong, 0, 1))
    }
  }
}