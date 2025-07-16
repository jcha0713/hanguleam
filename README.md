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

## Development

```sh
gleam test  # Run the tests
gleam run   # Run the project
```

## Status

This is a work-in-progress port. Currently implements:

- ✅ `get_choseong` - Extract initial consonants

More functions from the original es-hangul library will be added over time.
