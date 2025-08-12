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

/// Selects the appropriate Korean particle (josa) for a given word based on its final character.
/// Returns only the selected particle without attaching it to the word.
///
/// ## Examples
///
/// ```gleam
/// pick("하니", "이")  // -> Ok("가")
/// pick("달", "이")    // -> Ok("이")
/// pick("집", "으로")  // -> Ok("으로")
/// pick("학교", "으로") // -> Ok("로")
/// pick("하니", "xxx") // -> Error(NoMatchingJosa)
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

/// Creates a reusable josa selector function for a specific particle.
/// Returns a function that takes a word and selects the appropriate particle form.
///
/// ## Examples
///
/// ```gleam
/// let i_ga_selector = make_josa_selector("이")
/// let eul_reul_selector = make_josa_selector("을")
///
/// "하니" |> i_ga_selector   // -> Ok("가")
/// "달" |> i_ga_selector     // -> Ok("이")
/// "하니" |> eul_reul_selector // -> Ok("를")
/// "달" |> eul_reul_selector   // -> Ok("을")
/// ```
pub fn make_josa_selector(
  particle: String,
) -> fn(String) -> Result(String, JosaError) {
  fn(word: String) { pick(word, particle) }
}

// Pre-built selector functions

/// Selects "이" or "가" particle.
pub fn i_ga(word) -> Result(String, JosaError) {
  pick(word, "이")
}

/// Selects "을" or "를" particle.
pub fn eul_reul(word) -> Result(String, JosaError) {
  pick(word, "을")
}

/// Selects "은" or "는" particle.
pub fn eun_neun(word) -> Result(String, JosaError) {
  pick(word, "은")
}

/// Selects "으로" or "로" particle.
pub fn euro_ro(word) -> Result(String, JosaError) {
  pick(word, "으로")
}

/// Selects "과" or "와" particle.
pub fn gwa_wa(word) -> Result(String, JosaError) {
  pick(word, "과")
}

/// Selects "이나" or "나" particle.
pub fn ina_na(word) -> Result(String, JosaError) {
  pick(word, "이나")
}

/// Selects "이란" or "란" particle.
pub fn iran_ran(word) -> Result(String, JosaError) {
  pick(word, "이란")
}

/// Selects "아" or "야" particle.
pub fn a_ya(word) -> Result(String, JosaError) {
  pick(word, "아")
}

/// Selects "이랑" or "랑" particle.
pub fn irang_rang(word) -> Result(String, JosaError) {
  pick(word, "이랑")
}

/// Selects "이에요" or "예요" particle.
pub fn ieyo_yeoyo(word) -> Result(String, JosaError) {
  pick(word, "이에요")
}

/// Selects "으로서" or "로서" particle.
pub fn euroseo_roseo(word) -> Result(String, JosaError) {
  pick(word, "로서")
}

/// Selects "으로써" or "로써" particle.
pub fn eurosseo_rosseo(word) -> Result(String, JosaError) {
  pick(word, "로써")
}

/// Selects "으로부터" or "로부터" particle.
pub fn eurobuteo_robuteo(word) -> Result(String, JosaError) {
  pick(word, "으로부터")
}

/// Selects "이라" or "라" particle.
pub fn ira_ra(word) -> Result(String, JosaError) {
  pick(word, "이라")
}
