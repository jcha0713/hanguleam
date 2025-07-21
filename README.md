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
  // Check if character has any batchim
  hanguleam.has_batchim("값", None) // True
  hanguleam.has_batchim("토", None) // False

  // Filter by batchim type
  hanguleam.has_batchim("갑", Some(HasBatchimOptions(only: Some(SingleOnly)))) // True
  hanguleam.has_batchim("값", Some(HasBatchimOptions(only: Some(DoubleOnly)))) // True
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
| **batchim** | `has_batchim` | Check if character has final consonant (with filtering options) |
| **batchim** | `get_batchim` | Get detailed batchim information including type and components |

### Function Details

#### `get_choseong(text: String) -> String`
Extracts initial consonants (choseong) from Korean Hangul characters, preserving whitespace and filtering out non-Korean characters.

#### `has_batchim(text: String, options: Option(HasBatchimOptions)) -> Bool`
Checks if the last character has a batchim (final consonant). Supports filtering by single or double batchim types.

#### `get_batchim(text: String) -> Result(BatchimInfo, BatchimError)`
Returns comprehensive batchim analysis including character, type classification, and component breakdown.
