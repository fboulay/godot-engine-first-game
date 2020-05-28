extends CanvasLayer


signal start_game
signal change_difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1), "timeout")
	
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_fps():
	$FPSCounter.text = str(Engine.get_frames_per_second())

func set_difficulty(text: String):
	$DifficultyLabel.text = text

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

# simple function to display debug string in the HUD
func debug(text: String):
	$Debug.text = text

func _on_difficulty_pressed():
	emit_signal("change_difficulty")

func _on_Main_game_started():
	$DifficultyButton.hide()

func _on_Main_game_finished():
	$DifficultyButton.show()
