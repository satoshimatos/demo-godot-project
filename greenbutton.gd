extends Area2D

var hero
var notpressed = true

signal button_pressed

func _ready():
	$light/anim.play("flash")
	var _unused = connect("button_pressed", get_tree().get_nodes_in_group("greengate")[0], "_button_pressed")
	_unused = connect("button_pressed", get_tree().get_nodes_in_group("greengate")[1], "_button_pressed")
	hero = get_tree().get_nodes_in_group("heroes")[0]

func _process(_delta):
	pass

func _on_greenbutton_body_entered(body):
	if notpressed:
		if body.is_in_group("heroes"):
			$light/anim.stop()
			$light.energy = 0
			notpressed = false
			$press.play()
			$button.play("press")
			$collision.global_position = Vector2(-1000, -1000)
			emit_signal("button_pressed")
			hero.controls = false