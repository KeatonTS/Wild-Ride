extends Node2D

var score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.position = $Car.position
	$CanvasLayer/Time.text = str(int($Timer.time_left))
	$CanvasLayer/Mailboxes/Counter.text = str(score)


func _on_timer_timeout() -> void:
	$CanvasLayer/GameOver.visible = true
	$CanvasLayer/Time.visible = false
	$Car.is_driving = false
