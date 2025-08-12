import hanguleam/core/composer
import hanguleam/core/batchim
import hanguleam/core/extractor
import hanguleam/core/parser
import hanguleam/core/validator
import hanguleam/core/editor

/// Extracts the initial consonants (choseong) from Korean Hangul characters in a string.
/// Non-Korean characters are filtered out, while whitespace characters (spaces, tabs, newlines)
/// are preserved in their original positions.
///
/// ## Examples
///
/// ```gleam
/// get_choseong("사과")
/// // -> "ㅅㄱ"
///
/// get_choseong("띄어 쓰기")
/// // -> "ㄸㅇ ㅆㄱ"
///
/// get_choseong("안녕hello")
/// // -> "ㅇㄴ"
/// ```
///
pub const get_choseong = extractor.get_choseong

/// Checks if the last character of a Korean string has a batchim (final consonant).
/// Returns `False` for empty strings, non-Korean characters, or incomplete Hangul.
///
/// ## Examples
///
/// ```gleam
/// has_batchim("값")
/// // -> True
/// 
/// has_batchim("토")
/// // -> False
/// 
/// has_batchim("hello")
/// // -> False
/// ```
///
pub const has_batchim = batchim.has_batchim

/// Checks if the last character of a Korean string has a batchim (final consonant) with filtering options.
/// Returns `False` for empty strings, non-Korean characters, or incomplete Hangul.
/// 
/// ## Options
/// 
/// - `None`: Checks for any batchim (single or double)
/// - `Some(HasBatchimOptions(only: Some(SingleOnly)))`: Only single batchim
/// - `Some(HasBatchimOptions(only: Some(DoubleOnly)))`: Only double batchim
///
/// ## Examples
///
/// ```gleam
/// import hanguleam/core/batchim.{HasBatchimOptions, SingleOnly, DoubleOnly}
/// import gleam/option.{None, Some}
/// 
/// has_batchim_with_options("값", None)
/// // -> True
/// 
/// has_batchim_with_options("갑", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> True
/// 
/// has_batchim_with_options("값", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> False (값 has double batchim ㅂ+ㅅ)
/// 
/// has_batchim_with_options("값", Some(HasBatchimOptions(only: Some(DoubleOnly))))
/// // -> True
/// ```
///
pub const has_batchim_with_options = batchim.has_batchim_with_options

/// Extracts detailed batchim information from the last character of a Korean string.
/// Returns comprehensive information about the batchim including its type and components.
/// This is an enhanced version that provides more detail than `has_batchim`.
///
/// ## Return Value
///
/// - `Ok(BatchimInfo)`: Contains character, batchim type, and component breakdown
/// - `Error(EmptyString)`: Input string is empty
/// - `Error(InvalidCharacter(char))`: Last character is not complete Hangul
///
/// ## Examples
///
/// ```gleam
/// get_batchim("강")
/// // -> Ok(BatchimInfo(character: "강", batchim_type: Single, components: ["ㅇ"]))
/// 
/// get_batchim("값")
/// // -> Ok(BatchimInfo(character: "값", batchim_type: Double, components: ["ㅂ", "ㅅ"]))
/// 
/// get_batchim("가")
/// // -> Ok(BatchimInfo(character: "가", batchim_type: NoBatchim, components: []))
/// 
/// get_batchim("hello")
/// // -> Error(InvalidCharacter("o"))
/// 
/// get_batchim("")
/// // -> Error(EmptyString)
/// 
/// get_batchim("한글")
/// // -> Ok(BatchimInfo(character: "글", batchim_type: Single, components: ["ㄹ"]))
/// ```
///
pub const get_batchim = batchim.get_batchim

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
///
pub const disassemble = parser.disassemble

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
///
pub const disassemble_to_groups = parser.disassemble_to_groups

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
/// - `Error(NonHangul)`: Input is not a Korean character
/// - `Error(EmptyInput)`: Input string is empty
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
/// // -> Error(NonHangul)
///
/// disassemble_complete_character("")
/// // -> Error(EmptyInput)
/// ```
///
pub const disassemble_complete_character = parser.disassemble_complete_character

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
///
pub const remove_last_character = editor.remove_last_character

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
///
pub const can_be_choseong = validator.can_be_choseong

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
///
pub const can_be_jungseong = validator.can_be_jungseong

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
///
pub const can_be_jongseong = validator.can_be_jongseong

/// Combines two Korean vowels into a single complex vowel if possible.
///
/// ## Examples
///
/// ```gleam
/// combine_vowels("ㅗ", "ㅏ")
/// // -> "ㅘ"
///
/// combine_vowels("ㅣ", "ㅏ")
/// // -> "ㅣㅏ" (no combination possible)
/// ```
///
pub const combine_vowels = composer.combine_vowels

/// Combines Korean jamo components into a complete Hangul syllable.
///
/// ## Examples
///
/// ```gleam
/// combine_character(choseong: "ㄱ", jungseong: "ㅏ", jongseong: "")
/// // -> Ok("가")
///
/// combine_character(choseong: "ㄲ", jungseong: "ㅠ", jongseong: "ㅇ")
/// // -> Ok("뀽")
/// ```
///
pub const combine_character = composer.combine_character

/// Assembles Korean text fragments by intelligently combining characters.
/// Processes fragments according to Korean linguistic rules including 
/// consonant-vowel combinations and Korean linking (연음).
///
/// ## Examples
///
/// ```gleam
/// assemble(["ㄱ", "ㅏ", "ㅂ"])
/// // -> "갑"
///
/// assemble(["안녕하", "ㅅ", "ㅔ", "요"])
/// // -> "안녕하세요"
///
/// assemble(["뀽", "ㅏ"])
/// // -> "뀨아"
/// ```
///
pub const assemble = composer.assemble
