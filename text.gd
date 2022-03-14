extends Label

var hp

func _ready():
	pass

func _on_heart_heart_collected():
	hp = get_tree().get_nodes_in_group("hp")[0].count
	text = (str(hp))