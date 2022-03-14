extends Sprite

var hero

func _ready():
	pass
	
func _process(_delta):
	hero = get_tree().get_nodes_in_group("heroes")[0]
	$energybar.value = hero.shots*10
	if hero.shots/3 <= 0.2:
		$bar.modulate = Color(0, 0.8, 0)
	elif hero.shots/3 > 0.2 and hero.shots/3 <= 0.4:
		$bar.modulate = Color(0.4, 0.8, 0)
	elif hero.shots/3 > 0.4 and hero.shots/3 <= 0.6:
		$bar.modulate = Color(0.8, 0.8, 0)
	elif hero.shots/3 > 0.6 and hero.shots/3 <= 0.8:
		$bar.modulate = Color(0.8, 0.4, 0)
	elif hero.shots/3 > 0.8 and hero.shots/3 <= 1:
		$bar.modulate = Color(0.8, 0, 0)
		
