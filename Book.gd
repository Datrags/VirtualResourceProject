extends StaticBody


export(String) var bookurl = "https://www.amazon.com/ref=nav_logo"


# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.shell_open(bookurl)
	set_meta("type","book")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
	#	print(bookurl)
	pass
