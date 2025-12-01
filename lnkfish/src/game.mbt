// 游戏状态枚举
// 定义游戏的所有可能状态
pub enum GameState {
  Loading       // 加载界面
  MainMenu      // 主菜单
  LevelSelect   // 关卡选择
  GameSettings  // 游戏设置
  Help          // 帮助说明
  Ready         // 准备开始
  Playing       // 游戏进行中
  Paused        // 暂停
  GameOver      // 游戏结束
  GameWon       // 关卡胜利
  Leaderboard   // 排行榜
} derive(Eq)

// 心流模式显示状态
// 用于区分显示计数器还是心流动画
pub enum FlowModeDisplayState {
  Score(Int)  // 显示已收集的太极符数量(0-2)
  Flowing     // 心流模式激活,显示动画
} derive(Eq)

// === 全局游戏状态变量 ===
pub let game_state: Ref[GameState] = Ref::new(Loading)  // 当前游戏状态
pub let game_session_id: Ref[Int] = Ref::new(0)  // 游戏会话ID,用于区分不同游戏局
pub let current_level_index: Ref[Int] = Ref::new(0)  // 当前关卡索引(0-3对应起承转合)
pub let is_endless_mode: Ref[Bool] = Ref::new(false)  // 是否为无限模式

// === 实体引用 ===
pub let visual_entity: Ref[@system.Entity?] = Ref::new(None)  // 双鱼视觉实体(显示的图像)
pub let collider_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 双鱼碰撞体实体(黑白两个)
pub let obstacle_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 所有障碍物实体列表
pub let taiji_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 所有太极符实体列表
pub let ui_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // UI实体列表

// === 菜单界面实体 ===
pub let menu_button_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 主菜单按钮
pub let level_select_button_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 关卡选择按钮
pub let help_text_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 帮助文本
pub let pause_menu_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 暂停菜单
pub let game_settings_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 设置菜单
pub let leaderboard_ui_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 排行榜UI

// === 双鱼旋转相关 ===
pub let current_angle: Ref[Double] = Ref::new(0.0)  // 当前旋转角度(弧度)
pub let current_rotation_speed: Ref[Double] = Ref::new(0.0)  // 当前旋转速度(度/秒)
pub let current_rotation_speed_level: Ref[RotationSpeedLevel] = Ref::new(Medium)  // 旋转速度等级
pub let initial_offsets : Map[@system.Entity, InitialOffset] = Map::new()  // 碰撞体相对中心的初始偏移

// === 障碍物生成相关 ===
pub let obstacle_spawn_timer: Ref[Double] = Ref::new(0.0)  // 障碍物生成计时器
pub let level_current_index: Ref[Int] = Ref::new(0)  // 当前关卡障碍物序列索引
pub let last_generated_obstacle: Ref[Option[LastObstacleInfo]] = Ref::new(None)  // 上一个生成的障碍物信息

// === 太极符生成相关 ===
pub let taiji_spawn_timer: Ref[Double] = Ref::new(0.0)  // 太极符生成计时器
pub let taiji_level_current_index: Ref[Int] = Ref::new(0)  // 当前关卡太极符序列索引

// === 计分系统 ===
pub let score: Ref[Int] = Ref::new(0)  // 当前得分
pub let time_score_accumulator: Ref[Double] = Ref::new(0.0)  // 时间计分累加器
pub let time_score_rate: Ref[Double] = Ref::new(BASE_TIME_SCORE_RATE)  // 时间计分速率

// === 心流模式相关 ===
pub let flow_mode_score: Ref[Int] = Ref::new(0)  // 心流模式计数器(0-3)
pub let is_in_flow_mode: Ref[Bool] = Ref::new(false)  // 是否处于心流模式
pub let flow_mode_entity: Ref[@system.Entity?] = Ref::new(None)  // 心流模式逻辑实体
pub let flow_mode_ui_entity: Ref[@system.Entity?] = Ref::new(None)  // 心流模式UI实体
pub let flow_mode_border_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())  // 心流模式边框
pub let last_flow_mode_display_state: Ref[Option[FlowModeDisplayState]] = Ref::new(None)  // 上一次显示状态
pub let progress_bar_fill_entity: Ref[@system.Entity?] = Ref::new(None)  // 进度条填充实体

// === 游戏流程控制 ===
pub let game_won_timer_set: Ref[Bool] = Ref::new(false)  // 胜利计时器是否已设置

// === 音频设置 ===
pub let bgm_enabled: Ref[Bool] = Ref::new(true)  // 背景音乐是否启用
pub let sfx_enabled: Ref[Bool] = Ref::new(true)  // 音效是否启用
// === 数据结构定义 ===

// 上一个障碍物信息,用于生成时避免连续生成相同类型或位置过近的障碍物
pub struct LastObstacleInfo {
  obstacle_type: ObstacleType  // 障碍物类型
  x_position: Double           // X坐标位置
}

// 暂停时保存的速度信息
pub let paused_velocities: Map[@system.Entity, @math.Vec2D] = Map::new()

// 旋转速度等级
pub enum RotationSpeedLevel {
  Slow
  Medium
  Fast
} derive(Eq)

// 障碍物类型
pub enum ObstacleType {
  Black
  White
  Red
} derive(Eq)

// 障碍物变体(每种类型有两个不同形状的变体)
pub enum ObstacleVariant {
  V1
  V2
}

// 障碍物组件数据
pub struct Obstacle {
  obstacle_type: ObstacleType
  variant: ObstacleVariant
}
pub let obstacles : Map[@system.Entity, Obstacle] = Map::new()  // 障碍物组件映射

// 太极符组件数据
pub struct Taiji {
  is_taiji: Bool  // 标记是否为太极符
}
pub let taijis : Map[@system.Entity, Taiji] = Map::new()  // 太极符组件映射

// 初始偏移量(用于旋转计算)
pub struct InitialOffset(@math.Vec2D)

// 心流模式组件数据
pub struct FlowMode {
  duration: Double  // 剩余持续时间
}
pub let flow_mode_state: Map[@system.Entity, FlowMode] = Map::new()  // 心流模式状态映射

// 鱼碰撞体类型
pub enum FishColliderType {
  WhiteFish
  BlackFish
}

// 鱼碰撞体组件数据
pub struct FishCollider {
  fish_type: FishColliderType  // 黑鱼或白鱼
}
pub let fish_colliders: Map[@system.Entity, FishCollider] = Map::new()  // 鱼碰撞体组件映射

// 按钮状态数据
pub struct ButtonState {
  text: String
  normal_color: String
  hover_color: String
  is_hovered: Bool
}
pub let button_states: Map[@system.Entity, ButtonState] = Map::new()  // 按钮状态映射

// 排行榜条目数据
pub struct LeaderboardEntry {
  score: Int
  rank: Int
}

pub let leaderboard_entries: Ref[Array[LeaderboardEntry]] = Ref::new(Array::new())  // 排行榜数据
pub let score_saved_to_leaderboard: Ref[Bool] = Ref::new(false)  // 本局分数是否已保存

// === 随机数生成器 ===
// 使用线性同余生成器(LCG)实现确定性随机数
pub let rand_seed: Ref[Int] = Ref::new(12345)  // 随机数种子

// 生成[0, max)范围内的随机整数
pub fn next_rand_int(max: Int) -> Int {
  let a = 1103515245
  let c = 12345
  let m = 2147483647
  rand_seed.val = (a * rand_seed.val + c) % m
  let result = rand_seed.val % max
  if result < 0 { -result } else { result }
}

// 生成[0.0, 1.0)范围内的随机浮点数
pub fn next_rand_double() -> Double {
  let a = 1103515245
  let c = 12345
  let m = 2147483647
  rand_seed.val = (a * rand_seed.val + c) % m
  Double::from_int(rand_seed.val) / Double::from_int(m)
}

// 初始化随机数种子
pub fn init_rand_seed(seed: Int) -> Unit {
  rand_seed.val = if seed == 0 { 12345 } else { seed }
}

// 根据按钮文本获取字体大小
// "停"字需要特殊处理以保持视觉一致性
fn get_button_font_size(text: String) -> String {
  if text == "停" {
    "42px QIJIFALLBACK"
  } else {
    "40px QIJIFALLBACK"
  }
}
