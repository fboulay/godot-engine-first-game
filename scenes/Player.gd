extends Area2D

signal hit
signal debug(text)

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
	
	
	if _is_facing_right(velocity):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
	elif _is_facing_left(velocity):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = true
	elif _is_facing_up(velocity):
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
	elif _is_facing_down(velocity):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = true
		$AnimatedSprite.flip_h = false

# Returns the velocity using the keyboard input
func _compute_keyboard_input() -> Vector2: 
	var velocity = Vector2()
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
	
func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _is_facing_right(vec: Vector2) -> bool:
	if vec.x == 0 && vec.y == 0:
		return false
	return abs(vec.angle_to(Vector2(1, -1))) < PI/2 && abs(vec.angle_to(Vector2(1, 1))) < PI/2

func _is_facing_left(vec: Vector2) -> bool:
	if vec.x == 0 && vec.y == 0:
		return false
	return abs(vec.angle_to(Vector2(-1, -1))) < PI/2 && abs(vec.angle_to(Vector2(-1, 1))) < PI/2
	
func _is_facing_up(vec: Vector2) -> bool:
	if vec.x == 0 && vec.y == 0:
		return false
	return abs(vec.angle_to(Vector2(-1, -1))) < PI/2 && abs(vec.angle_to(Vector2(1, -1))) < PI/2

func _is_facing_down(vec: Vector2) -> bool:
	if vec.x == 0 && vec.y == 0:
		return false
	return abs(vec.angle_to(Vector2(1, 1))) < PI/2 && abs(vec.angle_to(Vector2(-1, 1))) < PI/2
