extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Font) var font
export(int) var tile_size
export(int) var grid_size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(__):
	update()

func _draw(): 
	for y in range(100 / 10):
		for x in range(100 /10): 
			draw_rect(Rect2(x * tile_size * grid_size, y * tile_size * grid_size,  tile_size * grid_size, tile_size * grid_size), Color.navyblue, false, 1, true)	 
			draw_string(font, Vector2(x * tile_size * grid_size, (y * tile_size * grid_size) + 20), "[%d-%d]" % [x, y], Color.white)
