let game_ready_initialized: Ref[Bool] = Ref::new(false)

pub fn prepare_game_system(_delta: Double) -> Unit {
  if game_state.val == Ready && !game_ready_initialized.val {
    create_fish(@math.Vec2D(250.0, 400.0))
    game_ready_initialized.val = true
  }
  if game_state.val == MainMenu {
    if game_ready_initialized.val {
      match visual_entity.val {
        Some(entity) => entity.destroy()
        None => ()
      }
      for entity in collider_entities.val {
        entity.destroy()
      }
      visual_entity.val = None
      collider_entities.val.clear()
      game_ready_initialized.val = false
    }
  }
}
pub fn handle_input(delta: Double) -> Unit {
  match game_state.val {
    Loading | MainMenu | LevelSelect | GameSettings | Help | Leaderboard => ()
    Ready => {
      if @inputs.is_just_pressed(@inputs.Code::Space) {
        play_game_bgm()
        game_state.val = Playing
      }
    }
    Playing => {
      if visual_entity.val is None { return }
      let base_rotation_speed = match current_rotation_speed_level.val {
        Slow => ROTATION_SPEED_SLOW
        Medium => ROTATION_SPEED_MEDIUM
        Fast => ROTATION_SPEED_FAST
      }
      let rotation_amount = base_rotation_speed * delta
      let left_pressed = @inputs.is_pressed(@inputs.Code::ArrowLeft) || @inputs.is_pressed(@inputs.Code::KeyA)
      let right_pressed = @inputs.is_pressed(@inputs.Code::ArrowRight) || @inputs.is_pressed(@inputs.Code::KeyD)
      let mouse_pos = @inputs.mouse.pos
      let touch_left = @inputs.is_mouse_pressed(@inputs.MouseButton::Left) && mouse_pos[X] < get_viewport_width() / 2.0
      let touch_right = @inputs.is_mouse_pressed(@inputs.MouseButton::Left) && mouse_pos[X] >= get_viewport_width() / 2.0
      if left_pressed || touch_left {
        current_rotation_speed.val = -rotation_amount
      } else if right_pressed || touch_right {
        current_rotation_speed.val = rotation_amount
      } else {
        current_rotation_speed.val = 0.0
      }
    }
    Paused => ()
    GameOver => {
      if @inputs.is_just_pressed(@inputs.Code::Space) {
        reset_game()
      }
    }
    GameWon => {
      if current_level_index.val >= all_levels.length() - 1 {
        ()
      } else {
        if @inputs.is_just_pressed(@inputs.Code::Space) {
          current_level_index.val = current_level_index.val + 1
          reset_game()
        }
      }
    }
  }
}
pub fn obstacle_system(delta: Double) -> Unit {
  if game_state.val != Playing { return }
  if is_endless_mode.val {
    obstacle_spawn_timer.val += delta
    let params = get_difficulty_params(score.val)
    let current_delay = params.delay_min + (params.delay_max - params.delay_min) * 0.5
    
    if obstacle_spawn_timer.val > current_delay {
      obstacle_spawn_timer.val = 0.0
      let spawn_info = generate_single_obstacle(
        score.val,
        obstacle_entities.val,
        last_generated_obstacle.val
      )
      
      let pos = @math.Vec2D(spawn_info.x_position, -200.0)
      let entity = match spawn_info.obstacle_type {
        Black => create_black_obstacle(pos, spawn_info.variant)
        White => create_white_obstacle(pos, spawn_info.variant)
        Red => create_red_obstacle(pos, spawn_info.variant)
      }
      
      @velocity.velocities.set(entity, @math.Vec2D(0.0, 200.0))
      obstacle_entities.val.push(entity)
      last_generated_obstacle.val = Some({
        obstacle_type: spawn_info.obstacle_type,
        x_position: spawn_info.x_position,
      })
    }
  } else {
    let current_level_data = all_levels[current_level_index.val]
    let current_level_obstacles = current_level_data.obstacle_sequence
    if level_current_index.val < current_level_obstacles.length() {
        obstacle_spawn_timer.val += delta
        let current_spawn_info = current_level_obstacles[level_current_index.val]

        if obstacle_spawn_timer.val > current_spawn_info.delay {
          obstacle_spawn_timer.val = 0.0
        
          let pos = @math.Vec2D(current_spawn_info.x_position, -200.0)
          let entity = match current_spawn_info.obstacle_type {
            Black => create_black_obstacle(pos, current_spawn_info.variant)
            White => create_white_obstacle(pos, current_spawn_info.variant)
            Red => create_red_obstacle(pos, current_spawn_info.variant)
          }
          @velocity.velocities.set(entity, @math.Vec2D(0.0, 200.0))
          obstacle_entities.val.push(entity)
          level_current_index.val += 1
        }
    } else {
        if !game_won_timer_set.val {
            game_won_timer_set.val = true
            let current_session = game_session_id.val
            @system.timeout(5.0, fn() {
                if game_session_id.val == current_session && game_state.val == Playing {
                    game_state.val = GameWon
                }
            })
        }
    }
  }
  let remaining_obstacles = Array::new()
  for entity in obstacle_entities.val {
      match @position.positions.get(entity) {
          Some(pos) => {
              if pos.0[Y] < get_viewport_height() + 100.0 {
                  remaining_obstacles.push(entity)
              } else {
                  entity.destroy()
              }
          }
          None => ()
      }
  }
  obstacle_entities.val = remaining_obstacles
}
pub fn taiji_system(delta: Double) -> Unit {
  if game_state.val != Playing { return }
  let current_level_data = all_levels[current_level_index.val]
  if is_endless_mode.val {
    if taiji_level_current_index.val >= current_level_data.taiji_sequence.length() - 2 {
      let new_batch = generate_endless_taijis(taiji_batch_size)
      for taiji_info in new_batch {
        current_level_data.taiji_sequence.push(taiji_info)
      }
    }
  }
  let current_level_taijis = current_level_data.taiji_sequence
  if taiji_level_current_index.val < current_level_taijis.length() {
      taiji_spawn_timer.val += delta
      let current_spawn_info = current_level_taijis[taiji_level_current_index.val]

      if taiji_spawn_timer.val > current_spawn_info.delay {
        taiji_spawn_timer.val = 0.0
        let pos = @math.Vec2D(current_spawn_info.x_position, -100.0)
        let entity = create_taiji(pos)
        @velocity.velocities.set(entity, @math.Vec2D(0.0, 200.0))
        taiji_entities.val.push(entity)
        taiji_level_current_index.val += 1
      }
  }
  let remaining_taijis = Array::new()
  for entity in taiji_entities.val {
      match @position.positions.get(entity) {
          Some(pos) => {
              if pos.0[Y] < get_viewport_height() + 100.0 {
                  remaining_taijis.push(entity)
              } else {
                  entity.destroy()
              }
          }
          None => ()
      }
  }
  taiji_entities.val = remaining_taijis
}
pub fn update_rotation(delta: Double) -> Unit {
  if game_state.val == Paused {
    current_rotation_speed.val = 0.0
    return
  }
  if game_state.val == Playing {
  } else {
      current_rotation_speed.val = 0.0
  }

  match visual_entity.val {
    Some(v_entity) => {
      current_angle.val = current_angle.val + current_rotation_speed.val * delta
      let sprite_center_x = 1030.0 * 0.25 / 2.0
      let sprite_center_y = 1030.0 * 0.25 / 2.0
      let translate_to_center = @math.Transform::from_translation(-sprite_center_x, -sprite_center_y)
      let rotation = @math.Transform::from_rotation_rad(current_angle.val)
      let translate_back = @math.Transform::from_translation(sprite_center_x, sprite_center_y)
      let base_scale = @math.Transform::from_scale(0.25, 0.25)
      let visual_transform = translate_back * rotation * translate_to_center * base_scale
      if current_rotation_speed.val != 0.0 {
        if current_rotation_speed.val < 0.0 {
          @sprite.play_animation(v_entity, swim_counter_animation, transform=visual_transform)
        } else {
          @sprite.play_animation(v_entity, swim_animation, transform=visual_transform)
        }
      } else {
        @sprite.play_animation(v_entity, drift_animation, transform=visual_transform)
      }
      let rotation_transform = @math.Transform::from_rotation_rad(current_angle.val)
      let visual_pos = @position.positions.get(v_entity).unwrap().0
      let sprite_center_offset = @math.Vec2D(1030.0 * 0.25 / 2.0, 1030.0 * 0.25 / 2.0)
      let rotation_center_world_pos = visual_pos + sprite_center_offset

      for c_entity in collider_entities.val {
        match (initial_offsets.get(c_entity), @collision.shapes.get(c_entity)) {
          (Some(InitialOffset(initial_offset)), Some(@collision.CollisionShape::Rect(size=collider_size, offset=_))) => {
            let (rotated_offset_x, rotated_offset_y) = rotation_transform.apply_to_point(initial_offset[X], initial_offset[Y])
            let rotated_offset = @math.Vec2D(rotated_offset_x, rotated_offset_y)
            let new_collider_center_pos = rotation_center_world_pos + rotated_offset
            let collider_half_size = @math.Vec2D(collider_size[X] / 2.0, collider_size[Y] / 2.0)
            let new_collider_top_left_pos = new_collider_center_pos - collider_half_size
            @position.positions.set(c_entity, @position.Position(new_collider_top_left_pos))
          }
          _ => ()
        }
      }
    }
    None => ()
  }
}
pub fn process_collision(_delta: Double) -> Unit {
  if game_state.val != Playing { return }
  for entity in obstacle_entities.val {
    let collisions = @collision.get_collision_infos(entity)
    if !collisions.is_empty() {
      game_state.val = GameOver
      println("Collision detected with obstacle: \{entity}!")
      play_die_sfx()
      
      if obstacles.contains(entity) {
        let obstacle = obstacles.get(entity).unwrap()
        match (obstacle.obstacle_type, obstacle.variant) {
          (Black, V1) => {
            @sprite.sprites.set(entity, @sprite.Sprite::from_picture(black_obstacle_v1_hit_picture, 10))
          }
          (Black, V2) => {
            @sprite.sprites.set(entity, @sprite.Sprite::from_picture(black_obstacle_v2_hit_picture, 10))
          }
          (White, V1) => {
            @sprite.sprites.set(entity, @sprite.Sprite::from_picture(white_obstacle_v1_hit_picture, 10))
          }
          (White, V2) => {
            @sprite.sprites.set(entity, @sprite.Sprite::from_picture(white_obstacle_v2_hit_picture, 10))
          }
          (Red, _) => {
            ()
          }
        }
      }
      for o_entity in obstacle_entities.val {
        @velocity.velocities.remove(o_entity)
      }
      for t_entity in taiji_entities.val {
        @velocity.velocities.remove(t_entity)
      }
      return
    }
  }
}
pub fn process_taiji_collision(_delta: Double) -> Unit {
  if game_state.val != Playing { return }
  let collected_taijis = Array::new()
  for taiji_entity in taiji_entities.val {
    let collisions = @collision.get_collision_infos(taiji_entity)
    if !collisions.is_empty() {
      collected_taijis.push(taiji_entity)
    }
  }
  if !collected_taijis.is_empty() {
    for entity_to_collect in collected_taijis {
      score.val += TAIJI_SCORE_VALUE
      if !is_in_flow_mode.val {
        flow_mode_score.val += 1
        if flow_mode_score.val >= FLOW_MODE_THRESHOLD {
          if flow_mode_entity.val is None {
            is_in_flow_mode.val = true
            flow_mode_score.val = 0
            let new_flow_entity = @system.Entity::new()
            flow_mode_state.set(new_flow_entity, { duration: FLOW_MODE_DURATION })
            flow_mode_entity.val = Some(new_flow_entity)
            println("Flow Mode Activated!")
          }
        }
      }
      play_coin_sfx(is_in_flow_mode.val)
      entity_to_collect.destroy()
    }
    let remaining_taijis = Array::new()
    for entity in taiji_entities.val {
      if !collected_taijis.contains(entity) {
        remaining_taijis.push(entity)
      }
    }
    taiji_entities.val = remaining_taijis
  }
}
let last_flow_mode_state: Ref[Bool] = Ref::new(false)
pub fn flow_mode_system(delta: Double) -> Unit {
  if game_state.val == Paused { return }
  if is_in_flow_mode.val {
    match flow_mode_entity.val {
      Some(entity) => {
        let flow_mode = flow_mode_state.get(entity).unwrap()
        let new_duration = flow_mode.duration - delta
        if new_duration <= 0.0 {
          is_in_flow_mode.val = false
          flow_mode_state.remove(entity)
          entity.destroy()
          flow_mode_entity.val = None
        } else {
          flow_mode_state.set(entity, { duration: new_duration })
        }
      }
      None => {
        is_in_flow_mode.val = false
      }
    }
  }
  if is_in_flow_mode.val != last_flow_mode_state.val {
    if is_in_flow_mode.val {
      println("ENTERING FLOW MODE: Updating colliders for fish and obstacles.")
      play_flow_in_sfx()
      for fish_entity in collider_entities.val {
        @collision.colliders.set(fish_entity, @collision.Collider::new(@collision.CollisionMask::new([taiji_layer, red_obstacle_layer])))
      }
      for obstacle_entity in obstacle_entities.val {
        match obstacles.get(obstacle_entity) {
          Some(obstacle) => {
            match obstacle.obstacle_type {
              Black | White => {
                @collision.colliders.set(obstacle_entity, @collision.Collider::new(@collision.CollisionMask::new([])))
              }
              Red => ()
            }
          }
          None => ()
        }
      }
    } else {
      println("EXITING FLOW MODE: Restoring colliders for fish and obstacles.")
      play_flow_out_sfx()
      for fish_entity in collider_entities.val {
        match fish_colliders.get(fish_entity) {
          Some(fish) => {
            match fish.fish_type {
              WhiteFish => {
                @collision.colliders.set(fish_entity, @collision.Collider::new(@collision.CollisionMask::new([black_obstacle_layer, taiji_layer, red_obstacle_layer])))
              }
              BlackFish => {
                @collision.colliders.set(fish_entity, @collision.Collider::new(@collision.CollisionMask::new([white_obstacle_layer, taiji_layer, red_obstacle_layer])))
              }
            }
          }
          None => ()
        }
      }
      for obstacle_entity in obstacle_entities.val {
        match obstacles.get(obstacle_entity) {
          Some(obstacle) => {
            match obstacle.obstacle_type {
              Black => {
                @collision.colliders.set(obstacle_entity, @collision.Collider::new(@collision.CollisionMask::new([white_fish_layer])))
              }
              White => {
                @collision.colliders.set(obstacle_entity, @collision.Collider::new(@collision.CollisionMask::new([black_fish_layer])))
              }
              Red => ()
            }
          }
          None => ()
        }
      }
    }
    last_flow_mode_state.val = is_in_flow_mode.val
  }
}
pub fn time_scoring_system(delta: Double) -> Unit {
  if game_state.val != Playing { return }
  time_score_accumulator.val = time_score_accumulator.val + (time_score_rate.val * delta)
  if time_score_accumulator.val >= 1.0 {
    let score_to_add = time_score_accumulator.val.to_int()
    score.val += score_to_add
    time_score_accumulator.val = time_score_accumulator.val - Double::from_int(score_to_add)
  }
}