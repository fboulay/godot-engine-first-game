extends Node


export (PackedScene) var Mob
var score
var game_running = false
var next_mob

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Player.connect("debug", $HUD, "debug")

func _input(event):
	if !game_running && event.is_action_pressed("ui_cancel"):
	  get_tree().quit()
	
func game_over():
	game_running = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$MobAppearing.hide()
	$DeathSound.play()
	$MusicGame.stop()
	
func new_game():
	score = 0
	game_running = true
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Menu.stop()
	$MusicGame.play()

# The next mob is first shown with a hint
func _draw_mob_hint():
# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	 # Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")
	$MobAppearing.position = mob.position
	next_mob = mob

func _on_MobTimer_timeout():
	add_child(next_mob)
	_draw_mob_hint()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$MobAppearing.show()
	_draw_mob_hint()

func _on_FpsTimer_timeout():
	$HUD.update_fps()

func _on_DeathSound_finished():
	$Menu.play()
