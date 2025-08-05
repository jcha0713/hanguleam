# hanguleam

[![Package Version](https://img.shields.io/hexpm/v/hanguleam)](https://hex.pm/packages/hanguleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/hanguleam/)

A Gleam port of [es-hangul](https://github.com/toss/es-hangul) for handling Korean Hangul characters.

## Installation

```sh
gleam add hanguleam
```

## Usage

### Extract initial consonants (choseong)

```gleam
import hanguleam

pub fn main() {
  // Basic usage
  hanguleam.get_choseong("사과") // "ㅅㄱ"

  // Handles spaces and whitespace
  hanguleam.get_choseong("안녕 하세요") // "ㅇㄴ ㅎㅅㅇ"

  // Filters out non-Korean characters
  hanguleam.get_choseong("hello 안녕") // "ㅇㄴ"
}
```

### Check for batchim (final consonants)

```gleam
import hanguleam
import hanguleam/core/batchim.{HasBatchimOptions, SingleOnly, DoubleOnly}
import gleam/option.{None, Some}

pub fn main() {
  // Simple check for any batchim
  hanguleam.has_batchim("값") // True
  hanguleam.has_batchim("토") // False

  // Advanced filtering by batchim type
  hanguleam.has_batchim_with_options("갑", Some(HasBatchimOptions(only: Some(SingleOnly)))) // True
  hanguleam.has_batchim_with_options("값", Some(HasBatchimOptions(only: Some(DoubleOnly)))) // True
}
```

### Get detailed batchim information

```gleam
import hanguleam

pub fn main() {
  // Get comprehensive batchim analysis
  case hanguleam.get_batchim("값") {
    Ok(info) -> {
      // info.character: "값"
      // info.batchim_type: Double
      // info.components: ["ㅂ", "ㅅ"]
    }
    Error(_) -> // Handle error cases
  }
}
```

### Disassemble Korean characters

```gleam
import hanguleam

pub fn main() {
  // Disassemble into flat string
  hanguleam.disassemble("값") // "ㄱㅏㅂㅅ"
  hanguleam.disassemble("값이 비싸다") // "ㄱㅏㅂㅅㅇㅣ ㅂㅣㅆㅏㄷㅏ"

  // Disassemble into character groups
  hanguleam.disassemble_to_groups("사과") // [["ㅅ", "ㅏ"], ["ㄱ", "ㅗ", "ㅏ"]]

  // Disassemble single complete character with detailed info
  case hanguleam.disassemble_complete_character("값") {
    Ok(syllable) -> {
      // syllable contains Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㅂㅅ")
    }
    Error(_) -> // Handle incomplete Hangul, non-Hangul, or empty input
  }
}
```

### Remove last character (Korean-aware)

```gleam
import hanguleam

pub fn main() {
  // Intelligently removes last Korean character component
  hanguleam.remove_last_character("안녕하세요 값") // "안녕하세요 갑"
  hanguleam.remove_last_character("전화") // "전호"

  // Works with non-Korean characters too
  hanguleam.remove_last_character("Hello") // "Hell"
  hanguleam.remove_last_character("") // ""
}
```

### Validate Korean jamo components

```gleam
import hanguleam

pub fn main() {
  // Check if character can be initial consonant (choseong)
  hanguleam.can_be_choseong("ㄱ") // True
  hanguleam.can_be_choseong("ㅏ") // False (vowel)
  hanguleam.can_be_choseong("가") // False (complete syllable)

  // Check if character can be medial vowel (jungseong)
  hanguleam.can_be_jungseong("ㅏ") // True
  hanguleam.can_be_jungseong("ㅗㅏ") // True (complex vowel ㅘ)
  hanguleam.can_be_jungseong("ㄱ") // False (consonant)

  // Check if character can be final consonant (jongseong)
  hanguleam.can_be_jongseong("ㄱ") // True
  hanguleam.can_be_jongseong("ㄱㅅ") // True (double consonant ㄳ)
  hanguleam.can_be_jongseong("") // True (no final consonant)
  hanguleam.can_be_jongseong("ㅏ") // False (vowel)
}
```

## Development

```sh
gleam test  # Run the tests
gleam run   # Run the project
```

## Available Functions

### Core Modules

| Module          | Function                         | Description                                                     |
| --------------- | -------------------------------- | --------------------------------------------------------------- |
| **choseong**    | `get_choseong`                   | Extract initial consonants from Korean text                     |
| **batchim**     | `has_batchim`                    | Check if character has final consonant (simple version)         |
| **batchim**     | `has_batchim_with_options`       | Check if character has final consonant (with filtering options) |
| **batchim**     | `get_batchim`                    | Get detailed batchim information including type and components  |
| **disassemble** | `disassemble`                    | Break down Hangul characters into constituent jamo              |
| **disassemble** | `disassemble_to_groups`          | Disassemble characters into grouped jamo arrays                 |
| **disassemble** | `disassemble_complete_character` | Disassemble single complete Hangul with detailed structure      |
| **disassemble** | `remove_last_character`          | Remove last character component (Korean-aware)                  |
| **validate**    | `can_be_choseong`                | Check if character can be used as initial consonant             |
| **validate**    | `can_be_jungseong`               | Check if character can be used as medial vowel                  |
| **validate**    | `can_be_jongseong`               | Check if character can be used as final consonant               |

### Function Details

#### `get_choseong(text: String) -> String`

Extracts initial consonants (choseong) from Korean Hangul characters, preserving whitespace and filtering out non-Korean characters.

#### `has_batchim(text: String) -> Bool`

Checks if the last character has a batchim (final consonant). Simple version that checks for any batchim type.

#### `has_batchim_with_options(text: String, options: Option(HasBatchimOptions)) -> Bool`

Checks if the last character has a batchim (final consonant). Advanced version with filtering by single or double batchim types.

#### `get_batchim(text: String) -> Result(BatchimInfo, BatchimError)`

Returns comprehensive batchim analysis including character, type classification, and component breakdown.

#### `disassemble(text: String) -> String`

Disassembles Korean Hangul characters into their constituent jamo. Complete syllables and individual jamo are broken down into basic components, while non-Korean characters are preserved.

#### `disassemble_to_groups(text: String) -> List(List(String))`

Disassembles Korean characters into groups of jamo components. Each character becomes a separate array of its constituent parts.

#### `disassemble_complete_character(char: String) -> Result(HangulSyllable, DisassembleError)`

Disassembles a single complete Hangul character into structured components (choseong, jungseong, jongseong). Only works with complete syllables in the 가-힣 range.

#### `remove_last_character(text: String) -> String`

Removes the last character component from a Korean string with intelligent Korean syllable decomposition. For complete Korean syllables, removes the last jamo component rather than the entire character. Works with mixed Korean/non-Korean content.

#### `can_be_choseong(char: String) -> Bool`

Checks if a given character can be used as a choseong (initial consonant) in Korean Hangul. Returns `True` for valid initial consonants like ㄱ, ㄴ, ㄷ, etc.

#### `can_be_jungseong(char: String) -> Bool`

Checks if a given character can be used as a jungseong (medial vowel) in Korean Hangul. Supports both single vowels (ㅏ, ㅓ, ㅗ, etc.) and complex vowels (ㅘ, ㅙ, ㅚ, etc.).

#### `can_be_jongseong(char: String) -> Bool`

Checks if a given character can be used as a jongseong (final consonant) in Korean Hangul. Supports single consonants, double consonants, and empty strings (no final consonant).
