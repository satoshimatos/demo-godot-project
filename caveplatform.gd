extends RigidBody2D

var hero

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]

func _process(_delta):
	if Input.is_action_pressed("ui_down"):
		hero.set_collision_mask_bit(14, false)
	else:
		hero.set_collision_mask_bit(14, true)