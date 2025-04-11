extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const BASE_SPEED = 50
const SPRINT_MODIFIER = 1.5

func _physics_process(delta: float) -> void:
  # Get the input direction
  var direction_x := Input.get_axis("move_left", "move_right")
  var direction_y := Input.get_axis("move_up", "move_down")
  var isSprinting := Input.is_action_pressed("sprint")

  # Reset velocity
  velocity = Vector2.ZERO
  
  var current_speed = BASE_SPEED
  if isSprinting:
    current_speed = BASE_SPEED * SPRINT_MODIFIER
  
  # Handle movement - prioritize vertical over horizontal
  if direction_y != 0:
    velocity.y = direction_y * current_speed
    if direction_y > 0:
      animated_sprite.play("walk_down")
    else:
      animated_sprite.play("walk_up")
  elif direction_x != 0:
    velocity.x = direction_x * current_speed
    animated_sprite.play("walk_across")
    animated_sprite.flip_h = direction_x < 0
  else:
    animated_sprite.play("idle_across")

  move_and_slide()
