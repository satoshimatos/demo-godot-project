extends Sprite

var hero

func _ready():
	hero = get_node("../..")

func _process(delta):
	position.x = hero.position.x/20