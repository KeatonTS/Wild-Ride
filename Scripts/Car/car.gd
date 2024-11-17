extends RigidBody2D

signal landed
var jumped = false
@export var speed : float = -800  # Max forward speed
@export var turn_speed : float = 4.0  # How fast the car can rotate
@export var max_speed : float = -800  # Max speed
@export var speed_step : float = 0.1  # Rate at which the car slows down when not moving
var can_turn : bool = false  # Can the car turn
var current_speed : float = 50 # Current speed of the car
var is_driving = true

func _physics_process(_delta: float) -> void:
	if $Front.is_colliding():
		linear_velocity = Vector2(0,0)
		#_auto_steer()  # Turn the car if stopped
		$Front.enabled = false
		return
	else:
		current_speed = lerp(current_speed, speed, speed_step) #Acceleration speed

	if is_driving:
		if Input.is_action_pressed("ui_right"):
			rotation += 0.05
		elif Input.is_action_pressed("ui_left"):
			rotation -= 0.05
		else:
			current_speed = lerp(current_speed, speed, speed_step) #Acceleration speed

		# Update the speed and apply it
		self.linear_velocity = transform.y * current_speed  # Move in the direction of the forward axis

		# Handle turning input when moving
		if can_turn:
			var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
			rotation += turn_input * turn_speed
	else:
		self.linear_velocity = Vector2.ZERO

# Function to handle automatic steering when the car is stopped
func _auto_steer():
	# If the car has stopped, check left and right raycasts to steer automatically
	if !$Left.is_colliding() and $Right.is_colliding():
		$Left.enabled = false
		$Right.enabled = false
		# No road on the left, so turn right
		rotation += 90  # Small turn to the right
	elif !$Right.is_colliding() and $Left.is_colliding():
		# No road on the right, so turn left
		$Left.enabled = false
		$Right.enabled = false
		rotation -= 90  # Small turn to the left
	else:
		# If both sides are clear or neither is clear, do nothing or continue idling
		pass

# Process function to handle inputs and movement every frame
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#if is_driving:
		#if Input.is_action_pressed("ui_right"):
			#rotation += 0.05
		#elif Input.is_action_pressed("ui_left"):
			#rotation -= 0.05
		#else:
			#current_speed = lerp(current_speed, speed, speed_step) #Acceleration speed
#
		## Update the speed and apply it
		#state.linear_velocity = transform.y * current_speed  # Move in the direction of the forward axis
#
		## Handle turning input when moving
		#if can_turn:
			#var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
			#rotation += turn_input * turn_speed
	#else:
		#state.linear_velocity = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drive") and is_driving:
		is_driving = false
	elif event.is_action_pressed("drive") and not is_driving:
		is_driving = true
	
	if event.is_action_pressed("car_jump"):
		var jump_tween = create_tween()
		jump_tween.tween_property($Sprite2D, "scale", Vector2(3, 3), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		jumped = true
		await jump_tween.finished
		jump_tween = create_tween()
		jump_tween.tween_property($Sprite2D, "scale", Vector2(2.5, 2.5), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await jump_tween.finished
		landed.emit()
