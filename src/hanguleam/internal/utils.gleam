import gleam/list

pub fn get_value_by_index(
  index: Int,
  value_list: List(String),
) -> Result(String, Nil) {
  value_list |> list.drop(index) |> list.first
}

pub fn find_index(list: List(a), target: a) -> Result(Int, Nil) {
  list
  |> list.index_fold(Error(Nil), fn(acc, item, index) {
    case acc {
      Ok(_) -> acc
      Error(_) if item == target -> Ok(index)
      Error(_) -> acc
    }
  })
}
