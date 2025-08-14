import gleam/list
import gleam/string

import hanguleam/internal/unicode.{
  assemble_consonant_string, assemble_vowel_string, is_compatibility_choseong,
  is_compatibility_jongseong, is_compatibility_jungseong, is_modern_choseong,
  is_modern_jongseong, is_modern_jungseong, jongseongs, jungseongs,
}

/// Checks if a given character can be used as a choseong (initial consonant) in Korean Hangul.
/// A choseong is the first consonant in a Korean syllable that appears at the beginning.
///
/// ## Examples
///
/// ```gleam
/// can_be_choseong("ㄱ")
/// // -> True
///
/// can_be_choseong("ㅃ")
/// // -> True
///
/// can_be_choseong("ㄱㅅ")
/// // -> False (multiple characters)
///
/// can_be_choseong("ㅏ")
/// // -> False (vowel, not consonant)
///
/// can_be_choseong("가")
/// // -> False (complete syllable, not individual jamo)
/// ```
pub fn can_be_choseong(char: String) -> Bool {
  is_modern_choseong(char) || is_compatibility_choseong(char)
}

/// Checks if a given character can be used as a jungseong (medial vowel) in Korean Hangul.
/// A jungseong is the vowel that appears in the middle of a Korean syllable.
/// This function supports both single vowels and complex vowels (diphthongs).
///
/// ## Examples
///
/// ```gleam
/// can_be_jungseong("ㅏ")
/// // -> True
///
/// can_be_jungseong("ㅗㅏ")
/// // -> True (complex vowel ㅘ)
///
/// can_be_jungseong("ㅏㅗ")
/// // -> False (invalid vowel combination)
///
/// can_be_jungseong("ㄱ")
/// // -> False (consonant, not vowel)
///
/// can_be_jungseong("ㄱㅅ")
/// // -> False (consonants, not vowel)
///
/// can_be_jungseong("가")
/// // -> False (complete syllable, not individual jamo)
/// ```
pub fn can_be_jungseong(char: String) -> Bool {
  case string.length(char) {
    1 -> is_modern_jungseong(char) || is_compatibility_jungseong(char)
    2 -> assemble_vowel_string(char) |> list.contains(jungseongs, _)
    _ -> False
  }
}

/// Checks if a given character can be used as a jongseong (final consonant) in Korean Hangul.
/// A jongseong is the final consonant that appears at the end of a Korean syllable.
/// This function supports single consonants, double consonants, and empty strings (no final consonant).
///
/// ## Examples
///
/// ```gleam
/// can_be_jongseong("ㄱ")
/// // -> True
///
/// can_be_jongseong("ㄱㅅ")
/// // -> True (double consonant ㄳ)
///
/// can_be_jongseong("")
/// // -> True (no final consonant is valid)
///
/// can_be_jongseong("ㅎㄹ")
/// // -> False (invalid consonant combination)
///
/// can_be_jongseong("가")
/// // -> False (complete syllable, not individual jamo)
///
/// can_be_jongseong("ㅏ")
/// // -> False (vowel, not consonant)
///
/// can_be_jongseong("ㅗㅏ")
/// // -> False (vowels, not consonants)
/// ```
pub fn can_be_jongseong(char: String) -> Bool {
  case string.length(char) {
    0 -> True
    1 -> is_modern_jongseong(char) || is_compatibility_jongseong(char)
    2 -> assemble_consonant_string(char) |> list.contains(jongseongs, _)
    _ -> False
  }
}
