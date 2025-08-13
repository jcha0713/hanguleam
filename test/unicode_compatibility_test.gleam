import hanguleam/composer
import hanguleam/parser
import startest.{describe, it}
import startest/expect

/// Test cases for Unicode Hangul compatibility issues
pub fn unicode_compatibility_tests() {
  describe("Unicode Hangul compatibility issues", [
    describe("Unicode block mixing", [
      it("should handle Hangul Jamo vs Compatibility Jamo consistently", fn() {
        // Hangul Jamo (U+1100-U+11FF) vs Compatibility Jamo (U+3131-U+318F)
        // These represent the same logical characters but in different blocks

        // U+3131 (Compatibility Jamo)
        let compatibility_jamo = "ㄱ"
        // U+1100 (Hangul Jamo - modern combining form)
        let hangul_jamo = "ᄀ"

        let result1 = parser.disassemble(compatibility_jamo)
        let result2 = parser.disassemble(hangul_jamo)

        result1 |> expect.to_equal(result2)
      }),
      it("should handle mixed jamo blocks in composition", fn() {
        // Compatibility jamo
        let result1 = composer.assemble(["ㄱ", "ㅏ"])
        // Hangul jamo
        let result2 = composer.assemble(["ᄀ", "ㅏ"])

        result1 |> expect.to_equal("가")
        result2 |> expect.to_equal("가")

        result1 |> expect.to_equal(result2)
      }),
    ]),
    describe("Unicode normalization issues", [
      it("should handle precomposed vs decomposed Hangul consistently", fn() {
        // Same logical character in different normalization forms

        // NFC: Single codepoint U+AC00
        let nfc_form = "가"
        // NFD: Decomposed form (if different)
        let nfd_form = "가"

        // Both should disassemble to the same result
        let result1 = parser.disassemble(nfc_form)
        let result2 = parser.disassemble(nfd_form)

        result1 |> expect.to_equal(result2)
      }),
    ]),
    describe("Character boundary edge cases", [
      it("should handle characters at Unicode block boundaries", fn() {
        // Test characters at the edges of defined ranges
        let first_hangul = "가"
        // U+AC00 - first complete Hangul
        let last_hangul = "힣"
        // U+D7A3 - last complete Hangul

        let result1 = parser.disassemble(first_hangul)
        let result2 = parser.disassemble(last_hangul)

        result1 |> expect.to_equal("ㄱㅏ")
        result2 |> expect.to_equal("ㅎㅣㅎ")
      }),
      it("should reject characters outside valid ranges gracefully", fn() {
        // Test characters just outside the valid Hangul ranges
        // Using simple hex escapes for invalid characters

        // Just before Hangul syllables block
        let before_hangul = "\u{ABFF}"
        // Just after Hangul syllables block
        let after_hangul = "\u{D7A4}"

        // Should handle gracefully (not crash, return sensible results)
        let result1 = parser.disassemble(before_hangul)
        let result2 = parser.disassemble(after_hangul)

        // Should return the original characters unchanged
        result1 |> expect.to_equal(before_hangul)
        result2 |> expect.to_equal(after_hangul)
      }),
    ]),
  ])
}
