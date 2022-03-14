extends Sprite

var hero

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]
	
func _process(_delta):
	look_at(hero.global_position)
	