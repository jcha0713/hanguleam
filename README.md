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

## Development

```sh
gleam test  # Run the tests
gleam run   # Run the project
```

## Available Functions

### Core Modules

| Module | Function | Description |
|--------|----------|-------------|
| **choseong** | `get_choseong` | Extract initial consonants from Korean text |
| **batchim** | `has_batchim` | Check if character has final consonant (simple version) |
| **batchim** | `has_batchim_with_options` | Check if character has final consonant (with filtering options) |
| **batchim** | `get_batchim` | Get detailed batchim information including type and components |
| **disassemble** | `disassemble` | Break down Hangul characters into constituent jamo |
| **disassemble** | `disassemble_to_groups` | Disassemble characters into grouped jamo arrays |
| **disassemble** | `disassemble_complete_character` | Disassemble single complete Hangul with detailed structure |

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
