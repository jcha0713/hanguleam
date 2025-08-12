import startest.{describe, it}
import gleam/option.{Some}
import startest/expect
import hanguleam/batchim
import hanguleam/internal/types.{Double, NoBatchim, Single}

pub fn batchim_tests() {
  describe("batchim module", [
    describe("has_batchim function", [
      describe("basic functionality", [
        it("should detect character with batchim", fn() {
          batchim.has_batchim("강")
          |> expect.to_equal(True)
        }),
        it("should detect character without batchim", fn() {
          batchim.has_batchim("가")
          |> expect.to_equal(False)
        }),
        it("should handle empty string", fn() {
          batchim.has_batchim("")
          |> expect.to_equal(False)
        }),
        it("should handle non-korean characters", fn() {
          batchim.has_batchim("a")
          |> expect.to_equal(False)
        }),
      ]),
      describe("simple has_batchim without options", [
        it("should detect various characters with batchim", fn() {
          batchim.has_batchim("강") |> expect.to_equal(True)
          batchim.has_batchim("닭") |> expect.to_equal(True)
          batchim.has_batchim("값") |> expect.to_equal(True)
        }),
        it("should detect characters without batchim", fn() {
          batchim.has_batchim("가") |> expect.to_equal(False)
          batchim.has_batchim("토") |> expect.to_equal(False)
        }),
      ]),
    ]),
    describe("has_batchim_with_options function", [
      describe("single batchim filter", [
        it("should detect single batchim correctly", fn() {
          batchim.has_batchim_with_options(
            "강",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(True)

          batchim.has_batchim_with_options(
            "한",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(True)

          batchim.has_batchim_with_options(
            "밥",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(True)
        }),
        it("should reject double batchim when filtering for single", fn() {
          batchim.has_batchim_with_options(
            "닭",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(False)

          batchim.has_batchim_with_options(
            "앉",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(False)
        }),
      ]),
      describe("double batchim filter", [
        it("should detect double batchim correctly", fn() {
          batchim.has_batchim_with_options(
            "닭",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(True)

          batchim.has_batchim_with_options(
            "앉",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(True)

          batchim.has_batchim_with_options(
            "값",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(True)
        }),
        it("should reject single batchim when filtering for double", fn() {
          batchim.has_batchim_with_options(
            "강",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(False)

          batchim.has_batchim_with_options(
            "한",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(False)
        }),
      ]),
      describe("no batchim with filters", [
        it("should fail both filters for characters without batchim", fn() {
          batchim.has_batchim_with_options(
            "가",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.SingleOnly))),
          )
          |> expect.to_equal(False)

          batchim.has_batchim_with_options(
            "가",
            options: Some(batchim.HasBatchimOptions(only: Some(batchim.DoubleOnly))),
          )
          |> expect.to_equal(False)
        }),
      ]),
    ]),
    describe("get_batchim function", [
      describe("success cases", [
        it("should handle character with no batchim", fn() {
          case batchim.get_batchim("가") {
            Ok(info) -> {
              info.character |> expect.to_equal("가")
              info.batchim_type |> expect.to_equal(NoBatchim)
              info.components |> expect.to_equal([])
            }
            Error(_) -> expect.to_be_true(False)
          }
        }),
        it("should handle character with single batchim", fn() {
          case batchim.get_batchim("강") {
            Ok(info) -> {
              info.character |> expect.to_equal("강")
              info.batchim_type |> expect.to_equal(Single)
              info.components |> expect.to_equal(["ㅇ"])
            }
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("한") {
            Ok(info) -> {
              info.character |> expect.to_equal("한")
              info.batchim_type |> expect.to_equal(Single)
              info.components |> expect.to_equal(["ㄴ"])
            }
            Error(_) -> expect.to_be_true(False)
          }
        }),
        it("should handle character with double batchim", fn() {
          case batchim.get_batchim("닭") {
            Ok(info) -> {
              info.character |> expect.to_equal("닭")
              info.batchim_type |> expect.to_equal(Double)
              info.components |> expect.to_equal(["ㄹ", "ㄱ"])
            }
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("값") {
            Ok(info) -> {
              info.character |> expect.to_equal("값")
              info.batchim_type |> expect.to_equal(Double)
              info.components |> expect.to_equal(["ㅂ", "ㅅ"])
            }
            Error(_) -> expect.to_be_true(False)
          }
        }),
      ]),
      describe("error cases", [
        it("should handle empty string", fn() {
          case batchim.get_batchim("") {
            Ok(_) -> expect.to_be_true(False)
            Error(batchim.EmptyString) -> expect.to_be_true(True)
            Error(_) -> expect.to_be_true(False)
          }
        }),
        it("should handle incomplete hangul", fn() {
          case batchim.get_batchim("ㄱ") {
            Ok(_) -> expect.to_be_true(False)
            Error(batchim.InvalidCharacter("ㄱ")) -> expect.to_be_true(True)
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("ㅏ") {
            Ok(_) -> expect.to_be_true(False)
            Error(batchim.InvalidCharacter("ㅏ")) -> expect.to_be_true(True)
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("a") {
            Ok(_) -> expect.to_be_true(False)
            Error(batchim.InvalidCharacter("a")) -> expect.to_be_true(True)
            Error(_) -> expect.to_be_true(False)
          }
        }),
      ]),
      describe("multi-character strings", [
        it("should use last character", fn() {
          case batchim.get_batchim("안녕하세요") {
            Ok(info) -> {
              info.character |> expect.to_equal("요")
              info.batchim_type |> expect.to_equal(NoBatchim)
              info.components |> expect.to_equal([])
            }
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("한글") {
            Ok(info) -> {
              info.character |> expect.to_equal("글")
              info.batchim_type |> expect.to_equal(Single)
              info.components |> expect.to_equal(["ㄹ"])
            }
            Error(_) -> expect.to_be_true(False)
          }

          case batchim.get_batchim("화가 난 까닭") {
            Ok(info) -> {
              info.character |> expect.to_equal("닭")
              info.batchim |> expect.to_equal("ㄺ")
              info.batchim_type |> expect.to_equal(Double)
              info.components |> expect.to_equal(["ㄹ", "ㄱ"])
            }
            Error(_) -> expect.to_be_true(False)
          }
        }),
      ]),
    ]),
  ])
}