import gleam/option.{type Option, None, Some}
import hanguleam/batchim
import hanguleam/internal/types

pub type JosaPair {
  JosaPair(with_batchim: String, without_batchim: String)
}

pub type JosaError {
  NoMatchingJosa
}

fn get_josa_pair(particle: String) -> Option(JosaPair) {
  case particle {
    // 이/가
    "이" | "가" -> option.Some(JosaPair("이", "가"))

    // 을/를
    "을" | "를" -> option.Some(JosaPair("을", "를"))

    // 은/는
    "은" | "는" -> option.Some(JosaPair("은", "는"))

    // 으로/로 (with ㄹ exception)
    "으로" | "로" -> option.Some(JosaPair("으로", "로"))

    // 과/와
    "과" | "와" -> option.Some(JosaPair("과", "와"))

    // 이나/나
    "이나" | "나" -> option.Some(JosaPair("이나", "나"))

    // 이란/란
    "이란" | "란" -> option.Some(JosaPair("이란", "란"))

    // 아/야
    "아" | "야" -> option.Some(JosaPair("아", "야"))

    // 이랑/랑
    "이랑" | "랑" -> option.Some(JosaPair("이랑", "랑"))

    // 이에요/예요
    "이에요" | "예요" -> option.Some(JosaPair("이에요", "예요"))

    // 으로서/로서 (with ㄹ exception)
    "으로서" | "로서" -> option.Some(JosaPair("으로서", "로서"))

    // 으로써/로써 (with ㄹ exception)
    "으로써" | "로써" -> option.Some(JosaPair("으로써", "로써"))

    // 으로부터/로부터 (with ㄹ exception)
    "으로부터" | "로부터" -> option.Some(JosaPair("으로부터", "로부터"))

    // 이라/라
    "이라" | "라" -> option.Some(JosaPair("이라", "라"))

    _ -> option.None
  }
}

pub fn pick(word: String, particle: String) -> Result(String, JosaError) {
  case get_josa_pair(particle) {
    Some(pair) -> Ok(select_josa(word, pair))
    None -> Error(NoMatchingJosa)
  }
}

fn select_josa(word: String, pair: JosaPair) -> String {
  let JosaPair(with_batchim, without_batchim) = pair

  case needs_batchim_josa(word, with_batchim) {
    True -> with_batchim
    False -> without_batchim
  }
}

fn needs_batchim_josa(word, particle) -> Bool {
  case particle {
    "으로" | "로" | "으로서" | "로서" | "으로써" | "로써" | "으로부터" | "로부터" ->
      has_non_rieul_batchim(word)
    _ -> batchim.has_batchim(word)
  }
}

// "ㄹ" irregular: words ending in "ㄹ" use "no batchim" form when joined with "로" josa
fn has_non_rieul_batchim(word) -> Bool {
  case batchim.get_batchim(word) {
    Ok(batchim_info) if batchim_info.batchim_type != types.NoBatchim ->
      batchim_info.batchim != "ㄹ"
    _ -> False
  }
}

pub fn make_josa_selector(
  particle: String,
) -> fn(String) -> Result(String, JosaError) {
  fn(word: String) { pick(word, particle) }
}

pub fn i_ga(word) -> Result(String, JosaError) {
  pick(word, "이")
}

pub fn eul_reul(word) -> Result(String, JosaError) {
  pick(word, "을")
}

pub fn eun_neun(word) -> Result(String, JosaError) {
  pick(word, "은")
}

pub fn euro_ro(word) -> Result(String, JosaError) {
  pick(word, "으로")
}

pub fn gwa_wa(word) -> Result(String, JosaError) {
  pick(word, "과")
}

pub fn ina_na(word) -> Result(String, JosaError) {
  pick(word, "이나")
}

pub fn iran_ran(word) -> Result(String, JosaError) {
  pick(word, "이란")
}

pub fn a_ya(word) -> Result(String, JosaError) {
  pick(word, "아")
}

pub fn irang_rang(word) -> Result(String, JosaError) {
  pick(word, "이랑")
}

pub fn ieyo_yeoyo(word) -> Result(String, JosaError) {
  pick(word, "이에요")
}

pub fn euroseo_roseo(word) -> Result(String, JosaError) {
  pick(word, "로서")
}

pub fn eurosseo_rosseo(word) -> Result(String, JosaError) {
  pick(word, "로써")
}

pub fn eurobuteo_robuteo(word) -> Result(String, JosaError) {
  pick(word, "으로부터")
}

pub fn ira_ra(word) -> Result(String, JosaError) {
  pick(word, "이라")
}
