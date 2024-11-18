extends RigidBody2D

signal landed
const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var jumped = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		linear_velocity.x = direction * SPEED
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, 5)
	state.linear_velocity = transform.y * SPEED 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
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

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Destructable"):
		body.destroy()
		$"../SFX/Hit".play()
		$"..".score += 1
		var hit_tween = create_tween()
		hit_tween.tween_property($Bat, "rotation", 0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await hit_tween.finished
		hit_tween = create_tween()
		hit_tween.tween_property($Bat, "rotation", -28.5, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
