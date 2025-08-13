import gleam/result
import gleam/string

import hanguleam/internal/unicode.{
  choseongs, complete_hangul_start, disassemble_consonant_string,
  disassemble_vowel_string, jongseongs, jungseongs, normalize_modern_jamo,
  number_of_jongseong, number_of_jungseong,
}
import hanguleam/internal/types.{
  type CharacterType, type HangulCharacter, type HangulSyllable, type Jamo,
  Choseong, CompleteHangul, ComplexBatchim, CompoundCV, CompoundCVC,
  CompoundComplexBatchim, Consonant, Empty, HangulSyllable, IncompleteHangul,
  Jongseong, Jungseong, NonHangul, SimpleCV, SimpleCVC, Vowel,
}
import hanguleam/internal/utils

pub fn get_character_type(char: String) -> CharacterType {
  case char {
    "" -> Empty
    _ -> {
      case utils.get_codepoint_result_from_char(char) {
        Ok(codepoint) ->
          case utils.is_complete_hangul(codepoint) {
            True -> {
              case decode_hangul_codepoint(codepoint) {
                Ok(syllable) -> {
                  CompleteHangul(syllable:)
                }
                Error(_) -> NonHangul
              }
            }
            False -> {
              case utils.is_hangul_alphabet(codepoint) {
                True ->
                  case parse_hangul_jamo(char) {
                    Ok(parsed) -> IncompleteHangul(char: parsed)
                    Error(_) -> NonHangul
                  }
                False -> NonHangul
              }
            }
          }
        Error(_) -> NonHangul
      }
    }
  }
}

pub fn decode_hangul_codepoint(
  codepoint_int: Int,
) -> Result(HangulSyllable, Nil) {
  let base = codepoint_int - complete_hangul_start

  let choseong_idx = base / { number_of_jungseong * number_of_jongseong }

  let jungseong_idx =
    base % { number_of_jungseong * number_of_jongseong } / number_of_jongseong

  let jongseong_idx = base % number_of_jongseong

  use choseong <- result.try(utils.get_value_by_index(choseong_idx, choseongs))
  use jungseong <- result.try(utils.get_value_by_index(
    jungseong_idx,
    jungseongs,
  ))
  use jongseong <- result.try(utils.get_value_by_index(
    jongseong_idx,
    jongseongs,
  ))

  let jungseong = disassemble_vowel_string(jungseong)
  let jongseong = disassemble_consonant_string(jongseong)

  Ok(HangulSyllable(
    Choseong(choseong),
    Jungseong(jungseong),
    Jongseong(jongseong),
  ))
}

pub fn parse_hangul_jamo(char: String) -> Result(Jamo, Nil) {
  // Normalize modern jamo to compatibility jamo for consistent processing
  let normalized_char = normalize_modern_jamo(char)
  use codepoint <- result.try(utils.get_codepoint_result_from_char(normalized_char))

  case utils.is_jungseong_range(codepoint) {
    True -> Ok(Vowel(disassemble_vowel_string(normalized_char)))
    False -> Ok(Consonant(disassemble_consonant_string(normalized_char)))
  }
}

pub fn parse_hangul_syllable(syllable: HangulSyllable) -> HangulCharacter {
  let HangulSyllable(Choseong(cho), Jungseong(jung), Jongseong(jong)) = syllable

  case jong, is_compound_vowel(jung), is_compound_consonant(jong) {
    "", False, _ -> SimpleCV(Choseong(cho), Jungseong(jung))
    "", True, _ -> CompoundCV(Choseong(cho), Jungseong(jung))
    _, False, False ->
      SimpleCVC(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, True, False ->
      CompoundCVC(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, False, True ->
      ComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong))
    _, True, True ->
      CompoundComplexBatchim(Choseong(cho), Jungseong(jung), Jongseong(jong))
  }
}

fn is_compound_vowel(vowel: String) -> Bool {
  string.length(vowel) > 1
}

fn is_compound_consonant(consonant: String) -> Bool {
  string.length(consonant) > 1
}
