extends Node2D
class_name Character

onready var _name = $Name

var id = -1
var grid_position_x := 0
var grid_position_y := 0
var direction = Global.Direction.North
var is_moving := false
var speed := 200
var target_position := Vector2.ZERO
var animation_direction := Vector2.DOWN

func _ready(): 
	pass
	
func _process(delta):
	update_movement(delta)

func update_movement(delta:float) -> void:
	if not is_moving: return
	
	position = position.move_toward(target_position, speed * delta)
	if position == target_position:
		is_moving = false

func set_character_name(name:String) -> void:
	_name.text = name  

func set_grid_position(x:int, y:int) -> void:
	position = Vector2(x * Global.TILE_SIZE, y * Global.TILE_SIZE)
	#position.y += Global.HALF_TILE_SIZE
	
	grid_position_x = x
	grid_position_y = y 
 
func move_to_direction(direction:int) -> void:
	var vector_direction := Vector2.ZERO
	
	match direction:
		Global.Direction.North:
			vector_direction.y -= 1
			
		Global.Direction.South:
			vector_direction.y += 1
		
		Global.Direction.West:
			vector_direction.x -= 1
			
		Global.Direction.East:
			vector_direction.x += 1
			
	if vector_direction != Vector2.ZERO:
		#FIXME
		if self.is_moving:
			self.position = self.target_position
		
		self.direction = direction
		self.grid_position_x += int(vector_direction.x)
		self.grid_position_y += int(vector_direction.y)
		
		self.target_position = position + (vector_direction * Global.TILE_SIZE)
		self.animation_direction = vector_direction
		self.is_moving = true

func change_direction(direction:int) -> void:
	var vector_direction := Vector2.ZERO
	
	match direction:
		Global.Direction.North:
			vector_direction = Vector2.UP
		Global.Direction.South:
			vector_direction = Vector2.DOWN
		Global.Direction.East:
			vector_direction = Vector2.RIGHT
		Global.Direction.West:
			vector_direction = Vector2.LEFT

	if(vector_direction != Vector2.ZERO):
		self.direction = direction
		animation_direction = vector_direction	
		
func destroy(applyEffect:bool = false):
	if applyEffect:
		_name.visible = false
		var outfit_node = get_node("Outfit")
		var tween = create_tween()
		tween.tween_property(outfit_node, "modulate:a", 0.0, 2)
		
		yield(tween, "finished")
		queue_free()
	else:
		queue_free()

func get_tile_adjacent(direction:int) -> Vector2:
	var tile_position = Vector2(grid_position_x, grid_position_y)
	
	match direction:
		Global.Direction.East:
			tile_position.x += 1
		Global.Direction.West:
			tile_position.x -= 1
		Global.Direction.North:
			tile_position.y -= 1
		Global.Direction.South:
			tile_position.y += 1
	
	return tile_position

func talk(message:String) -> void:
	pass

func set_helmet(anim_id):
	pass
	
func set_head(anim_id):
	pass
	
func set_body(anim_id):
	pass
	
func set_main_hand(anim_id):
	pass
	
func set_off_hand(anim_id):
	pass 
	
func set_character_name_color(color):
	pass
	
