import hanguleam/core/batchim
import hanguleam/core/choseong

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
pub const get_choseong = choseong.get_choseong

/// Checks if the last character of a Korean string has a batchim (final consonant).
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
/// has_batchim("값", None)
/// // -> True
/// 
/// has_batchim("토", None)
/// // -> False
/// 
/// has_batchim("갑", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> True
/// 
/// has_batchim("값", Some(HasBatchimOptions(only: Some(SingleOnly))))
/// // -> False (값 has double batchim ㅂ+ㅅ)
/// 
/// has_batchim("값", Some(HasBatchimOptions(only: Some(DoubleOnly))))
/// // -> True
/// 
/// has_batchim("hello", None)
/// // -> False
/// ```
///
pub const has_batchim = batchim.has_batchim

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
