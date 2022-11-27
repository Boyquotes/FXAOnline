extends Node2D 
class_name MapBase
 
export (Array, int) var triggers
export (Array, int) var obstacles 


func add_character(character):
	$Overlap/Entities.add_child(character)

func is_tile_passable(x, y):
	return obstacles[x + y * Global.MAP_WIDTH] == 0

func add_item(x:int, y:int, grh_id:int) -> Node2D: 
	if !Global.grh_defs.has(grh_id): return null
	if !Global.grh_defs[grh_id].has("file_num"): return null
	
	var region = Global.grh_defs[grh_id].region
	var file_id = Global.grh_defs[grh_id].file_num
	var texture = load("res://assets/legacy/graphics/%d.png" % file_id)
		
	var sprite = Sprite.new()
	sprite.texture = texture 
	sprite.region_enabled = true
	sprite.region_rect = region
	
	if region.size == Vector2(32, 32):
		sprite.position = Vector2(x * Global.TILE_SIZE, y * Global.TILE_SIZE)
		sprite.centered = false
		get_node("Item").add_child(sprite)
	else:
		sprite.position = Vector2((x * 32) + 16, (y * 32) + 32)
		sprite.offset = Vector2(0, -sprite.region_rect.size.y / 2)
		get_node("Overlap/Environment").add_child(sprite)
		
	return sprite
