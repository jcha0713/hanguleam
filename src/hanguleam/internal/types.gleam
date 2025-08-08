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

pub type HangulCharacter {
  // '가'
  SimpleCV(Choseong, Jungseong)
  // '과'
  CompoundCV(Choseong, Jungseong)
  // '각'
  SimpleCVC(Choseong, Jungseong, Jongseong)
  // '곽'
  CompoundCVC(Choseong, Jungseong, Jongseong)
  // '갂'
  ComplexBatchim(Choseong, Jungseong, Jongseong)
  // '곾'
  CompoundComplexBatchim(Choseong, Jungseong, Jongseong)
}

pub type Jamo {
  Consonant(String)
  Vowel(String)
}

pub type CharacterType {
  NonHangul
  Empty
  CompleteHangul(syllable: HangulSyllable)
  IncompleteHangul(char: Jamo)
}
