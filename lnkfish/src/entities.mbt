// 创建双鱼实体
// 包含一个视觉实体和两个碰撞体(黑白各一)
pub fn create_fish(center: @math.Vec2D) -> Unit {
  // 创建视觉实体(显示的双鱼图像)
  let entity = @system.Entity::new()
  @sprite.sprites.set(entity, @sprite.Sprite::from_animation(drift_animation, 10))
  @position.positions.set(entity, center)
  visual_entity.val = Some(entity)
  
  // 创建白鱼碰撞体(位于左上方,与黑色障碍物碰撞)
  let white_fish_collider = @system.Entity::new()
  @position.positions.set(white_fish_collider, center)
  @collision.shapes.set(white_fish_collider, @collision.CollisionShape::Rect(size=@math.Vec2D(67.5, 67.5), offset=@math.Vec2D(0.0, 0.0)))
  initial_offsets.set(white_fish_collider, InitialOffset(@math.Vec2D(-77.5, -77.5)))
  @collision.collision_layers.set(white_fish_collider, white_fish_layer)
  @collision.colliders.set(white_fish_collider, @collision.Collider::new(@collision.CollisionMask::new([black_obstacle_layer, taiji_layer, red_obstacle_layer])))
  fish_colliders.set(white_fish_collider, { fish_type: WhiteFish })
  collider_entities.val.push(white_fish_collider)
  
  // 创建黑鱼碰撞体(位于右下方,与白色障碍物碰撞)
  let black_fish_collider = @system.Entity::new()
  @position.positions.set(black_fish_collider, center)
  @collision.shapes.set(black_fish_collider, @collision.CollisionShape::Rect(size=@math.Vec2D(67.5, 67.5), offset=@math.Vec2D(0.0, 0.0)))
  initial_offsets.set(black_fish_collider, InitialOffset(@math.Vec2D(77.5, 77.5)))
  @collision.collision_layers.set(black_fish_collider, black_fish_layer)
  @collision.colliders.set(black_fish_collider, @collision.Collider::new(@collision.CollisionMask::new([white_obstacle_layer, taiji_layer, red_obstacle_layer])))
  fish_colliders.set(black_fish_collider, { fish_type: BlackFish })
  collider_entities.val.push(black_fish_collider)
}

// 创建黑色障碍物
// @param pos 初始位置
// @param variant 障碍物变体(V1或V2,对应不同形状)
// @return 创建的障碍物实体
pub fn create_black_obstacle(pos: @math.Vec2D, variant: ObstacleVariant) -> @system.Entity {
  let entity = @system.Entity::new()
  // 根据变体选择图片和碰撞体参数
  let (picture, collider_size, collider_offset) = match variant {
    V1 => (black_obstacle_v1_picture, @math.Vec2D(195.0, 40.0), @math.Vec2D(22.5, 25.0))
    V2 => (black_obstacle_v2_picture, @math.Vec2D(45.0, 270.0), @math.Vec2D(50, 27.5))
  }
  @sprite.sprites.set(entity, @sprite.Sprite::from_picture(picture, 5))
  @position.positions.set(entity, pos)
  @collision.shapes.set(entity, @collision.CollisionShape::Rect(size=collider_size, offset=collider_offset))
  @collision.collision_layers.set(entity, black_obstacle_layer)
  // 心流模式时不与任何鱼碰撞,否则只与白鱼碰撞
  let mask = if is_in_flow_mode.val {
    @collision.CollisionMask::new([])
  } else {
    @collision.CollisionMask::new([white_fish_layer])
  }
  @collision.colliders.set(entity, @collision.Collider::new(mask))
  obstacles.set(entity, { obstacle_type: Black, variant: variant })
  entity
}

// 创建白色障碍物
// @param pos 初始位置
// @param variant 障碍物变体(V1或V2,对应不同形状)
// @return 创建的障碍物实体
pub fn create_white_obstacle(pos: @math.Vec2D, variant: ObstacleVariant) -> @system.Entity {
  let entity = @system.Entity::new()
  let (picture, collider_size, collider_offset) = match variant {
    V1 => (white_obstacle_v1_picture, @math.Vec2D(85.0, 90.0), @math.Vec2D(37.5, 35.0))
    V2 => (white_obstacle_v2_picture, @math.Vec2D(140.0, 115.0), @math.Vec2D(50.0, 40.0))
  }
  @sprite.sprites.set(entity, @sprite.Sprite::from_picture(picture, 5))
  @position.positions.set(entity, pos)
  @collision.shapes.set(entity, @collision.CollisionShape::Rect(size=collider_size, offset=collider_offset))
  @collision.collision_layers.set(entity, white_obstacle_layer)
  // 心流模式时不与任何鱼碰撞,否则只与黑鱼碰撞
  let mask = if is_in_flow_mode.val {
    @collision.CollisionMask::new([])
  } else {
    @collision.CollisionMask::new([black_fish_layer])
  }
  @collision.colliders.set(entity, @collision.Collider::new(mask))
  obstacles.set(entity, { obstacle_type: White, variant: variant })
  entity
}

// 创建红色障碍物
// 红色障碍物与黑白双鱼都会碰撞
// @param pos 初始位置
// @param variant 障碍物变体(V1或V2,对应不同形状)
// @return 创建的障碍物实体
pub fn create_red_obstacle(pos: @math.Vec2D, variant: ObstacleVariant) -> @system.Entity {
  let entity = @system.Entity::new()
  let picture = match variant {
    V1 => red_obstacle_v1_picture
    V2 => red_obstacle_v2_picture
  }
  @sprite.sprites.set(entity, @sprite.Sprite::from_picture(picture, 5))
  @position.positions.set(entity, pos)
  @collision.shapes.set(entity, @collision.CollisionShape::Rect(size=@math.Vec2D(80.0, 80.0), offset=@math.Vec2D(1.5, 1.5)))
  @collision.collision_layers.set(entity, red_obstacle_layer)
  @collision.colliders.set(entity, @collision.Collider::new(@collision.CollisionMask::new([black_fish_layer, white_fish_layer])))
  obstacles.set(entity, { obstacle_type: Red, variant: variant })
  entity
}

// 创建太极符
// 收集太极符可获得分数,收集3个触发心流模式
// @param pos 初始位置
// @return 创建的太极符实体
pub fn create_taiji(pos: @math.Vec2D) -> @system.Entity {
  let entity = @system.Entity::new()
  @sprite.sprites.set(entity, @sprite.Sprite::from_animation(taiji_animation, 11))
  @position.positions.set(entity, pos)
  @collision.shapes.set(entity, @collision.CollisionShape::Rect(size=@math.Vec2D(50.0, 50.0), offset=@math.Vec2D(0.0, 0.0)))
  @collision.collision_layers.set(entity, taiji_layer)
  @collision.colliders.set(entity, @collision.Collider::new(@collision.CollisionMask::new([white_fish_layer, black_fish_layer])))
  taijis.set(entity, { is_taiji: true })
  entity
}

// 添加背景图
// @param size 背景尺寸
pub fn add_background(size : @math.Vec2D) -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::from_picture(
    @sprite.Picture::new(size, "assets/bg.png", repeat=Repeat),
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D(0.0, 0.0))
}