import gleam/option.{None, Some}
import gleeunit/should
import hanguleam/core/disassemble

pub fn has_batchim_with_batchim_test() {
  echo disassemble.disassemble("몽")
  echo disassemble.disassemble("쀍")
}
