extends TextureProgress

var hero

func _ready():
	pass
	
func _process(_delta):
	hero = get_tree().get_nodes_in_group("heroes")[0]	
	if hero.shots > 2:
		value = 0
	elif hero.shots > 1 and hero.shots <= 2:
		value = 1
	elif hero.shots > 0 and hero.shots <= 1:
		value = 2
	else:
		value = 3