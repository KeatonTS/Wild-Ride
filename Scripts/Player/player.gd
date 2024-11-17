extends RigidBody2D

signal landed
const SPEED = 500.0
const JUMP_VELOCITY = -400.0
var jumped = false

func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	state.linear_velocity = transform.y * SPEED
	
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		state.linear_velocity.x = direction * SPEED
	else:
		state.linear_velocity.x = move_toward(state.linear_velocity.x, 0, 5)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_jump"):
		var jump_tween = create_tween()
		jump_tween.tween_property(self, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		jumped = true
		await jump_tween.finished
		jump_tween = create_tween()
		jump_tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await jump_tween.finished
		landed.emit()

func _on_landed() -> void:
	jumped = false
