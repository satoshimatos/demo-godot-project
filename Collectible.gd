extends Node2D

signal item_collect
var pickup = preload("res://item_pickup.tscn")
var hero

func _ready():
	pass
	
func _on_itemphysics_body_entered(body):
	if body.get_name() == "character":
		hero = get_tree().get_nodes_in_group("heroes")[0]
		var pickup_particles = pickup.instance()
		get_parent().add_child(pickup_particles)
		pickup_particles.global_position = global_position
		var _unused = self.connect("item_collect", get_tree().get_nodes_in_group("collectibles")[0], "_on_collectible_item_collect")
		emit_signal("item_collect")
		queue_free()