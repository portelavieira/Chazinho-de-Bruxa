extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var last_direction: String = "down"

func _physics_process(delta: float) -> void:
	# Add gravity if needed.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction.
	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"), 
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	# Update velocity based on input.
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED

	if direction != Vector2.ZERO:
		if direction.y < 0:
			last_direction = "up"
		elif direction.y > 0:
			last_direction = "down"
		elif direction.x < 0:
			last_direction = "left"
		elif direction.x > 0:
			last_direction = "right"

		$AnimatedSprite2D.play("walk-" + last_direction)
	else:
		# Character is idle.
		$AnimatedSprite2D.play("idle-" + last_direction)

	# Move the character.
	move_and_slide()
