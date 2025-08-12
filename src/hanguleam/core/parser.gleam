import gleam/list
import gleam/string
import hanguleam/internal/character
import hanguleam/internal/types.{
  type HangulSyllable, Choseong, Consonant, HangulSyllable, Jongseong,
  Jungseong, Vowel,
}

pub type DisassembleError {
  IncompleteHangul
  NonHangulCharacter
  EmptyString
}

pub fn disassemble(text: String) -> String {
  do_disassemble(text, "")
}

fn do_disassemble(text: String, accumulator: String) -> String {
  case string.pop_grapheme(text) {
    Ok(#(head, tail)) -> {
      let components = disassemble_char_to_groups(head) |> string.join("")
      do_disassemble(tail, accumulator <> components)
    }
    Error(_) -> accumulator
  }
}

pub fn disassemble_to_groups(text: String) -> List(List(String)) {
  do_disassemble_to_groups(text, []) |> list.reverse
}

fn do_disassemble_to_groups(
  text: String,
  accumulator: List(List(String)),
) -> List(List(String)) {
  case string.pop_grapheme(text) {
    Ok(#(head, tail)) -> {
      let group = disassemble_char_to_groups(head)
      do_disassemble_to_groups(tail, [group, ..accumulator])
    }
    Error(_) -> accumulator
  }
}

fn disassemble_char_to_groups(char: String) -> List(String) {
  case disassemble_complete_character(char) {
    Ok(syllable) -> syllable_to_components(syllable)
    Error(IncompleteHangul) -> disassemble_jamo(char)
    Error(NonHangulCharacter) -> [char]
    Error(EmptyString) -> [char]
  }
}

fn syllable_to_components(syllable: HangulSyllable) -> List(String) {
  let HangulSyllable(Choseong(cho), Jungseong(jung), Jongseong(jong)) = syllable
  [cho]
  |> list.append(string.to_graphemes(jung))
  |> fn(base) {
    case jong {
      "" -> base
      _ -> list.append(base, string.to_graphemes(jong))
    }
  }
}

fn disassemble_jamo(char: String) -> List(String) {
  case character.parse_hangul_jamo(char) {
    Ok(Consonant(components)) | Ok(Vowel(components)) ->
      string.split(components, "")
    Error(_) -> []
  }
}

pub fn disassemble_complete_character(
  char: String,
) -> Result(HangulSyllable, DisassembleError) {
  case character.get_character_type(char) {
    types.Empty -> Error(EmptyString)
    types.NonHangul -> Error(NonHangulCharacter)
    types.IncompleteHangul(_) -> Error(IncompleteHangul)
    types.CompleteHangul(char) -> Ok(char)
  }
}

