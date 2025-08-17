# hanguleam

[![Package Version](https://img.shields.io/hexpm/v/hanguleam)](https://hex.pm/packages/hanguleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/hanguleam/)

This is a Gleam library for Korean text processing, providing comprehensive tools for handling Hangul characters. It's Gleam rewrite of [es-hangul](https://github.com/toss/es-hangul).

## Installation

```sh
gleam add hanguleam
```

## Usage

### Extract initial consonants (choseong)

```gleam
import hanguleam/extractor

pub fn main() {
  // Basic usage
  extractor.get_choseong("사과") // "ㅅㄱ"

  // Handles spaces and whitespace
  extractor.get_choseong("안녕 하세요") // "ㅇㄴ ㅎㅅㅇ"

  // Filters out non-Korean characters
  extractor.get_choseong("hello 안녕") // "ㅇㄴ"
}
```

### Check for batchim (final consonants)

```gleam
import hanguleam/batchim.{AnyBatchim, HasBatchimOptions, SingleOnly, DoubleOnly}

pub fn main() {
  // Simple check for any batchim
  batchim.has_batchim("값") // True
  batchim.has_batchim("토") // False

  // Advanced filtering by batchim type
  batchim.has_batchim_with_options("갑", HasBatchimOptions(only: SingleOnly)) // True
  batchim.has_batchim_with_options("값", HasBatchimOptions(only: DoubleOnly)) // True
}
```

### Get detailed batchim information

```gleam
import hanguleam/batchim

pub fn main() {
  // Get comprehensive batchim analysis
  case batchim.get_batchim("값") {
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
import hanguleam/parser

pub fn main() {
  // Disassemble into flat string
  parser.disassemble("값") // "ㄱㅏㅂㅅ"
  parser.disassemble("값이 비싸다") // "ㄱㅏㅂㅅㅇㅣ ㅂㅣㅆㅏㄷㅏ"

  // Disassemble into character groups
  parser.disassemble_to_groups("사과") // [["ㅅ", "ㅏ"], ["ㄱ", "ㅗ", "ㅏ"]]

  // Disassemble single complete character with detailed info
  case parser.disassemble_complete_character("값") {
    Ok(syllable) -> {
      // syllable contains Choseong("ㄱ"), Jungseong("ㅏ"), Jongseong("ㅂㅅ")
    }
    Error(_) -> // Handle incomplete Hangul, non-Hangul, or empty input
  }
}
```

### Remove last character (Korean-aware)

```gleam
import hanguleam/editor

pub fn main() {
  // Intelligently removes last Korean character component
  editor.remove_last_character("안녕하세요 값") // "안녕하세요 갑"
  editor.remove_last_character("전화") // "전호"

  // Works with non-Korean characters too
  editor.remove_last_character("Hello") // "Hell"
  editor.remove_last_character("") // ""
}
```

### Assemble Korean text fragments

```gleam
import hanguleam/composer

pub fn main() {
  // Combine consonant and vowel into syllable
  composer.assemble(["ㄱ", "ㅏ", "ㅂ"]) // "갑"

  // Intelligent text assembly with Korean rules
  composer.assemble(["안녕하", "ㅅ", "ㅔ", "요"]) // "안녕하세요"

  // Korean linking (연음) - consonant moves to next syllable
  composer.assemble(["뀽", "ㅏ"]) // "뀨아"

  // Combine vowels into complex vowels
  composer.combine_vowels("ㅗ", "ㅏ") // "ㅘ"

  // Build syllables from jamo components
  composer.combine_character(choseong: "ㄲ", jungseong: "ㅠ", jongseong: "ㅇ") // Ok("뀽")
}
```

### Validate Korean jamo components

```gleam
import hanguleam/validator

pub fn main() {
  // Check if character can be initial consonant (choseong)
  validator.can_be_choseong("ㄱ") // True
  validator.can_be_choseong("ㅏ") // False (vowel)
  validator.can_be_choseong("가") // False (complete syllable)

  // Check if character can be medial vowel (jungseong)
  validator.can_be_jungseong("ㅏ") // True
  validator.can_be_jungseong("ㅗㅏ") // True (complex vowel ㅘ)
  validator.can_be_jungseong("ㄱ") // False (consonant)

  // Check if character can be final consonant (jongseong)
  validator.can_be_jongseong("ㄱ") // True
  validator.can_be_jongseong("ㄱㅅ") // True (double consonant ㄳ)
  validator.can_be_jongseong("") // True (no final consonant)
  validator.can_be_jongseong("ㅏ") // False (vowel)
}
```

### Handle Korean particles (josa)

```gleam
import hanguleam/josa

pub fn main() {
  // Select appropriate particle for a word
  josa.pick("하니", "이") // Ok("가")
  josa.pick("달", "이") // Ok("이")
  josa.pick("집", "으로") // Ok("으로")
  josa.pick("학교", "으로") // Ok("로")

  // Use pre-built selector functions
  josa.i_ga("하니") // Ok("가")
  josa.eul_reul("달") // Ok("을")

  // Create custom selectors
  let euro_ro_selector = josa.make_josa_selector("으로")
  "집" |> euro_ro_selector // Ok("으로")
}
```

## Development

```sh
gleam test  # Run the tests
gleam run   # Run the project
```

## Available Modules

| Module                | Description                                     |
| --------------------- | ----------------------------------------------- |
| `hanguleam/extractor` | Extract choseong (initial consonants) from text |
| `hanguleam/batchim`   | Analyze batchim (final consonants)              |
| `hanguleam/parser`    | Disassemble Hangul characters into jamo         |
| `hanguleam/composer`  | Assemble jamo into Hangul characters            |
| `hanguleam/editor`    | Edit Korean text with intelligent decomposition |
| `hanguleam/validator` | Validate jamo components                        |
| `hanguleam/josa`      | Handle Korean particles/postpositions           |

Each module contains comprehensive documentation with examples. Import the specific modules you need to access their functions with full documentation.
