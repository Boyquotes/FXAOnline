extends Node

const AREA_SIZE = 10
const CHARACTER_SCENE = preload("res://nodes/character/Character.tscn")

var protocol:Protocol
var player_data
var main_character:Character = null
var characters = []  
var items = []


const input_map = {
	"ui_left" : Global.Direction.West,
	"ui_right" : Global.Direction.East,
	"ui_up" : Global.Direction.North,
	"ui_down" : Global.Direction.South,
}

onready var main_camera = $MainCamera 

func _ready() -> void:
	protocol = get_parent().get_node("Protocol")
		
	
func create_character(char_data:Dictionary) -> void:
	var map = get_current_map()
	var character = CHARACTER_SCENE.instance() as Character
	
	map.add_character(character)
	characters.append(character)
	
	character.set_grid_position(char_data.pos_x, char_data.pos_y)
	character.set_character_name(char_data.name)
	character.set_character_name_color(char_data.color)
	
	character.id = char_data.id
	character.change_direction(char_data.direction)
	
	
	character.set_helmet(char_data.helmet)
	character.set_head(char_data.head)
	character.set_body(char_data.body)
	character.set_main_hand(char_data.main_hand)
	character.set_off_hand(char_data.off_hand)
	
func set_main_character(id:int) -> void:
	var character = get_character(id)
	if character:
		main_character = character
	else:
		main_character = null

func destroy_character(id, apply_effect):
	var character = get_character(id)
	if character:
		character.destroy()
		characters.erase(character)
	
func get_character(id:int) -> Character:
	for character in characters:
		if character.id == id:
			return character
	return null
	
func character_move(id:int, direction:int) -> void:
	var character = get_character(id)
	if character:
		character.move_to_direction(direction)
		 
func character_change_direction(id, direction):
	var character = get_character(id)
	if character:
		character.change_direction(direction)
	
func can_walk_to(x, y) -> bool:
	if !get_current_map():
		return false
	
	if !get_current_map().is_tile_passable(x, y):
		return false
	
	for character in characters:
		if character.grid_position_x == x and character.grid_position_y == y:
			return false
	return true

func switch_map(id:int, map_name:String) -> void:
	var map_container = get_node("CurrentMap")
	
	if map_container.get_child_count() != 0:
		map_container.get_children()[0].queue_free()
	
	var map = load("res://maps/Map%d.tscn" % id).instance()
	map_container.add_child(map)
	
func render_item(x:int, y:int, grh_id:int) -> void:
	var item_node = get_current_map().add_item(x, y, grh_id)
	if item_node != null:
		items.append(item_node)
		
func remove_item(x:int, y:int) -> void:
	get_current_map().remove_item(x, y)

func get_current_map() -> MapBase:
	if get_node("CurrentMap").get_child_count() == 0:
		return null
	return get_node("CurrentMap").get_child(0) as MapBase
	
func _process(delta: float) -> void: 
	_update_movement(delta)
	follow_player(delta)
 
	 
func _update_movement(delta:float) -> void:  
	if(!main_character): return
	for i in input_map:
		if Input.is_action_pressed(i) and !main_character.is_moving:
			var tile = main_character.get_tile_adjacent(input_map[i])
			if can_walk_to(tile.x, tile.y):
				move_to_direction(input_map[i])
				break
	
			
func follow_player(_delta: float) -> void:
	if !main_character: return 
	main_camera.position = main_character.position
	
func move_to_left():
	move_to_direction(Global.Direction.West)
	
func move_to_right():
	move_to_direction(Global.Direction.East)
	
func move_to_up():
	move_to_direction(Global.Direction.North)
	
func move_to_down():
	move_to_direction(Global.Direction.South)
	
func move_to_direction(direction:int) -> void:
	main_character.move_to_direction(direction) 
	protocol.send_walk(direction)
