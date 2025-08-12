import gleam/list
import gleam/string
import hanguleam/internal/character
import hanguleam/internal/types.{
  type HangulSyllable, Choseong, Consonant, HangulSyllable, Jongseong, Jungseong,
  Vowel,
}

pub type DisassembleError {
  IncompleteHangul
  NonHangulCharacter
  EmptyString
}

/// Disassembles Korean Hangul characters into their constituent jamo (consonants and vowels).
/// This function breaks down complete Hangul syllables and individual jamo into their basic components.
/// Non-Korean characters and whitespace are preserved as-is.
///
/// ## Examples
///
/// ```gleam
/// disassemble("값")
/// // -> "ㄱㅏㅂㅅ"
///
/// disassemble("값이 비싸다")
/// // -> "ㄱㅏㅂㅅㅇㅣ ㅂㅣㅆㅏㄷㅏ"
///
/// disassemble("ㅘ")
/// // -> "ㅗㅏ"
///
/// disassemble("ㄵ")
/// // -> "ㄴㅈ"
///
/// disassemble("hello 안녕")
/// // -> "hello ㅇㅏㄴㄴㅕㅇ"
/// ```
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

/// Disassembles Korean Hangul characters into groups of jamo components.
/// Unlike `disassemble`, this function returns a 2D array where each character
/// is represented as a separate array of its constituent jamo.
///
/// ## Examples
///
/// ```gleam
/// disassemble_to_groups("사과")
/// // -> [["ㅅ", "ㅏ"], ["ㄱ", "ㅗ", "ㅏ"]]
///
/// disassemble_to_groups("ㅘ")
/// // -> [["ㅗ", "ㅏ"]]
///
/// disassemble_to_groups("ㄵ")
/// // -> [["ㄴ", "ㅈ"]]
///
/// disassemble_to_groups("hello")
/// // -> [["h"], ["e"], ["l"], ["l"], ["o"]]
/// ```
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

/// Disassembles a single complete Korean Hangul character into its constituent parts.
/// This function only works with complete Hangul syllables (가-힣 range) and returns
/// detailed information about the choseong (initial), jungseong (medial), and jongseong (final) components.
///
/// ## Return Value
///
/// - `Ok(HangulSyllable)`: Contains the disassembled components
///   - `choseong`: Initial consonant (e.g., "ㄱ")
///   - `jungseong`: Medial vowel (e.g., "ㅏ") 
///   - `jongseong`: Final consonant(s) (e.g., "ㅂㅅ" or "" if none)
/// - `Error(IncompleteHangul)`: Input is a Hangul jamo but not a complete syllable
/// - `Error(NonHangulCharacter)`: Input is not a Korean character
/// - `Error(EmptyString)`: Input string is empty
///
/// ## Examples
///
/// ```gleam
/// disassemble_complete_character("값")
/// // -> Ok(HangulSyllable(Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㅂㅅ")))
///
/// disassemble_complete_character("리")
/// // -> Ok(HangulSyllable(Choseong("ㄹ"), Jungseong("ㅣ"), Jongseong("")))
///
/// disassemble_complete_character("ㅏ")
/// // -> Error(IncompleteHangul)
///
/// disassemble_complete_character("a")
/// // -> Error(NonHangulCharacter)
///
/// disassemble_complete_character("")
/// // -> Error(EmptyString)
/// ```
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
