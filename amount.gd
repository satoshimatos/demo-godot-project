extends Label
var item = 2
func _process(delta):
	self.set_text(str(item))
	
func _on_collectible_item_collect():
	item += item
	print(item)