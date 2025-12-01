// ========================================
// 音频管理模块
// 管理游戏的背景音乐和音效播放
// ========================================

// === 音频文件路径 ===
let bgm_menu: String = "sounds/menubgm.WAV"  // 主菜单背景音乐
let bgm_game: String = "sounds/gamebgm.WAV"  // 游戏背景音乐
let sfx_die: String = "sounds/die.WAV"  // 死亡音效
let sfx_flow_in: String = "sounds/flowin.WAV"  // 心流模式开启音效
let sfx_flow_out: String = "sounds/flowout.WAV"  // 心流模式结束音效
let sfx_coin: String = "sounds/coin.wav"  // 收集太极符音效

// === 音量设置 ===
let volume_bgm: Double = 0.3  // 背景音乐音量
let volume_sfx_normal: Double = 0.7  // 普通音效音量
let volume_sfx_flow: Double = 0.5  // 心流模式下的音效音量
let volume_sfx_special: Double = 0.8  // 特殊音效音量(死亡、心流切换)

// 当前播放的背景音乐路径
pub let current_bgm_path: Ref[Option[String]] = Ref::new(None)

// 静音指定背景音乐
fn mute_bgm_by_path(path: String) -> Unit {
  @audio.play_audio(path, volume=0.0, loop_=true)
}

// 播放音效
// @param sfx_path 音效文件路径
// @param volume 音量(0.0-1.0)
pub fn play_sfx(sfx_path: String, volume: Double) -> Unit {
  @audio.play_audio(sfx_path, volume=volume, loop_=false)
}

// 播放主菜单背景音乐
pub fn play_menu_bgm() -> Unit {
  if !bgm_enabled.val {
    mute_bgm_by_path(bgm_menu)
    mute_bgm_by_path(bgm_game)
    current_bgm_path.val = Some(bgm_menu)
    return
  }
  if current_bgm_path.val == Some(bgm_game) {
    mute_bgm_by_path(bgm_game)
  }
  @audio.play_audio(bgm_menu, volume=volume_bgm, loop_=true)
  current_bgm_path.val = Some(bgm_menu)
}

// 播放游戏背景音乐
pub fn play_game_bgm() -> Unit {
  if !bgm_enabled.val {
    mute_bgm_by_path(bgm_menu)
    mute_bgm_by_path(bgm_game)
    current_bgm_path.val = Some(bgm_game)
    return
  }
  if current_bgm_path.val == Some(bgm_menu) {
    mute_bgm_by_path(bgm_menu)
  }
  @audio.play_audio(bgm_game, volume=volume_bgm, loop_=true)
  current_bgm_path.val = Some(bgm_game)
}

// 播放死亡音效
pub fn play_die_sfx() -> Unit {
  if sfx_enabled.val {
    play_sfx(sfx_die, volume_sfx_special)
  }
}

// 播放心流模式开启音效
pub fn play_flow_in_sfx() -> Unit {
  if sfx_enabled.val {
    play_sfx(sfx_flow_in, volume_sfx_special)
  }
}

// 播放心流模式结束音效
pub fn play_flow_out_sfx() -> Unit {
  if sfx_enabled.val {
    play_sfx(sfx_flow_out, volume_sfx_special)
  }
}

// 播放收集太极符音效
// @param in_flow_mode 是否处于心流模式(影响音量)
pub fn play_coin_sfx(in_flow_mode: Bool) -> Unit {
  if !sfx_enabled.val {
    return
  }
  let volume = if in_flow_mode {
    volume_sfx_flow
  } else {
    volume_sfx_normal
  }
  play_sfx(sfx_coin, volume)
}