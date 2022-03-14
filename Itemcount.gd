extends Sprite

var global

func _ready():
	global = get_node("/root/Global")
	add_to_group("collectibles")
	_update()

func _on_collectible_item_collect():
	global.collectibles[global.stage] += 1
	_update()
	$anim.play("anim")

func _update():
	$amount.set_text(str(global.collectibles[global.stage]) + "/10")
	if global.collectibles[global.stage] >= 10:
		modulate = Color(1.2, 1, 0)
		$amount.get_font("font").size = 14