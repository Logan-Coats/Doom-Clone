extends KinematicBody

const movespeed = 3

onready var raycast = $RayCast
onready var animplayer = $AnimationPlayer

var player = null
var dead = false

func _ready():
	animplayer.play("walk")
	add_to_group("zombies")

func _physics_process(delta):
	if dead :
		return
	if player ==  null:
		return
	var vectoplayer = player.translation - translation
	vectoplayer = vectoplayer.normalized()
	raycast.cast_to = vectoplayer*1.5
	
	move_and_collide(vectoplayer*movespeed*delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()

func kill():
	dead = true
	$CollisionShape.disabled = true
	animplayer.play("die")

func set_player(p):
	player = p
