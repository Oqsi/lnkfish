// ========================================
// 游戏系统函数
// 包含游戏重置、排行榜管理等核心功能
// ========================================

// 重置计数器,用于生成不同的随机数种子
let reset_counter: Ref[Int] = Ref::new(0)

// 重置游戏状态
// 清理所有实体,重置计分和游戏变量
pub fn reset_game() -> Unit {
  game_session_id.val = game_session_id.val + 1
  reset_counter.val = reset_counter.val + 1
  // 每次重置使用不同的随机数种子,确保游戏体验不同
  let new_seed = 12345 + reset_counter.val * 997 + (reset_counter.val * reset_counter.val % 10000)
  init_rand_seed(new_seed)
  
  // 无限模式下重置障碍物生成信息
  if is_endless_mode.val {
    last_generated_obstacle.val = None
  }
  
  score_saved_to_leaderboard.val = false
  
  // 清理所有障碍物实体
  for entity in obstacle_entities.val {
    entity.destroy()
  }
  
  // 清理所有太极符实体
  for entity in taiji_entities.val {
    entity.destroy()
  }
  
  // 清理所有UI实体
  for entity in ui_entities.val {
    entity.destroy()
  }
  
  // 清理暂停菜单实体
  for entity in pause_menu_entities.val {
    entity.destroy()
  }
  
  // 清空所有实体列表
  obstacle_entities.val.clear()
  taiji_entities.val.clear()
  ui_entities.val.clear()
  pause_menu_entities.val.clear()
  
  // 重置计分和游戏状态
  score.val = 0
  flow_mode_score.val = 0
  time_score_accumulator.val = 0.0
  
  // 重置心流模式
  is_in_flow_mode.val = false
  flow_mode_entity.val = None
  
  // 重置旋转状态
  current_angle.val = 0.0
  current_rotation_speed.val = 0.0
  // 重置生成计时器和索引
  obstacle_spawn_timer.val = 0.0
  level_current_index.val = 0
  taiji_spawn_timer.val = 0.0
  taiji_level_current_index.val = 0
  
  game_won_timer_set.val = false
  game_state.val = Ready
}

// 完全重置游戏
// 除了重置游戏状态外,还重置当前关卡索引
pub fn reset_game_full() -> Unit {
  reset_game()
  current_level_index.val = 0
}

// 保存分数到排行榜
// 使用冒泡排序对分数进行降序排列,保留前10名
// @param new_score 新分数
pub fn save_score_to_leaderboard(new_score: Int) -> Unit {
  let entries = leaderboard_entries.val
  entries.push({ score: new_score, rank: 0 })
  let len = entries.length()
  for i = 0; i < len - 1; i = i + 1 {
    for j = 0; j < len - i - 1; j = j + 1 {
      if entries[j].score < entries[j + 1].score {
        let temp = entries[j]
        entries[j] = entries[j + 1]
        entries[j + 1] = temp
      }
    }
  }
  let max_entries = if len > 10 { 10 } else { len }
  let top_entries = Array::new()
  for i = 0; i < max_entries; i = i + 1 {
    top_entries.push({ score: entries[i].score, rank: i + 1 })
  }
  leaderboard_entries.val = top_entries
}

// 获取排行榜条目
// @return 排行榜数组
pub fn get_leaderboard_entries() -> Array[LeaderboardEntry] {
  leaderboard_entries.val
}

// 游戏启动时执行
// 创建背景图
pub fn game_start(_delta : Double) -> Unit {
  add_background(@math.Vec2D(get_viewport_width(), get_viewport_height()))
}




