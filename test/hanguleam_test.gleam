import gleeunit
import gleeunit/should
import hanguleam

pub fn main() -> Nil {
  gleeunit.main()
}

// Integration tests for main public API
pub fn get_choseong_integration_test() {
  hanguleam.get_choseong("사과")
  |> should.equal("ㅅㄱ")
}
