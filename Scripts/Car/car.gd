extends RigidBody2D

signal landed
var jumped = false
@export var speed : float = -400  # Max forward speed
@export var turn_speed : float = 4.0  # How fast the car can rotate
@export var max_speed : float = -800  # Max speed
@export var speed_step : float = 0.1  # Rate at which the car slows down when not moving
var can_turn : bool = false  # Can the car turn
var current_speed : float = 50 # Current speed of the car
var is_driving = true

# Process function to handle inputs and movement every frame
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_driving:

		if Input.is_action_pressed("ui_right"):
			rotation += 0.05
		elif Input.is_action_pressed("ui_left"):
			rotation -= 0.05
		else:
			current_speed = lerp(current_speed, speed, speed_step) #Acceleration speed

		# Update the speed and apply it
		state.linear_velocity = transform.y * current_speed  # Move in the direction of the forward axis

		# Handle turning input when moving
		if can_turn:
			var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
			rotation += turn_input * turn_speed
	else:
		state.linear_velocity = Vector2.ZERO
		current_speed = lerp(current_speed, 0.0, speed_step)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drive") and is_driving:
		is_driving = false
	elif event.is_action_pressed("drive") and not is_driving:
		is_driving = true
	
	if event.is_action_pressed("jump"):
		var jump_tween = create_tween()
		jump_tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		jumped = true
		await jump_tween.finished
		jump_tween = create_tween()
		jump_tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await jump_tween.finished
		landed.emit()
