import hanguleam/core/josa
import startest.{describe, it}
import startest/expect

pub fn josa_tests() {
  describe("josa module", [
    it("should select correct josa", fn() {
      // 이/가
      josa.pick("하니", "이") |> expect.to_equal(Ok("가"))
      josa.pick("달", "이") |> expect.to_equal(Ok("이"))
      josa.pick("하니", "가") |> expect.to_equal(Ok("가"))
      josa.pick("달", "가") |> expect.to_equal(Ok("이"))

      // 을/를
      josa.pick("하니", "을") |> expect.to_equal(Ok("를"))
      josa.pick("달", "을") |> expect.to_equal(Ok("을"))
      josa.pick("하니", "를") |> expect.to_equal(Ok("를"))
      josa.pick("달", "를") |> expect.to_equal(Ok("을"))

      // 은/는
      josa.pick("하니", "은") |> expect.to_equal(Ok("는"))
      josa.pick("달", "은") |> expect.to_equal(Ok("은"))
      josa.pick("하니", "는") |> expect.to_equal(Ok("는"))
      josa.pick("달", "는") |> expect.to_equal(Ok("은"))

      // 으로/로
      josa.pick("집", "으로") |> expect.to_equal(Ok("으로"))
      josa.pick("학교", "으로") |> expect.to_equal(Ok("로"))
      josa.pick("서울", "으로") |> expect.to_equal(Ok("로"))
      josa.pick("집", "로") |> expect.to_equal(Ok("으로"))
      josa.pick("학교", "로") |> expect.to_equal(Ok("로"))
      josa.pick("서울", "로") |> expect.to_equal(Ok("로"))

      // 과/와
      josa.pick("하니", "와") |> expect.to_equal(Ok("와"))
      josa.pick("달", "와") |> expect.to_equal(Ok("과"))
      josa.pick("하니", "과") |> expect.to_equal(Ok("와"))
      josa.pick("달", "과") |> expect.to_equal(Ok("과"))

      // 이나/나
      josa.pick("하니", "이나") |> expect.to_equal(Ok("나"))
      josa.pick("달", "이나") |> expect.to_equal(Ok("이나"))
      josa.pick("하니", "나") |> expect.to_equal(Ok("나"))
      josa.pick("달", "나") |> expect.to_equal(Ok("이나"))

      // 이란/란
      josa.pick("하니", "이란") |> expect.to_equal(Ok("란"))
      josa.pick("달", "이란") |> expect.to_equal(Ok("이란"))
      josa.pick("하니", "란") |> expect.to_equal(Ok("란"))
      josa.pick("달", "란") |> expect.to_equal(Ok("이란"))

      // 아/야
      josa.pick("하니", "아") |> expect.to_equal(Ok("야"))
      josa.pick("하니", "야") |> expect.to_equal(Ok("야"))
      josa.pick("달", "아") |> expect.to_equal(Ok("아"))
      josa.pick("달", "야") |> expect.to_equal(Ok("아"))

      // 이랑/랑
      josa.pick("하니", "이랑") |> expect.to_equal(Ok("랑"))
      josa.pick("달", "이랑") |> expect.to_equal(Ok("이랑"))
      josa.pick("하니", "랑") |> expect.to_equal(Ok("랑"))
      josa.pick("달", "랑") |> expect.to_equal(Ok("이랑"))

      // 이에요/예요
      josa.pick("하니", "이에요") |> expect.to_equal(Ok("예요"))
      josa.pick("달", "이에요") |> expect.to_equal(Ok("이에요"))
      josa.pick("하니", "예요") |> expect.to_equal(Ok("예요"))
      josa.pick("달", "예요") |> expect.to_equal(Ok("이에요"))

      // 으로서/로서
      josa.pick("학생", "으로서") |> expect.to_equal(Ok("으로서"))
      josa.pick("친구", "으로서") |> expect.to_equal(Ok("로서"))
      josa.pick("건달", "으로서") |> expect.to_equal(Ok("로서"))
      josa.pick("학생", "로서") |> expect.to_equal(Ok("으로서"))
      josa.pick("친구", "로서") |> expect.to_equal(Ok("로서"))
      josa.pick("건달", "로서") |> expect.to_equal(Ok("로서"))

      // 으로써/로써
      josa.pick("힘", "으로써") |> expect.to_equal(Ok("으로써"))
      josa.pick("부모", "으로써") |> expect.to_equal(Ok("로써"))
      josa.pick("재물", "으로써") |> expect.to_equal(Ok("로써"))
      josa.pick("힘", "로써") |> expect.to_equal(Ok("으로써"))
      josa.pick("부모", "로써") |> expect.to_equal(Ok("로써"))
      josa.pick("재물", "로써") |> expect.to_equal(Ok("로써"))

      // 으로부터/로부터
      josa.pick("집", "으로부터") |> expect.to_equal(Ok("으로부터"))
      josa.pick("학교", "으로부터") |> expect.to_equal(Ok("로부터"))
      josa.pick("서울", "으로부터") |> expect.to_equal(Ok("로부터"))
      josa.pick("집", "로부터") |> expect.to_equal(Ok("으로부터"))
      josa.pick("학교", "로부터") |> expect.to_equal(Ok("로부터"))
      josa.pick("서울", "로부터") |> expect.to_equal(Ok("로부터"))

      // 이라/라
      josa.pick("하니", "이라") |> expect.to_equal(Ok("라"))
      josa.pick("달", "이라") |> expect.to_equal(Ok("이라"))
      josa.pick("하니", "라") |> expect.to_equal(Ok("라"))
      josa.pick("달", "라") |> expect.to_equal(Ok("이라"))
    }),
    it("should make josa selectors", fn() {
      let i_ga_selector = josa.make_josa_selector("이")
      let another_i_ga_selector = josa.make_josa_selector("가")

      "하니" |> i_ga_selector |> expect.to_equal(Ok("가"))
      "하니" |> another_i_ga_selector |> expect.to_equal(Ok("가"))

      "달" |> i_ga_selector |> expect.to_equal(Ok("이"))
      "달" |> another_i_ga_selector |> expect.to_equal(Ok("이"))
    }),
    it("should throw an Error for non matching josa", fn() {
      josa.pick("하니", "달") |> expect.to_equal(Error(josa.NoMatchingJosa))
    }),
  ])
}
