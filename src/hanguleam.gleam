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
