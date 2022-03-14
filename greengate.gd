extends RigidBody2D

var hero

func _ready():
	add_to_group("greengate")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	$light/anim.play("flashing")

func _open():
	$light.enabled = false
	$open.play()
	$anim.play("flash")
	yield($anim, "animation_finished")
	$animation.play()
	yield($animation, "animation_finished")
	hero.controls = true
	queue_free()
	
func _button_pressed():
	_open()