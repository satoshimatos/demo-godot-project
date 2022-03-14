extends Node2D

var spawn = preload ("res://musical_notes2.tscn")
var boss

func _ready():
	boss = get_tree().get_nodes_in_group("boss")[0]
	if boss.hp <= 40:
		$Timer/Timer_faster.start()
	else:
		$Timer.start()
func _process(_delta):
	pass


func _on_Timer_timeout():
	if $note_spawner.time_left > 0:
		var note = spawn.instance()
		add_child(note)
		note.global_position = global_position

func _on_lifetime_timeout():
	queue_free()

func _on_Timer_faster_timeout():
	if $note_spawner.time_left > 0:
		var note = spawn.instance()
		add_child(note)
		note.global_position = global_position