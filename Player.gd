extends KinematicBody

const movespeed = 4
const mousesens = .5

onready var animplayer = $AnimationPlayer
onready var raycast = $RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mousesens*event.relative.x

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
		null

func _physics_process(delta):
	var movevec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		movevec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		movevec.z += 1
	if Input.is_action_pressed("move_left"):
		movevec.x -= 1
		$Camera.rotation_degrees.z = 5
	if Input.is_action_pressed("move_right"):
		movevec.x += 1
		$Camera.rotation_degrees.z = -5
	if movevec.x == 0:
		$Camera.rotation_degrees.z =0
	movevec = movevec.normalized()
	movevec = movevec.rotated(Vector3(0,1,0),rotation.y)
	move_and_collide(movevec * movespeed * delta)
	if Input.is_action_pressed("shoot") and !animplayer.is_playing():
		animplayer.play("shoot")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()

func kill():
	get_tree().reload_current_scene()
