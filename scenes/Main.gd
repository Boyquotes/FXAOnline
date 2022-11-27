extends Node

const INITIAL_SCENE = preload("res://scenes/LoginScene.tscn")

var input_map = {
	"ui_left" : Global.Direction.West,
	"ui_right" : Global.Direction.East,
	"ui_up" : Global.Direction.North,
	"ui_down" : Global.Direction.South 
}

var current_scene = null

func _ready():
	randomize()
	
	switch_scene(INITIAL_SCENE.instance())

func switch_scene(node_scene) -> void:
	if(current_scene != null):
		current_scene.queue_free()
		current_scene = null
		
	current_scene = node_scene
	add_child(node_scene) 
