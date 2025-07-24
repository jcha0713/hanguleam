pub type BatchimType {
  NoBatchim
  Single
  Double
}

pub type BatchimInfo {
  BatchimInfo(
    character: String,
    batchim_type: BatchimType,
    batchim: String,
    components: List(String),
  )
}

pub type Choseong {
  Choseong(String)
}

pub type Jungseong {
  Jungseong(String)
}

pub type Jongseong {
  Jongseong(String)
}

pub type HangulSyllable {
  HangulSyllable(Choseong, Jungseong, Jongseong)
}
