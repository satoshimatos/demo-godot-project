extends Area2D

signal heart_collected

var pickup = preload ("res://hptext.tscn")
var five_sec = true
var ten_sec = false
var fifteen_sec = false
export var infinite_timer = false


func _ready():
	pass

func _process(_delta):
	get_node("anim/pulsating").play("pulsating")

func _on_heart_body_entered(body):
	if body.get_name() == "character":
		var hpvalue = pickup.instance()
		var _unused = self.connect("heart_collected", get_tree().get_nodes_in_group("hp")[0], "_on_heart_heart_collected")
		emit_signal("heart_collected")
		get_parent().add_child(hpvalue)
		hpvalue.global_position = global_position
		queue_free()

func _on_Timer_timeout():
	if !infinite_timer:
		if fifteen_sec:
			queue_free()
		if ten_sec:
			$anim2.play("fade")
			ten_sec = false
			fifteen_sec = true
		if five_sec:
			five_sec = false
			ten_sec = true