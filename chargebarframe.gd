extends Sprite

var hero

func _process(_delta):
	hero = get_tree().get_nodes_in_group("heroes")[0]
	$chargebar.value = hero.charging * 100
	if $chargebar.value >= 100:
		$chargebar/anim.play("glow")
	else:
		$chargebar.modulate = Color(hero.charging*10, hero.charging*7, hero.charging*0)
