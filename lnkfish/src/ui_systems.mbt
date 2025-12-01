pub fn ui_system(_delta: Double) -> Unit {
  for entity in ui_entities.val {
    entity.destroy()
  }
  ui_entities.val.clear()
  if game_state.val == GameOver {
    let overlay = @system.Entity::new()
    let overlay_rect = @sprite.ColorRect::new(
      @math.Vec2D(580.0, get_viewport_height()),
      "rgba(0, 0, 0, 0.5)"
    )
    @sprite.sprites.set(overlay, @sprite.Sprite::from_color_rect(overlay_rect, @ui.UI_ZINDEX - 1))
    @position.positions.set(overlay, @math.Vec2D(80.0, 0.0))
    @ui.uis.set(overlay, @ui.Ui::new())
    ui_entities.val.push(overlay)
    if is_endless_mode.val {
      if !score_saved_to_leaderboard.val {
        save_score_to_leaderboard(score.val)
        score_saved_to_leaderboard.val = true
      }
      let score_display_text = @system.Entity::new()
      let score_content = "\{score.val}"
      let score_text_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(score_content, font="50px QIJIFALLBACK", color="white"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(score_display_text, score_text_sprite)
      let score_estimated_width = Double::from_int(score_content.length()) * 25.0
      @position.positions.set(score_display_text, @math.Vec2D(get_viewport_width() / 2.0 - score_estimated_width / 2.0, 250.0))
      @ui.uis.set(score_display_text, @ui.Ui::new())
      ui_entities.val.push(score_display_text)
      let leaderboard_button = create_gameover_button("查看排行榜", @math.Vec2D(get_viewport_width() / 2.0 - 100.0, 330.0), true)
      ui_entities.val.push(leaderboard_button)
      let retry_button = create_gameover_button("重新开始", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 410.0), false)
      ui_entities.val.push(retry_button)
    } else {
      let score_display_text = @system.Entity::new()
      let score_content = "\{score.val}"
      let score_text_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(score_content, font="50px QIJIFALLBACK", color="white"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(score_display_text, score_text_sprite)
      let score_estimated_width = Double::from_int(score_content.length()) * 25.0
      @position.positions.set(score_display_text, @math.Vec2D(get_viewport_width() / 2.0 - score_estimated_width / 2.0, get_viewport_height() / 2.0 - 80.0))
      @ui.uis.set(score_display_text, @ui.Ui::new())
      ui_entities.val.push(score_display_text)
      let retry_text = @system.Entity::new()
      let retry_content = "按下空格以重试"
      let retry_text_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(retry_content, font="40px QIJIFALLBACK", color="white"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(retry_text, retry_text_sprite)
      let retry_estimated_width = Double::from_int(retry_content.length()) * 20.0
      @position.positions.set(retry_text, @math.Vec2D(get_viewport_width() / 2.0 - retry_estimated_width / 2.0 -50.0, get_viewport_height() / 2.0 + 20.0))
      @ui.uis.set(retry_text, @ui.Ui::new())
      ui_entities.val.push(retry_text)
      let click_area = @system.Entity::new()
      @position.positions.set(click_area, @math.Vec2D(0.0, 0.0))
      @collision.shapes.set(click_area, @collision.CollisionShape::Rect(
        size=@math.Vec2D(get_viewport_width(), get_viewport_height()),
        offset=@math.Vec2D(0.0, 0.0)
      ))
      @ui.uis.set(click_area, @ui.Ui::new())
      let pickable = @collision.Pickable::new()
      pickable.on_just_pressed(fn(_mouse_button) {
        reset_game()
      })
      @collision.pickables.set(click_area, pickable)
      ui_entities.val.push(click_area)
    }
  } else {
    let text_content = match game_state.val {
      Loading => ""
      MainMenu => ""
      LevelSelect => ""
      GameSettings => ""
      Help => ""
      Ready => ""
      GameOver => ""
      GameWon => ""
      Playing => ""
      Paused => ""
      Leaderboard => ""
    }
    if game_state.val == Ready {
      let current_level = if is_endless_mode.val {
        None
      } else {
        if current_level_index.val >= 0 && current_level_index.val < all_levels.length() {
          Some(all_levels[current_level_index.val])
        } else {
          None
        }
      }
      let level_name = match current_level {
        Some(level) => "关卡丨\{level.name}"
        None => "无穷画卷"
      }
      let level_name_text = @system.Entity::new()
      let level_name_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(level_name, font="40px QIJIFALLBACK", color="grey"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(level_name_text, level_name_sprite)
      let level_name_width = Double::from_int(level_name.length()) * 20.0
      @position.positions.set(level_name_text, @math.Vec2D(get_viewport_width() / 2.0 - level_name_width / 2.0 -30.0, get_viewport_height() / 2.0- 120.0))
      @ui.uis.set(level_name_text, @ui.Ui::new())
      ui_entities.val.push(level_name_text)
      let description = match current_level {
        Some(level) => level.description
        None => "挑战极限  ☯ 永无止境"
      }
      let description_text = @system.Entity::new()
      let description_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(description, font="30px QIJIFALLBACK", color="grey"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(description_text, description_sprite)
      let description_width = Double::from_int(description.length()) * 15.0
      @position.positions.set(description_text, @math.Vec2D(get_viewport_width() / 2.0 - description_width / 2.0- 40.0, get_viewport_height() / 2.0- 60.0))
      @ui.uis.set(description_text, @ui.Ui::new())
      ui_entities.val.push(description_text)
      let hint_text = @system.Entity::new()
      let hint_content = "按下空格以开始"
      let hint_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(hint_content, font="40px QIJIFALLBACK", color="grey"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(hint_text, hint_sprite)
      let hint_width = Double::from_int(hint_content.length()) * 20.0
      @position.positions.set(hint_text, @math.Vec2D(get_viewport_width() / 2.0 - hint_width / 2.0 - 40.0, get_viewport_height() / 2.0 + 30.0))
      @ui.uis.set(hint_text, @ui.Ui::new())
      ui_entities.val.push(hint_text)
      let click_area = @system.Entity::new()
      @position.positions.set(click_area, @math.Vec2D(0.0, 0.0))
      @collision.shapes.set(click_area, @collision.CollisionShape::Rect(
        size=@math.Vec2D(get_viewport_width(), get_viewport_height()),
        offset=@math.Vec2D(0.0, 0.0)
      ))
      @ui.uis.set(click_area, @ui.Ui::new())
      let pickable = @collision.Pickable::new()
      pickable.on_just_pressed(fn(_mouse_button) {
        play_game_bgm()
        game_state.val = Playing
      })
      @collision.pickables.set(click_area, pickable)
      ui_entities.val.push(click_area)
    } else if text_content != "" {
      let ui_text = @system.Entity::new()
      let text_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(text_content, font="40px QIJIFALLBACK", color="grey"),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(ui_text, text_sprite)
      let estimated_width = Double::from_int(text_content.length()) * 20.0
      @position.positions.set(ui_text, @math.Vec2D(get_viewport_width() / 2.0 - estimated_width / 2.0 + 20.0, get_viewport_height() / 2.0))
      @ui.uis.set(ui_text, @ui.Ui::new())
      ui_entities.val.push(ui_text)
    }
    if game_state.val == GameWon {
      if current_level_index.val >= all_levels.length() - 1 {
        let overlay = @system.Entity::new()
        let overlay_rect = @sprite.ColorRect::new(
          @math.Vec2D(580.0, get_viewport_height()),
          "rgba(0, 0, 0, 0.5)"
        )
        @sprite.sprites.set(overlay, @sprite.Sprite::from_color_rect(overlay_rect, @ui.UI_ZINDEX - 1))
        @position.positions.set(overlay, @math.Vec2D(80.0, 0.0))
        @ui.uis.set(overlay, @ui.Ui::new())
        ui_entities.val.push(overlay)
        let title_text = @system.Entity::new()
        let title_sprite = @sprite.Sprite::from_text(
          @sprite.Text::new("恭喜通关", font="50px QIJIFALLBACK", color="white"),
          @ui.UI_ZINDEX,
        )
        @sprite.sprites.set(title_text, title_sprite)
        @position.positions.set(title_text, @math.Vec2D(get_viewport_width() / 2.0 - 100.0, 250.0))
        @ui.uis.set(title_text, @ui.Ui::new())
        ui_entities.val.push(title_text)
        let endless_button = create_gamewon_button("进入无限模式", @math.Vec2D(get_viewport_width() / 2.0 - 120.0, 350.0), true)
        ui_entities.val.push(endless_button)
        let menu_button = create_gamewon_button("返回主菜单", @math.Vec2D(get_viewport_width() / 2.0 - 100.0, 450.0), false)
        ui_entities.val.push(menu_button)
      } else {
        let next_level_text = @system.Entity::new()
        let next_level_sprite = @sprite.Sprite::from_text(
          @sprite.Text::new("关卡完成丨按下空格进入下一关", font="40px QIJIFALLBACK", color="white"),
          @ui.UI_ZINDEX,
        )
        @sprite.sprites.set(next_level_text, next_level_sprite)
        @position.positions.set(next_level_text, @math.Vec2D(150.0 , get_viewport_height() / 2.0))
        @ui.uis.set(next_level_text, @ui.Ui::new())
        ui_entities.val.push(next_level_text)
        let click_area = @system.Entity::new()
        @position.positions.set(click_area, @math.Vec2D(0.0, 0.0))
        @collision.shapes.set(click_area, @collision.CollisionShape::Rect(
          size=@math.Vec2D(get_viewport_width(), get_viewport_height()),
          offset=@math.Vec2D(0.0, 0.0)
        ))
        @ui.uis.set(click_area, @ui.Ui::new())
        let pickable = @collision.Pickable::new()
        pickable.on_just_pressed(fn(_mouse_button) {
          current_level_index.val = current_level_index.val + 1
          reset_game()
        })
        @collision.pickables.set(click_area, pickable)
        ui_entities.val.push(click_area)
      }
    }
  }
  if game_state.val == Playing {
    let score_label_entity = @system.Entity::new()
    let score_label_sprite = @sprite.Sprite::from_text(
      @sprite.Text::new("得分", font="30px QIJIFALLBACK", color="grey"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(score_label_entity, score_label_sprite)
    @position.positions.set(score_label_entity, @math.Vec2D(120.0, 60.0))
    @ui.uis.set(score_label_entity, @ui.Ui::new())
    ui_entities.val.push(score_label_entity)
    let score_value_entity = @system.Entity::new()
    let formatted_score = if score.val < 10 {
      "00\{score.val}"
    } else if score.val < 100 {
      "0\{score.val}"
    } else {
      "\{score.val}"
    }
    let score_value_sprite = @sprite.Sprite::from_text(
      @sprite.Text::new(formatted_score, font="30px QIJIFALLBACK", color="grey"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(score_value_entity, score_value_sprite)
    @position.positions.set(score_value_entity, @math.Vec2D(120.0, 100.0))
    @ui.uis.set(score_value_entity, @ui.Ui::new())
    ui_entities.val.push(score_value_entity)
  }
  if game_state.val == Playing {
    let current_display_state = if is_in_flow_mode.val {
      Flowing
    } else {
      Score(flow_mode_score.val)
    }
    if last_flow_mode_display_state.val != Some(current_display_state) {
      match flow_mode_ui_entity.val {
        Some(old_entity) => {
          old_entity.destroy()
          flow_mode_ui_entity.val = None
        }
        None => ()
      }
      for border_entity in flow_mode_border_entities.val {
        border_entity.destroy()
      }
      flow_mode_border_entities.val.clear()
      let flow_ui_entity = @system.Entity::new()
      if is_in_flow_mode.val {
        let flow_sprite = @sprite.Sprite::from_animation(flowmode6s_animation, @ui.UI_ZINDEX)
        @sprite.sprites.set(flow_ui_entity, flow_sprite)
      } else {
        let flow_picture = match flow_mode_score.val {
          0 => flowmode0_picture
          1 => flowmode1_picture
          2 => flowmode2_picture
          _ => flowmode0_picture
        }
        let flow_sprite = @sprite.Sprite::from_picture(flow_picture, @ui.UI_ZINDEX)
        @sprite.sprites.set(flow_ui_entity, flow_sprite)
      }
      let flow_ui_x = get_viewport_width() / 2.0 - 98.0
      let flow_ui_y = 40.0
      @position.positions.set(flow_ui_entity, @math.Vec2D(flow_ui_x, flow_ui_y))
      @ui.uis.set(flow_ui_entity, @ui.Ui::new())
      if is_in_flow_mode.val {
        for border_entity in flow_mode_border_entities.val {
          border_entity.destroy()
        }
        flow_mode_border_entities.val.clear()
        let ui_width = 196.0
        let ui_height = 102.0
        let border_width = 3.0
        let border_color = "rgba(255, 215, 0, 0.8)"
        let top_border = @system.Entity::new()
        let top_rect = @sprite.ColorRect::new(@math.Vec2D(ui_width + border_width * 2.0, border_width), border_color)
        @sprite.sprites.set(top_border, @sprite.Sprite::from_color_rect(top_rect, @ui.UI_ZINDEX + 1))
        @position.positions.set(top_border, @math.Vec2D(flow_ui_x - border_width, flow_ui_y - border_width))
        @ui.uis.set(top_border, @ui.Ui::new())
        flow_mode_border_entities.val.push(top_border)
        let bottom_border = @system.Entity::new()
        let bottom_rect = @sprite.ColorRect::new(@math.Vec2D(ui_width + border_width * 2.0, border_width), border_color)
        @sprite.sprites.set(bottom_border, @sprite.Sprite::from_color_rect(bottom_rect, @ui.UI_ZINDEX + 1))
        @position.positions.set(bottom_border, @math.Vec2D(flow_ui_x - border_width, flow_ui_y + ui_height))
        @ui.uis.set(bottom_border, @ui.Ui::new())
        flow_mode_border_entities.val.push(bottom_border)
        let left_border = @system.Entity::new()
        let left_rect = @sprite.ColorRect::new(@math.Vec2D(border_width, ui_height), border_color)
        @sprite.sprites.set(left_border, @sprite.Sprite::from_color_rect(left_rect, @ui.UI_ZINDEX + 1))
        @position.positions.set(left_border, @math.Vec2D(flow_ui_x - border_width, flow_ui_y))
        @ui.uis.set(left_border, @ui.Ui::new())
        flow_mode_border_entities.val.push(left_border)
        let right_border = @system.Entity::new()
        let right_rect = @sprite.ColorRect::new(@math.Vec2D(border_width, ui_height), border_color)
        @sprite.sprites.set(right_border, @sprite.Sprite::from_color_rect(right_rect, @ui.UI_ZINDEX + 1))
        @position.positions.set(right_border, @math.Vec2D(flow_ui_x + ui_width, flow_ui_y))
        @ui.uis.set(right_border, @ui.Ui::new())
        flow_mode_border_entities.val.push(right_border)
      }
      flow_mode_ui_entity.val = Some(flow_ui_entity)
      last_flow_mode_display_state.val = Some(current_display_state)
    }
    let pause_button = @system.Entity::new()
    let pause_text = "停"
    let pause_text_sprite = @sprite.Sprite::from_text(
      @sprite.Text::new(pause_text, font="42px QIJIFALLBACK", color="white"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(pause_button, pause_text_sprite)
    @position.positions.set(pause_button, @math.Vec2D(get_viewport_width() - 160.0, 75.0))
    @ui.uis.set(pause_button, @ui.Ui::new())
    let pause_text_width = 30.0
    let pause_text_height = 35.0
    @collision.shapes.set(pause_button, @collision.CollisionShape::Rect(
      size=@math.Vec2D(pause_text_width, pause_text_height),
      offset=@math.Vec2D(0.0, -30.0)
    ))
    button_states.set(pause_button, {
      text: pause_text,
      normal_color: "white",
      hover_color: "black",
      is_hovered: false
    })
    let pickable = @collision.Pickable::new()
    pickable.on_just_pressed(fn(_mouse_button) {
      game_state.val = Paused
    })
    @collision.pickables.set(pause_button, pickable)
    ui_entities.val.push(pause_button)
  } else {
    match flow_mode_ui_entity.val {
      Some(old_entity) => {
        old_entity.destroy()
        flow_mode_ui_entity.val = None
      }
      None => ()
    }
    for border_entity in flow_mode_border_entities.val {
      border_entity.destroy()
    }
    flow_mode_border_entities.val.clear()
    last_flow_mode_display_state.val = None
  }
  if game_state.val == Paused {
    if paused_velocities.is_empty() {
      for entity in obstacle_entities.val {
        match @velocity.velocities.get(entity) {
          Some(vel) => {
            paused_velocities.set(entity, vel.0)
            @velocity.velocities.remove(entity)
          }
          None => ()
        }
      }
      for entity in taiji_entities.val {
        match @velocity.velocities.get(entity) {
          Some(vel) => {
            paused_velocities.set(entity, vel.0)
            @velocity.velocities.remove(entity)
          }
          None => ()
        }
      }
    }
    for entity in pause_menu_entities.val {
      entity.destroy()
    }
    pause_menu_entities.val.clear()
    let overlay = @system.Entity::new()
    let overlay_rect = @sprite.ColorRect::new(
      @math.Vec2D(580, get_viewport_height()),
      "rgba(0, 0, 0, 0.5)"
    )
    @sprite.sprites.set(overlay, @sprite.Sprite::from_color_rect(overlay_rect, @ui.UI_ZINDEX - 1))
    @position.positions.set(overlay, @math.Vec2D(80.0, 0.0))
    @ui.uis.set(overlay, @ui.Ui::new())
    pause_menu_entities.val.push(overlay)
    let pause_title = @system.Entity::new()
    let pause_title_text = @sprite.Sprite::from_text(
      @sprite.Text::new("游戏暂停", font="50px QIJIFALLBACK", color="white"),
      @ui.UI_ZINDEX,
    )
    @sprite.sprites.set(pause_title, pause_title_text)
    @position.positions.set(pause_title, @math.Vec2D(get_viewport_width() / 2.0 - 100.0, 250.0))
    @ui.uis.set(pause_title, @ui.Ui::new())
    pause_menu_entities.val.push(pause_title)
    let continue_button = create_pause_menu_button("继续游戏", @math.Vec2D(get_viewport_width() / 2.0 - 80.0, 350.0), true)
    pause_menu_entities.val.push(continue_button)
    let main_menu_button = create_pause_menu_button("返回主菜单", @math.Vec2D(get_viewport_width() / 2.0 - 100.0, 450.0), false)
    pause_menu_entities.val.push(main_menu_button)
  } else {
    if !pause_menu_entities.val.is_empty() {
      for entity in pause_menu_entities.val {
        entity.destroy()
      }
      pause_menu_entities.val.clear()
    }
    if !paused_velocities.is_empty() {
      paused_velocities.each(fn(entity, vel) {
        @velocity.velocities.set(entity, @velocity.Velocity(vel))
      })
      paused_velocities.clear()
    }
  }
}
fn create_pause_menu_button(text: String, pos: @math.Vec2D, is_continue: Bool) -> @system.Entity {
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
    if is_continue {
      game_state.val = Playing
    } else {
      reset_game_full()
      game_state.val = MainMenu
    }
  })
  @collision.pickables.set(button, pickable)
  button
}
fn create_gameover_button(text: String, pos: @math.Vec2D, is_leaderboard: Bool) -> @system.Entity {
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
    if is_leaderboard {
      game_state.val = Leaderboard
    } else {
      reset_game()
    }
  })
  @collision.pickables.set(button, pickable)
  button
}
fn create_gamewon_button(text: String, pos: @math.Vec2D, is_endless: Bool) -> @system.Entity {
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
    if is_endless {
      is_endless_mode.val = true
      current_level_index.val = 0
      last_generated_obstacle.val = None
      reset_game()
    } else {
      reset_game_full()
      game_state.val = MainMenu
    }
  })
  @collision.pickables.set(button, pickable)
  button
}
