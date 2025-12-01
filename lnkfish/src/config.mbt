// ========================================
// 游戏配置文件
// 包含所有游戏常量、资源定义和难度参数
// ========================================

// === 视口尺寸配置 ===
// 设计基准尺寸(桌面端标准分辨率)
pub const DESIGN_WIDTH : Double = 745.0
pub const DESIGN_HEIGHT : Double = 700.0

// 运行时动态尺寸(支持移动端更长的画面,由JavaScript动态设置)
let viewport_width : Ref[Double] = Ref::new(DESIGN_WIDTH)
let viewport_height : Ref[Double] = Ref::new(DESIGN_HEIGHT)

// 获取当前视口宽度
pub fn get_viewport_width() -> Double {
  viewport_width.val
}

// 获取当前视口高度
pub fn get_viewport_height() -> Double {
  viewport_height.val
}

// 从JavaScript设置Canvas尺寸
// 此函数在游戏启动前由HTML页面调用,以适配不同设备屏幕
pub fn set_viewport_size(width: Double, height: Double) -> Unit {
  viewport_width.val = width
  viewport_height.val = height
}

// 兼容性常量(用于不需要动态改变的地方,如某些UI计算)
pub const VIEWPORT_WIDTH : Double = DESIGN_WIDTH
pub const VIEWPORT_HEIGHT : Double = DESIGN_HEIGHT

// === 游戏玩法常量 ===
pub const FLOW_MODE_THRESHOLD: Int = 3  // 触发心流模式所需太极符数量
pub const FLOW_MODE_DURATION: Double = 6.0  // 心流模式持续时间(秒)
pub const TAIJI_SCORE_VALUE: Int = 50  // 收集一个太极符的分数
pub const BASE_TIME_SCORE_RATE: Double = 5.0  // 基础时间计分速率(分/秒)

// === 旋转速度配置 ===
pub const ROTATION_SPEED_SLOW: Double = 90.0  // 慢速旋转(度/秒)
pub const ROTATION_SPEED_MEDIUM: Double = 120.0  // 中速旋转(度/秒)
pub const ROTATION_SPEED_FAST: Double = 180.0  // 快速旋转(度/秒)

// === 动画和图片资源定义 ===
// 主菜单双鱼动画
pub let menu_fishfish_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/meun_fish.png", 30, width=360.0, height=360.0),
  loop_=true,
  fps=5,
  transform=@math.Transform::from_scale(0.60, 0.60),
)

// 漂浮动画(慢速,用于静止状态)
pub let drift_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/sprite.png", 8, width=1030.0, height=1030.0),
  loop_=true,
  fps=2,
  transform=@math.Transform::from_scale(0.25, 0.25),
)

// 游动动画(快速,顺时针旋转时使用)
pub let swim_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/sprite.png", 8, width=1030.0, height=1030.0),
  loop_=true,
  fps=4,
  transform=@math.Transform::from_scale(0.25, 0.25),
)

// 游动动画-逆向(快速,逆时针旋转时使用)
pub let swim_counter_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/sprite_counter.png", 8, width=1030.0, height=1030.0),
  loop_=true,
  fps=4,
  transform=@math.Transform::from_scale(0.25, 0.25),
)

// === 障碍物图片资源 ===
// 黑色障碍物变体1(正常状态)
pub let black_obstacle_v1_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(240.0, 90.0),
  "assets/black1.png",
)

// 黑色障碍物变体1(碰撞状态)
pub let black_obstacle_v1_hit_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(240.0, 90.0),
  "assets/black1_hit.png",
)

// 黑色障碍物变体2(正常状态)
pub let black_obstacle_v2_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(190.0, 440.0),
  "assets/black2.png",
  transform=@math.Transform::from_scale(0.75, 0.75),
)

// 黑色障碍物变体2(碰撞状态)
pub let black_obstacle_v2_hit_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(190.0, 440.0),
  "assets/black2_hit.png",
  transform=@math.Transform::from_scale(0.75, 0.75),
)
pub let white_obstacle_v1_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(160.0, 160.0),
  "assets/white1.png",
)
pub let white_obstacle_v1_hit_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(160.0, 160.0),
  "assets/white1_hit.png",
)
pub let white_obstacle_v2_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(450.0, 395.0),
  "assets/white2.png",
  transform=@math.Transform::from_scale(0.5, 0.5),
)
pub let white_obstacle_v2_hit_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(450.0, 395.0),
  "assets/white2_hit.png",
  transform=@math.Transform::from_scale(0.5, 0.5),
)
pub let red_obstacle_v1_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(333.0, 333.0),
  "assets/red1.png",
  transform=@math.Transform::from_scale(0.25, 0.25),
)
pub let red_obstacle_v2_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(333.0, 333.0),
  "assets/red2.png",
  transform=@math.Transform::from_scale(0.25, 0.25),
)
pub let black_obstacle_picture : @sprite.Picture = black_obstacle_v1_picture
pub let white_obstacle_picture : @sprite.Picture = white_obstacle_v1_picture
pub let black_obstacle_hit_picture : @sprite.Picture = black_obstacle_v1_hit_picture
pub let white_obstacle_hit_picture : @sprite.Picture = white_obstacle_v1_hit_picture
pub let red_obstacle_picture : @sprite.Picture = red_obstacle_v1_picture

// 太极符旋转动画
pub let taiji_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/taiji.png", 8, width=243.0, height=243.0),
  loop_=true,
  fps=8,
  transform=@math.Transform::from_scale(0.2, 0.2),
)

// 菜单标题图片
pub let menu_title_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(555.0, 175.0),
  "assets/menu_title.png",
)

// === 心流模式UI图片 ===
// 心流模式计数器-0个太极符
pub let flowmode0_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(194.0, 102.0),
  "assets/flow_mode0.png",
)
pub let flowmode1_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(194.0, 102.0),
  "assets/flow_mode1.png",
)
pub let flowmode2_picture : @sprite.Picture = @sprite.Picture::new(
  @math.Vec2D(194.0, 102.0),
  "assets/flow_mode2.png",
)
pub let flowmode6s_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas("assets/flowmode6s.png", 24, width=196.0, height=102.0),
  loop_=true,
  fps=4,
)

// === 碰撞层定义 ===
// 用于定义不同实体间的碰撞关系
pub let white_fish_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()  // 白鱼碰撞层
pub let black_fish_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()
pub let white_obstacle_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()
pub let black_obstacle_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()
pub let taiji_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()
pub let red_obstacle_layer: @collision.CollisionLayer = @collision.CollisionLayer::new()  // 红色障碍物碰撞层

// === 障碍物生成位置范围 ===
// 定义不同类型障碍物在屏幕X轴上的生成范围
pub let black_v1_x_range: (Double, Double) = (300.0, 500.0)  // 黑色障碍物变体1
pub let black_v2_x_range: (Double, Double) = (300.0, 400.0)
pub let white_v1_x_range: (Double, Double) = (350.0, 500.0)
pub let white_v2_x_range: (Double, Double) = (300.0, 500.0)
pub let red_x_range: (Double, Double) = (350.0, 500.0)
pub let taiji_x_range: (Double, Double) = (350.0, 500.0)  // 太极符生成X范围
pub let taiji_delay_range: (Double, Double) = (3.0, 6.0)  // 太极符生成延迟范围(秒)

// === 无限模式批次生成配置 ===
pub let obstacle_batch_size: Int = 10  // 无限模式障碍物批次生成数量
pub let taiji_batch_size: Int = 4  // 无限模式太极符批次生成数量

// === 难度参数配置 ===
pub struct DifficultyParams {
  delay_min: Double
  delay_max: Double
  black_weight: Int
  white_weight: Int
  red_weight: Int
}

// 根据当前分数获取难度参数
// 分数越高,障碍物生成间隔越短,红色障碍物比例越高
pub fn get_difficulty_params(score: Int) -> DifficultyParams {
  if score < 100 {
    { delay_min: 1.6, delay_max: 2.4, black_weight: 35, white_weight: 35, red_weight: 30 }
  } else if score < 300 {
    { delay_min: 1.3, delay_max: 2.0, black_weight: 30, white_weight: 30, red_weight: 40 }
  } else {
    { delay_min: 1.0, delay_max: 1.6, black_weight: 25, white_weight: 25, red_weight: 50 }
  }
}

// === 关卡数据结构 ===

// 障碍物生成信息
pub struct ObstacleSpawnInfo {
  obstacle_type: ObstacleType
  variant: ObstacleVariant
  x_position: Double
  delay: Double
}

// 太极符生成信息
pub struct TaijiSpawnInfo {
  x_position: Double
  delay: Double
}

// 关卡数据
pub struct LevelData {
  obstacle_sequence: Array[ObstacleSpawnInfo]
  taiji_sequence: Array[TaijiSpawnInfo]
  name: String
  description: String
}

// === 关卡序列定义 ===
// 每个关卡包含预设的障碍物和太极符序列

// 第一关"起" - 障碍物序列
let level_qi_obstacles: Array[ObstacleSpawnInfo] = [
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 400.0, delay: 2.0 },
  { obstacle_type: White, variant: V1, x_position: 200.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 350.0, delay: 2.5 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 250.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 250.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 1.5 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 2.0 },
]

// 第一关"起" - 太极符序列
let level_qi_taiji: Array[TaijiSpawnInfo] = [
  { x_position: 300.0, delay: 5.0 },
  { x_position: 450.0, delay: 6.5 },
]

// 第二关"承" - 障碍物序列
let level_cheng_obstacles: Array[ObstacleSpawnInfo] = [
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 1.5 },
  { obstacle_type: White, variant: V2, x_position: 400.0, delay: 1.0 },
  { obstacle_type: White, variant: V1, x_position: 200.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 250.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V2, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 0.5 },
  { obstacle_type: White, variant: V2, x_position: 250.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 0.5 },
  { obstacle_type: Black, variant: V2, x_position: 350.0, delay: 2.5 },
  { obstacle_type: White, variant: V1, x_position: 250.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V2, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V2, x_position: 200.0, delay: 1.5 },
  { obstacle_type: Black, variant: V2, x_position: 400.0, delay: 1.5 },
  { obstacle_type: White, variant: V2, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 0.5 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 0.5 },
]

// 第二关"承" - 太极符序列
let level_cheng_taiji: Array[TaijiSpawnInfo] = [
  { x_position: 250.0, delay: 1.0 },
  { x_position: 450.0, delay: 3.0 },
  { x_position: 250.0, delay: 1.0 },
  { x_position: 250.0, delay: 8.0 },
  { x_position: 200.0, delay: 2.0 },
  { x_position: 350.0, delay: 1.5 },
]

// 第三关"转" - 障碍物序列(引入红色障碍物)
let level_zhuan_obstacles: Array[ObstacleSpawnInfo] = [
  { obstacle_type: Black, variant: V2, x_position: 250.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 300.0, delay: 1.0 },
  { obstacle_type: Red, variant: V1, x_position: 250.0, delay: 2.2 },
  { obstacle_type: White, variant: V2, x_position: 320.0, delay: 1.8 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.4 },
  { obstacle_type: Black, variant: V1, x_position: 380.0, delay: 1.6 },
  { obstacle_type: White, variant: V2, x_position: 360.0, delay: 1.5 },
  { obstacle_type: Red, variant: V2, x_position: 440.0, delay: 1.3 },
  { obstacle_type: Black, variant: V1, x_position: 300.0, delay: 1.4 },
  { obstacle_type: Red, variant: V2, x_position: 470.0, delay: 1.7 },
  { obstacle_type: White, variant: V2, x_position: 330.0, delay: 1.3 },
  { obstacle_type: Red, variant: V2, x_position: 250.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 460.0, delay: 1.2 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.4 },
  { obstacle_type: Red, variant: V1, x_position: 320.0, delay: 1.3 },
  { obstacle_type: White, variant: V1, x_position: 380.0, delay: 2.2 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 1.3 },
  { obstacle_type: Red, variant: V2, x_position: 410.0, delay: 1.4 },
  { obstacle_type: White, variant: V2, x_position: 440.0, delay: 1.6 },
  { obstacle_type: Black, variant: V1, x_position: 370.0, delay: 1.2 },
  { obstacle_type: Red, variant: V1, x_position: 350.0, delay: 1.3 },
  { obstacle_type: White, variant: V1, x_position: 460.0, delay: 1.1 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 2.3 },
  { obstacle_type: Red, variant: V2, x_position: 430.0, delay: 1.4 },
]

// 第三关"转" - 太极符序列
let level_zhuan_taiji: Array[TaijiSpawnInfo] = [
  { x_position: 400.0, delay: 3.5 },
  { x_position: 450.0, delay: 4.0 },
  { x_position: 380.0, delay: 3.5 },
  { x_position: 420.0, delay: 3.8 },
  { x_position: 410.0, delay: 3.2 },
  { x_position: 390.0, delay: 3.5 },
]

// 第四关"合" - 障碍物序列(最高难度)
let level_he_obstacles: Array[ObstacleSpawnInfo] = [
  { obstacle_type: Red, variant: V1, x_position: 250.0, delay: 0.5 },
  { obstacle_type: Black, variant: V1, x_position: 300.0, delay: 1.75 },
  { obstacle_type: White, variant: V2, x_position: 200.0, delay: 1.5 },
  { obstacle_type: Black, variant: V2, x_position: 360.0, delay: 1.1 },
  { obstacle_type: White, variant: V1, x_position: 350.0, delay: 1.0 },
  { obstacle_type: Red, variant: V1, x_position: 220.0, delay: 1.5 },
  { obstacle_type: Black, variant: V1, x_position: 380.0, delay: 1.3 },
  { obstacle_type: Black, variant: V2, x_position: 440.0, delay: 0.0 },
  { obstacle_type: Red, variant: V1, x_position: 320.0, delay: 2.5 },
  { obstacle_type: Black, variant: V2, x_position: 280.0, delay: 1.7 },
  { obstacle_type: Black, variant: V2, x_position: 330.0, delay: 1.2 },
  { obstacle_type: Red, variant: V2, x_position: 410.0, delay: 0.5 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: Black, variant: V1, x_position: 200.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 350.0, delay: 1.5 },
  { obstacle_type: White, variant: V1, x_position: 400.0, delay: 1.0 },
  { obstacle_type: Black, variant: V1, x_position: 400.0, delay: 2.0 },
  { obstacle_type: Black, variant: V2, x_position: 340.0, delay: 1.1 },
  { obstacle_type: White, variant: V2, x_position: 430.0, delay: 1.0 },
  { obstacle_type: Red, variant: V1, x_position: 350.0, delay: 2.0 },
  { obstacle_type: Red, variant: V2, x_position: 350.0, delay: 2.0 },
]

// 第四关"合" - 太极符序列
let level_he_taiji: Array[TaijiSpawnInfo] = [
  { x_position: 400.0, delay: 4.0 },
  { x_position: 450.0, delay: 4.2 },
  { x_position: 370.0, delay: 4.5 },
  { x_position: 420.0, delay: 3.8 },
  { x_position: 390.0, delay: 3.0 },
  { x_position: 460.0, delay: 3.5 },
  { x_position: 330.0, delay: 3.0 },
]

// === 关卡列表 ===
// 按顺序定义所有关卡
pub let all_levels: Array[LevelData] = [
  {
    obstacle_sequence: level_qi_obstacles,
    taiji_sequence: level_qi_taiji,
    name: "起",
    description: "旋转躲避  ☯ 异色相撞",
  },
  {
    obstacle_sequence: level_cheng_obstacles,
    taiji_sequence: level_cheng_taiji,
    name: "承",
    description: "三生万物  ☯ 黑白可越",
  },
  {
    obstacle_sequence: level_zhuan_obstacles,
    taiji_sequence: level_zhuan_taiji,
    name: "转",
    description: "三色交汇  ☯ 朱砂禁行",
  },
  {
    obstacle_sequence: level_he_obstacles,
    taiji_sequence: level_he_taiji,
    name: "合",
    description: "变化无常  ☯ 万象归一",
  },
]

// 当前关卡序列(初始为第一关)
pub let level_sequence: Array[ObstacleSpawnInfo] = level_qi_obstacles
pub let taiji_level_sequence: Array[TaijiSpawnInfo] = level_qi_taiji

// === 无限模式障碍物生成算法 ===
// 统计当前屏幕上的红色障碍物数量
// 用于限制同时存在的红色障碍物数量,避免过高难度
fn count_red_obstacles(active_obstacles: Array[@system.Entity]) -> Int {
  let mut count = 0
  for entity in active_obstacles {
    match obstacles.get(entity) {
      Some(obstacle) => {
        if obstacle.obstacle_type == Red {
          count = count + 1
        }
      }
      None => ()
    }
  }
  count
}

// 检查新障碍物生成是否安全
// 避免红色障碍物过多或障碍物位置过近
fn is_safe_to_generate(
  new_type: ObstacleType,
  new_x: Double,
  active_obstacles: Array[@system.Entity]
) -> Bool {
  if new_type == Red {
    let red_count = count_red_obstacles(active_obstacles)
    if red_count >= 2 {
      return false
    }
  }
  for entity in active_obstacles {
    match obstacles.get(entity) {
      Some(obstacle) => {
        match @position.positions.get(entity) {
          Some(pos) => {
            let x_diff = (new_x - pos.0[X]).abs()
            if obstacle.obstacle_type == new_type && x_diff < 100.0 {
              return false
            }
            if obstacle.obstacle_type != new_type && x_diff < 60.0 {
              return false
            }
          }
          None => ()
        }
      }
      None => ()
    }
  }
  true
}

// 检查障碍物间距是否安全
// 同类型障碍物需要更大的间距
fn is_obstacle_safe_spacing(
  new_type: ObstacleType,
  new_x: Double,
  last_type: ObstacleType,
  last_x: Double
) -> Bool {
  let x_diff = (new_x - last_x).abs()
  if new_type == last_type {
    return x_diff > 80.0
  }
  x_diff > 50.0
}

// 根据当前分数随机生成障碍物类型
// 分数越高,红色障碍物出现概率越大
fn generate_random_obstacle_type(current_score: Int) -> ObstacleType {
  let params = get_difficulty_params(current_score)
  let rand_val = next_rand_int(100)
  if rand_val < params.black_weight {
    Black
  } else if rand_val < params.black_weight + params.white_weight {
    White
  } else {
    Red
  }
}

// 随机生成障碍物变体
fn generate_random_variant() -> ObstacleVariant {
  if next_rand_int(2) == 0 { V1 } else { V2 }
}

// 根据障碍物类型生成随机X坐标
fn generate_random_x_position(
  obstacle_type: ObstacleType,
  variant: ObstacleVariant
) -> Double {
  let (x_min, x_max) = match (obstacle_type, variant) {
    (Black, V1) => black_v1_x_range
    (Black, V2) => black_v2_x_range
    (White, V1) => white_v1_x_range
    (White, V2) => white_v2_x_range
    (Red, _) => red_x_range
  }
  let range = x_max - x_min
  x_min + (next_rand_double() * range)
}

// 根据当前分数生成随机延迟
// 分数越高,延迟越短,难度越大
fn generate_random_delay(current_score: Int) -> Double {
  let params = get_difficulty_params(current_score)
  let range = params.delay_max - params.delay_min
  params.delay_min + (next_rand_double() * range)
}

// 生成单个障碍物
// 使用重试机制确保生成的障碍物符合安全规则
// @param current_score 当前分数,影响难度
// @param active_obstacles 当前屏幕上的所有障碍物
// @param last_info 上一个生成的障碍物信息
// @return 障碍物生成信息
pub fn generate_single_obstacle(
  current_score: Int,
  active_obstacles: Array[@system.Entity],
  last_info: Option[LastObstacleInfo]
) -> ObstacleSpawnInfo {
  let params = get_difficulty_params(current_score)
  let mut retry_count = 0
  let max_retries = 20
  
  while retry_count < max_retries {
    let obstacle_type = generate_random_obstacle_type(current_score)
    let variant = generate_random_variant()
    let x_position = generate_random_x_position(obstacle_type, variant)
    let safe_from_last = match last_info {
      Some(info) => is_obstacle_safe_spacing(obstacle_type, x_position, info.obstacle_type, info.x_position)
      None => true
    }
    if safe_from_last && is_safe_to_generate(obstacle_type, x_position, active_obstacles) {
      let delay = generate_random_delay(current_score)
      return {
        obstacle_type: obstacle_type,
        variant: variant,
        x_position: x_position,
        delay: delay,
      }
    }
    retry_count = retry_count + 1
  }
  let safe_type = match last_info {
    Some(info) => {
      if info.obstacle_type == Black { White }
      else if info.obstacle_type == White { Black }
      else { Black }
    }
    None => Black
  }
  let safe_x = 265.0
  let safe_variant = V1
  let safe_delay = params.delay_max
  {
    obstacle_type: safe_type,
    variant: safe_variant,
    x_position: safe_x,
    delay: safe_delay,
  }
}

// 为无限模式生成一批太极符
// @param batch_size 批次大小
// @return 太极符生成信息数组
pub fn generate_endless_taijis(batch_size: Int) -> Array[TaijiSpawnInfo] {
  let taijis = Array::new()
  let (x_min, x_max) = taiji_x_range
  let (delay_min_val, delay_max_val) = taiji_delay_range
  for i = 0; i < batch_size; i = i + 1 {
    let x_range = x_max - x_min
    let x_position = x_min + (next_rand_double() * x_range)
    let delay_range = delay_max_val - delay_min_val
    let delay = delay_min_val + (next_rand_double() * delay_range)
    taijis.push({
      x_position: x_position,
      delay: delay,
    })
  }
  taijis
}