extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 5.0
@export var run_multiplier: float = 2.0

var yaw: float = 0.0   # Left/right
var pitch: float = 0.0 # Up/down

@export var pivot: Node3D
@export var cam: Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89)) # prevent flipping

		rotation.y = yaw
		pivot.rotation.x = pitch

	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		# Release the mouse when pressing ESC
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += transform.basis.x

	input_dir = input_dir.normalized()

	var speed = move_speed
	if Input.is_action_pressed("run"):
		speed *= run_multiplier

	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed

	# Apply gravity if you want physics
	if not is_on_floor():
		pass
		#velocity.y -= 9.8 * delta
	else:
		velocity.y = 0.0

	move_and_slide()
