// This library provides Korean text processing utilities.
// You can either:
// 1. Import from hanguleam directly for common functions
// 2. Import specific modules for advanced functionality:
//
// - hanguleam/extractor: Extract choseong (initial consonants)  
// - hanguleam/batchim: Check and analyze batchim (final consonants)
// - hanguleam/parser: Disassemble Hangul characters into jamo
// - hanguleam/composer: Assemble jamo into Hangul characters
// - hanguleam/editor: Edit Korean text (remove last character)
// - hanguleam/validator: Validate jamo components
// - hanguleam/josa: Handle Korean particles/postpositions
// - hanguleam/types: Advanced type definitions and constructors

// Re-export some core functions for convenience

import hanguleam/batchim
import hanguleam/composer
import hanguleam/extractor
import hanguleam/parser

pub const disassemble = parser.disassemble

pub const disassemble_complete_character = parser.disassemble_complete_character

pub const disassemble_to_groups = parser.disassemble_to_groups

pub const assemble = composer.assemble

pub const combine_character = composer.combine_character

pub const get_batchim = batchim.get_batchim

pub const has_batchim = batchim.has_batchim

pub const get_choseong = extractor.get_choseong
