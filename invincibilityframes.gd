extends Timer

var hero
var frames = 0

func _ready():
	var _unused = self.connect("timeout", get_tree().get_nodes_in_group("heroes")[0], "_nodamagetimeout")
	hero = get_node("../character/animation")

func _process(_delta):
	if !is_stopped():
		frames += 1
		if frames % 5 == 0:
			hero.visible = !hero.visible
		if frames >= 5:
			frames = 0
	else:
		hero.visible = true