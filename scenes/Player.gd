extends Area2D

signal hit

export var speed = 400    # how fast the player will move (pixel/second)
var screen_size           # size of the game window
var is_input_pressed = false
var is_input_dragging = false
var last_input_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _input(event: InputEvent):
	# check if the input device is pressed
	if (event is InputEventMouseButton || event is InputEventScreenTouch):
		is_input_pressed = event.is_pressed()	
	# check if the input device is dragging
	is_input_dragging = (event is InputEventMouseMotion || event is InputEventScreenDrag) && is_input_pressed
	# record last pressed position when using click device
	if event is InputEventMouseMotion:
		last_input_position = get_viewport().get_mouse_position()
	if (event is InputEventScreenDrag || event is InputEventScreenTouch):
		last_input_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity =_compute_keyboard_input()
	velocity += _compute_mouse_input()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = false
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

# Returns the velocity using the keyboard input
func _compute_keyboard_input() -> Vector2: 
	var velocity: Vector2
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	return velocity

# Returns the velocity using the mouse (or touch) input
func _compute_mouse_input() -> Vector2:
	if is_input_dragging || is_input_pressed:
		# This test (x<3) is to avoid moving the player when clicking just next to his current position
		return last_input_position - position if last_input_position.distance_to(position) > 3 else Vector2()
	return Vector2()
	
func _on_Player_body_entered(body):
	hide()  # player disappear when hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# simple function to display debug string in the HUD
func debug(text: String):
	get_node("/root/Main/HUD/Debug").text = text
