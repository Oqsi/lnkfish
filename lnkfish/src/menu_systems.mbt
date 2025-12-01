let main_menu_initialized: Ref[Bool] = Ref::new(false)
let level_select_initialized: Ref[Bool] = Ref::new(false)
let help_initialized: Ref[Bool] = Ref::new(false)
let game_settings_initialized: Ref[Bool] = Ref::new(false)

enum MenuButtonType {
  StartGame
  LevelSelect
  GameSettings
  Help
}

pub fn main_menu_system(_delta: Double) -> Unit {
  if game_state.val != MainMenu {
    if main_menu_initialized.val {
      for entity in menu_button_entities.val {
        entity.destroy()
      }
      menu_button_entities.val.clear()
      main_menu_initialized.val = false
    }
    return
  }
  play_menu_bgm()
  if main_menu_initialized.val { return }
  for entity in menu_button_entities.val {
    entity.destroy()
  }
  menu_button_entities.val.clear()
  let menu_animation_entity = @system.Entity::new()
  @sprite.sprites.set(menu_animation_entity, @sprite.Sprite::from_animation(menu_fishfish_animation, @ui.UI_ZINDEX))
  @position.positions.set(menu_animation_entity, @math.Vec2D(275.0, 150.0))
  @ui.uis.set(menu_animation_entity, @ui.Ui::new())
  menu_button_entities.val.push(menu_animation_entity)
  let title = @system.Entity::new()
  let title_sprite = @sprite.Sprite::from_picture(menu_title_picture, @ui.UI_ZINDEX)
  @sprite.sprites.set(title, title_sprite)
  @position.positions.set(title, @math.Vec2D(100, 40.0))
  @ui.uis.set(title, @ui.Ui::new())
  menu_button_entities.val.push(title)
  let start_button = create_menu_button("开始游戏", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 400.0), StartGame)
  menu_button_entities.val.push(start_button)
  let level_select_button = create_menu_button("选择关卡", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 480.0), LevelSelect)
  menu_button_entities.val.push(level_select_button)
  let settings_button = create_menu_button("游戏设置", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 560.0), GameSettings)
  menu_button_entities.val.push(settings_button)
  let help_button = create_menu_button("游戏说明", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 640.0), Help)
  menu_button_entities.val.push(help_button)
  main_menu_initialized.val = true
}

fn create_menu_button(text: String, pos: @math.Vec2D, button_type: MenuButtonType) -> @system.Entity {
  let button = @system.Entity::new()
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = Double::from_int(text.length()) * 30.0
  let text_height = 40.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  button_states.set(button, {
    text: text,
    normal_color: "white",
    hover_color: "black",
    is_hovered: false
  })
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    match button_type {
      StartGame => {
        is_endless_mode.val = false
        current_level_index.val = 0
        game_state.val = Ready
      }
      LevelSelect => {
        game_state.val = LevelSelect
      }
      GameSettings => {
        game_state.val = GameSettings
      }
      Help => {
        game_state.val = Help
      }
    }
  })
  @collision.pickables.set(button, pickable)
  button
}

pub fn level_select_system(_delta: Double) -> Unit {
  if game_state.val != LevelSelect {
    if level_select_initialized.val {
      for entity in level_select_button_entities.val {
        entity.destroy()
      }
      level_select_button_entities.val.clear()
      level_select_initialized.val = false
    }
    return
  }
  if level_select_initialized.val { return }
  for entity in level_select_button_entities.val {
    entity.destroy()
  }
  level_select_button_entities.val.clear()
  let title = @system.Entity::new()
  let title_text = @sprite.Sprite::from_text(
    @sprite.Text::new("选择关卡", font="60px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(title, title_text)
  @position.positions.set(title, @math.Vec2D(get_viewport_width() / 2.0 - 120.0, 100.0))
  @ui.uis.set(title, @ui.Ui::new())
  level_select_button_entities.val.push(title)
  let total_levels = all_levels.length()
  let start_x = get_viewport_width() / 2.0 - 180.0
  let button_y = 250.0
  let spacing = 90.0
  for i = 0; i < total_levels; i = i + 1 {
    let button_x = start_x + Double::from_int(i) * spacing
    let level_button = create_level_select_button(i + 1, @math.Vec2D(button_x, button_y), i)
    level_select_button_entities.val.push(level_button)
  }
  let endless_button_x = get_viewport_width() / 2.0 - 80.0
  let endless_button_y = 380.0
  let endless_button = create_level_select_button(99, @math.Vec2D(endless_button_x, endless_button_y), -2)
  level_select_button_entities.val.push(endless_button)
  let back_button_x = get_viewport_width() / 2.0 - 40.0
  let back_button_y = 480.0
  let back_button = create_level_select_button(-1, @math.Vec2D(back_button_x, back_button_y), -1)
  level_select_button_entities.val.push(back_button)
  level_select_initialized.val = true
}

fn create_level_select_button(display_num: Int, pos: @math.Vec2D, level_idx: Int) -> @system.Entity {
  let button = @system.Entity::new()
  let button_text = if display_num == -1 {
    "返回"
  } else if display_num == 99 {
    "无限模式"
  } else {
    let level_names = ["起", "承", "转", "合"]
    if display_num >= 1 && display_num <= level_names.length() {
      level_names[display_num - 1]
    } else {
      "关卡 \{display_num}"
    }
  }
  let text_sprite = @sprite.Sprite::from_text(
    @sprite.Text::new(button_text, font="50px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, text_sprite)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = Double::from_int(button_text.length()) * 30.0
  let text_height = 40.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  button_states.set(button, {
    text: button_text,
    normal_color: "white",
    hover_color: "black",
    is_hovered: false
  })
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    if level_idx == -1 {
      game_state.val = MainMenu
    } else if level_idx == -2 {
      is_endless_mode.val = true
      current_level_index.val = 0
      last_generated_obstacle.val = None
      game_state.val = Ready
    } else {
      is_endless_mode.val = false
      current_level_index.val = level_idx
      game_state.val = Ready
    }
  })
  @collision.pickables.set(button, pickable)
  button
}

pub fn help_system(_delta: Double) -> Unit {
  if game_state.val != Help {
    if help_initialized.val {
      for entity in help_text_entities.val {
        entity.destroy()
      }
      help_text_entities.val.clear()
      help_initialized.val = false
    }
    return
  }
  if help_initialized.val { return }
  for entity in help_text_entities.val {
    entity.destroy()
  }
  help_text_entities.val.clear()
  let title = @system.Entity::new()
  let title_text = @sprite.Sprite::from_text(
    @sprite.Text::new("游戏说明", font="60px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(title, title_text)
  @position.positions.set(title, @math.Vec2D(get_viewport_width() / 2.0 - 120.0, 100.0))
  @ui.uis.set(title, @ui.Ui::new())
  help_text_entities.val.push(title)
  let help_texts = [
    "游戏规则",
    "- 控制双鱼旋转躲避障碍物",
    "- 黑鱼躲避白色障碍物,白鱼躲避黑色障碍物",
    "- 红色障碍物会与黑鱼白鱼都发生碰撞",
    "操作方法",
    "- 左方向键/A键: 逆时针旋转",
    "- 右方向键/D键: 顺时针旋转",
    "- 空格键: 开始游戏/重试",
    "特殊机制",
    "- 收集太极符获得分数",
    "- 连续收集三个太极符触发心流模式",
    "- 心流模式持续六秒,期间可穿过黑白障碍物",
  ]
  
  let mut y_pos = 150.0
  for text in help_texts {
    let help_text = @system.Entity::new()
    let text_sprite = @sprite.Sprite::from_text(
      @sprite.Text::new(text, font="28px QIJIFALLBACK", color="grey"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(help_text, text_sprite)
    @position.positions.set(help_text, @math.Vec2D(120.0, y_pos))
    @ui.uis.set(help_text, @ui.Ui::new())
    help_text_entities.val.push(help_text)
    y_pos = y_pos + 35.0
  }
  let back_button = create_help_back_button("返回", @math.Vec2D(get_viewport_width() / 2.0 - 40.0, 650.0))
  help_text_entities.val.push(back_button)
  help_initialized.val = true
}

fn create_help_back_button(text: String, pos: @math.Vec2D) -> @system.Entity {
  let button = @system.Entity::new()
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = Double::from_int(text.length()) * 30.0
  let text_height = 40.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  button_states.set(button, {
    text: text,
    normal_color: "white",
    hover_color: "black",
    is_hovered: false
  })
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    game_state.val = MainMenu
  })
  @collision.pickables.set(button, pickable)
  button
}

pub fn handle_help_input_system(_delta: Double) -> Unit {
  if game_state.val != Help { return }
}

pub fn game_settings_system(_delta: Double) -> Unit {
  if game_state.val != GameSettings {
    if game_settings_initialized.val {
      for entity in game_settings_entities.val {
        entity.destroy()
      }
      game_settings_entities.val.clear()
      game_settings_initialized.val = false
    }
    return
  }
  if game_settings_initialized.val { return }
  for entity in game_settings_entities.val {
    entity.destroy()
  }
  game_settings_entities.val.clear()
  let title = @system.Entity::new()
  let title_text = @sprite.Sprite::from_text(
    @sprite.Text::new("游戏设置", font="60px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(title, title_text)
  @position.positions.set(title, @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 120.0, 100.0))
  @ui.uis.set(title, @ui.Ui::new())
  game_settings_entities.val.push(title)
  let speed_label = @system.Entity::new()
  let speed_label_text = @sprite.Sprite::from_text(
    @sprite.Text::new("旋转速度", font="40px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(speed_label, speed_label_text)
  @position.positions.set(speed_label, @math.Vec2D(120.0, 220.0))
  @ui.uis.set(speed_label, @ui.Ui::new())
  game_settings_entities.val.push(speed_label)
  let slow_button = create_speed_setting_button("慢", @math.Vec2D(330.0, 220.0), Slow)
  game_settings_entities.val.push(slow_button)
  
  let medium_button = create_speed_setting_button("中", @math.Vec2D(420.0, 220.0), Medium)
  game_settings_entities.val.push(medium_button)
  
  let fast_button = create_speed_setting_button("快", @math.Vec2D(510.0, 220.0), Fast)
  game_settings_entities.val.push(fast_button)
  let bgm_label = @system.Entity::new()
  let bgm_label_text = @sprite.Sprite::from_text(
    @sprite.Text::new("背景音乐", font="40px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(bgm_label, bgm_label_text)
  @position.positions.set(bgm_label, @math.Vec2D(120.0, 320.0))
  @ui.uis.set(bgm_label, @ui.Ui::new())
  game_settings_entities.val.push(bgm_label)
  let bgm_on_button = create_audio_toggle_button("开", @math.Vec2D(330.0, 320.0), true, true)
  game_settings_entities.val.push(bgm_on_button)
  
  let bgm_off_button = create_audio_toggle_button("关", @math.Vec2D(420.0, 320.0), true, false)
  game_settings_entities.val.push(bgm_off_button)
  let sfx_label = @system.Entity::new()
  let sfx_label_text = @sprite.Sprite::from_text(
    @sprite.Text::new("游戏音效", font="40px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(sfx_label, sfx_label_text)
  @position.positions.set(sfx_label, @math.Vec2D(120.0, 420.0))
  @ui.uis.set(sfx_label, @ui.Ui::new())
  game_settings_entities.val.push(sfx_label)
  let sfx_on_button = create_audio_toggle_button("开", @math.Vec2D(330.0, 420.0), false, true)
  game_settings_entities.val.push(sfx_on_button)
  
  let sfx_off_button = create_audio_toggle_button("关", @math.Vec2D(420.0, 420.0), false, false)
  game_settings_entities.val.push(sfx_off_button)
  let back_button = create_settings_back_button("返回", @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40.0, 540.0))
  game_settings_entities.val.push(back_button)
  game_settings_initialized.val = true
}

fn create_speed_setting_button(text: String, pos: @math.Vec2D, speed_level: RotationSpeedLevel) -> @system.Entity {
  let button = @system.Entity::new()
  let text_color = if current_rotation_speed_level.val == speed_level {
    "black"
  } else {
    "white"
  }
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color=text_color),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = 60.0
  let text_height = 50.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    current_rotation_speed_level.val = speed_level
    game_settings_initialized.val = false
  })
  @collision.pickables.set(button, pickable)
  button
}

fn create_audio_toggle_button(text: String, pos: @math.Vec2D, is_bgm: Bool, is_on: Bool) -> @system.Entity {
  let button = @system.Entity::new()
  let is_current = if is_bgm {
    bgm_enabled.val == is_on
  } else {
    sfx_enabled.val == is_on
  }
  let text_color = if is_current {
    "black"
  } else {
    "white"
  }
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color=text_color),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = 60.0
  let text_height = 50.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    if is_bgm {
      bgm_enabled.val = is_on
      if !is_on {
        mute_bgm_by_path(bgm_menu)
        mute_bgm_by_path(bgm_game)
      } else {
        match current_bgm_path.val {
          Some(path) => {
            if path == bgm_menu {
              play_menu_bgm()
            } else if path == bgm_game {
              play_game_bgm()
            }
          }
          None => ()
        }
      }
    } else {
      sfx_enabled.val = is_on
    }
    game_settings_initialized.val = false
  })
  @collision.pickables.set(button, pickable)
  button
}


fn create_settings_back_button(text: String, pos: @math.Vec2D) -> @system.Entity {
  let button = @system.Entity::new()
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = Double::from_int(text.length()) * 30.0
  let text_height = 40.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  button_states.set(button, {
    text: text,
    normal_color: "white",
    hover_color: "black",
    is_hovered: false
  })
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    game_state.val = MainMenu
  })
  @collision.pickables.set(button, pickable)
  button
}


let leaderboard_initialized: Ref[Bool] = Ref::new(false)
pub fn leaderboard_system(_delta: Double) -> Unit {
  if game_state.val != Leaderboard {
    if leaderboard_initialized.val {
      for entity in leaderboard_ui_entities.val {
        entity.destroy()
      }
      leaderboard_ui_entities.val.clear()
      leaderboard_initialized.val = false
    }
    return
  }
  if leaderboard_initialized.val { return }
  for entity in leaderboard_ui_entities.val {
    entity.destroy()
  }
  leaderboard_ui_entities.val.clear()
  let overlay = @system.Entity::new()
  let overlay_rect = @sprite.ColorRect::new(
    @math.Vec2D(580.0, VIEWPORT_HEIGHT),
    "rgba(0, 0, 0, 0.5)"
  )
  @sprite.sprites.set(overlay, @sprite.Sprite::from_color_rect(overlay_rect, @ui.UI_ZINDEX - 1))
  @position.positions.set(overlay, @math.Vec2D(80.0, 0.0))
  @ui.uis.set(overlay, @ui.Ui::new())
  leaderboard_ui_entities.val.push(overlay)
  let title = @system.Entity::new()
  let title_text = @sprite.Sprite::from_text(
    @sprite.Text::new("排行榜", font="60px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(title, title_text)
  @position.positions.set(title, @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 90.0, 60.0))
  @ui.uis.set(title, @ui.Ui::new())
  leaderboard_ui_entities.val.push(title)
  let entries = get_leaderboard_entries()
  if entries.length() == 0 {
    let empty_text = @system.Entity::new()
    let empty_sprite = @sprite.Sprite::from_text(
      @sprite.Text::new("暂无记录", font="30px QIJIFALLBACK", color="white"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(empty_text, empty_sprite)
    @position.positions.set(empty_text, @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 80.0, 250.0))
    @ui.uis.set(empty_text, @ui.Ui::new())
    leaderboard_ui_entities.val.push(empty_text)
  } else {
    let mut y_pos = 150.0
    for entry in entries {
      let rank_text = @system.Entity::new()
      let rank_chinese = match entry.rank {
        1 => "壹"
        2 => "贰"
        3 => "叁"
        4 => "肆"
        5 => "伍"
        6 => "陆"
        7 => "柒"
        8 => "捌"
        9 => "玖"
        10 => "拾"
        _ => "\{entry.rank}"
      }
      let formatted_score = if entry.score < 10 {
        "00\{entry.score}"
      } else if entry.score < 100 {
        "0\{entry.score}"
      } else {
        "\{entry.score}"
      }
      let content = "\{rank_chinese}丨\{formatted_score}"
      let text_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(content, font="30px QIJIFALLBACK", color="white"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(rank_text, text_sprite)
      @position.positions.set(rank_text, @math.Vec2D(300.0, y_pos))
      @ui.uis.set(rank_text, @ui.Ui::new())
      leaderboard_ui_entities.val.push(rank_text)
      y_pos = y_pos + 45.0
    }
  }
  let back_button = create_leaderboard_back_button("返回", @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40.0, 600.0))
  leaderboard_ui_entities.val.push(back_button)
  leaderboard_initialized.val = true
}

fn create_leaderboard_back_button(text: String, pos: @math.Vec2D) -> @system.Entity {
  let button = @system.Entity::new()
  let button_text = @sprite.Sprite::from_text(
    @sprite.Text::new(text, font="40px QIJIFALLBACK", color="white"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(button, button_text)
  @position.positions.set(button, pos)
  @ui.uis.set(button, @ui.Ui::new())
  let text_width = Double::from_int(text.length()) * 30.0
  let text_height = 40.0
  @collision.shapes.set(button, @collision.CollisionShape::Rect(
    size=@math.Vec2D(text_width, text_height),
    offset=@math.Vec2D(10.0, -30.0)
  ))
  button_states.set(button, {
    text: text,
    normal_color: "white",
    hover_color: "black",
    is_hovered: false
  })
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    game_state.val = GameOver
  })
  @collision.pickables.set(button, pickable)
  button
}


let loading_initialized: Ref[Bool] = Ref::new(false)
let loading_entities: Ref[Array[@system.Entity]] = Ref::new(Array::new())

pub fn loading_system(_delta: Double) -> Unit {
  if game_state.val != Loading {
    if loading_initialized.val {
      for entity in loading_entities.val {
        entity.destroy()
      }
      loading_entities.val.clear()
      loading_initialized.val = false
    }
    return
  }
  if loading_initialized.val { return }
  for entity in loading_entities.val {
    entity.destroy()
  }
  loading_entities.val.clear()
  let title = @system.Entity::new()
  let title_sprite = @sprite.Sprite::from_picture(menu_title_picture, @ui.UI_ZINDEX)
  @sprite.sprites.set(title, title_sprite)
  @position.positions.set(title, @math.Vec2D(100.0, 150.0))
  @ui.uis.set(title, @ui.Ui::new())
  loading_entities.val.push(title)
  let hint_text = @system.Entity::new()
  let hint_sprite = @sprite.Sprite::from_text(
    @sprite.Text::new("点击任意位置开始游戏", font="40px QIJIFALLBACK", color="grey"),
    @ui.UI_ZINDEX,
  )
  @sprite.sprites.set(hint_text, hint_sprite)
  @position.positions.set(hint_text, @math.Vec2D(225.0, 450.0))
  @ui.uis.set(hint_text, @ui.Ui::new())
  loading_entities.val.push(hint_text)
  let click_area = @system.Entity::new()
  @position.positions.set(click_area, @math.Vec2D(0.0, 0.0))
  @collision.shapes.set(click_area, @collision.CollisionShape::Rect(
    size=@math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT),
    offset=@math.Vec2D(0.0, 0.0)
  ))
  @ui.uis.set(click_area, @ui.Ui::new())
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_mouse_button) {
    play_menu_bgm()
    game_state.val = MainMenu
  })
  @collision.pickables.set(click_area, pickable)
  loading_entities.val.push(click_area)
  
  loading_initialized.val = true
}