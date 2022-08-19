extends KinematicBody


onready var head = $Head
onready var desc_label = $Control/Description
onready var space_label = $Control/SpaceReady
var mouse_sens = 0.03
var speed = 10
var h_acc = 6

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()

var mouse_mode = true



var book = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	elif event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel") and mouse_mode:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_mode = false
		elif Input.is_action_just_pressed("ui_cancel") and not mouse_mode:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_mode = true
		elif Input.is_action_just_pressed("ui_accept") and book:
			OS.shell_open(book.bookurl)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z	
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x	
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acc * delta)
	movement.z = h_velocity.z
	movement.x = h_velocity.x
	movement = move_and_slide(movement, Vector3.UP)
	
	if book:
		desc_label.text = book.book_name
		space_label.visible = true
	else:
		space_label.visible = false
		desc_label.text = ""


func _on_Area_body_entered(body):
	if body.get_meta("type") == "book":
		book = body


func _on_Area_body_exited(body):
	if body.get_meta("type") == "book":
		book = null
