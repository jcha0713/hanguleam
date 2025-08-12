import gleam/result
import gleam/string
import hanguleam/composer
import hanguleam/internal/character
import hanguleam/internal/types.{
  type HangulCharacter, Choseong, ComplexBatchim, CompoundCV, CompoundCVC,
  CompoundComplexBatchim, Jongseong, Jungseong, SimpleCV, SimpleCVC,
}

/// Removes the last character component from a Korean string, intelligently handling Korean syllable decomposition.
/// This function removes the last "logical" character unit from the input string. For complete Korean syllables,
/// it removes the last jamo component (consonant or vowel part) rather than the entire character, allowing for
/// fine-grained text editing that matches Korean input method behavior.
///
/// ## Examples
///
/// ```gleam
/// remove_last_character("안녕하세요 값")
/// // -> "안녕하세요 갑"
///
/// remove_last_character("전화")
/// // -> "전호"
///
/// remove_last_character("Hello")
/// // -> "Hell"
///
/// remove_last_character("")
/// // -> ""
/// ```
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