pub fn button_hover_system(_delta: Double) -> Unit {
  let mouse_pos = @inputs.mouse.pos
  for entity, button_state in button_states {
    guard entity.is_alive() else { continue }
    guard @position.positions.get(entity) is Some(position)
    guard @collision.shapes.get(entity) is Some(shape) else { continue }
    guard shape is Rect(size=Vec2D(width, height), offset~)
    let area_box = @math.Rect::{
      size: @math.Vec2D(width, height),
      position: position.0 + offset,
    }
    let mouse_box = @math.Rect::{
      size: @math.Vec2D(1.0, 1.0),
      position: mouse_pos,
    }
    let is_hovering = mouse_box.intersects(area_box)
    let target_color = if is_hovering {
      button_state.hover_color
    } else {
      button_state.normal_color
    }
    if is_hovering != button_state.is_hovered {
      button_states.set(entity, {
        text: button_state.text,
        normal_color: button_state.normal_color,
        hover_color: button_state.hover_color,
        is_hovered: is_hovering
      })
      let font = get_button_font_size(button_state.text)
      let new_sprite = @sprite.Sprite::from_text(
        @sprite.Text::new(button_state.text, font=font, color=target_color),
        @ui.UI_ZINDEX,
      )
      @sprite.sprites.set(entity, new_sprite)
    }
  }
}