import gleam/list
import gleam/string
import glychee/benchmark
import glychee/configuration
import hanguleam/extractor

pub fn main() {
  configuration.initialize()
  configuration.set_pair(configuration.Warmup, 3)
  configuration.set_pair(configuration.Time, 5)
  configuration.set_pair(configuration.Parallel, 1)

  benchmark.run(
    [
      benchmark.Function(
        label: "get_choseong (to_graphemes)",
        callable: fn(test_data) { fn() { extractor.get_choseong(test_data) } },
      ),
      // benchmark.Function(
    //   label: "get_choseong_recurse (pop_grapheme)",
    //   callable: fn(test_data) {
    //     fn() { extractor.get_choseong_recurse(test_data) }
    //   },
    // ),
    ],
    [
      benchmark.Data(
        label: "Small Korean text (100 chars)",
        data: create_korean_text(100),
      ),
      benchmark.Data(
        label: "Medium Korean text (1,000 chars)",
        data: create_korean_text(1000),
      ),
      benchmark.Data(
        label: "Large Korean text (10,000 chars)",
        data: create_korean_text(10_000),
      ),
      benchmark.Data(
        label: "Very large Korean text (100,000 chars)",
        data: create_korean_text(100_000),
      ),
      benchmark.Data(
        label: "Mixed content (Korean + spaces + punctuation)",
        data: create_mixed_content(10_000),
      ),
    ],
  )
}

fn create_korean_text(length: Int) -> String {
  let korean_syllables = [
    "안", "녕", "하", "세", "요", "감", "사", "합", "니", "다", "한", "국", "어", "는", "아",
    "름", "다", "운", "언", "어", "입", "니", "다", "글", "림", "프", "로", "그", "래", "밍",
    "언", "어", "로", "개", "발", "하", "고", "있", "습", "니", "다", "성", "능", "테", "스",
    "트", "를", "위", "한", "텍", "스", "트", "데", "이", "터", "입", "니", "다", "한", "글",
  ]

  list.range(1, length)
  |> list.map(fn(i) {
    let index = i % list.length(korean_syllables)
    case list.drop(korean_syllables, index) |> list.first {
      Ok(syllable) -> syllable
      Error(_) -> "한"
    }
  })
  |> string.concat
}

fn create_mixed_content(length: Int) -> String {
  let content_parts = [
    "안녕하세요", " ", "한국어", "\t", "테스트", "\n", "글림", " ", "프로그래밍", "\t", "언어", "\n",
    "성능", " ", "벤치마크", "\t", "테스트", "\n",
  ]

  list.range(1, length / 10)
  // Divide by average part length
  |> list.map(fn(i) {
    let index = i % list.length(content_parts)
    case list.drop(content_parts, index) |> list.first {
      Ok(part) -> part
      Error(_) -> "한"
    }
  })
  |> string.concat
  |> string.slice(0, length)
}
