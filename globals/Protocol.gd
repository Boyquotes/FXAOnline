extends Node
class_name Protocol

var packets = []

var _handlers = {
	Global.ServerPacketID.CharacterCreate  : "parse_character_create",
	Global.ServerPacketID.MoveCharacter    : "parse_move_character",
	Global.ServerPacketID.DestroyCharacter : "parse_destroy_character",
	Global.ServerPacketID.ChangeDirection  : "parse_change_direction",
	Global.ServerPacketID.ChatMessage      : "parse_chat_message",
	Global.ServerPacketID.ChatConsole      : "parse_chat_console",
	Global.ServerPacketID.SwitchMap        : "parse_switch_map",
	Global.ServerPacketID.Logged		   : "parse_logged",
	Global.ServerPacketID.MyCharacter	   : "parse_my_character",
	Global.ServerPacketID.RenderItem 	   : "parse_render_item",
	Global.ServerPacketID.RemoveArea	   : "parse_remove_area"
}

func _ready() -> void:
	Connection.connect("data_received", self, "_on_data_received")	

func _on_data_received(data:StreamPeerBuffer) -> void:
	_procces_data(data)
	
func _procces_data(data:StreamPeerBuffer) -> void:
	while(data.get_position() < data.get_size()):
		var packet_id = data.get_u8()
		if(_handlers.has(packet_id)):
			var method_name = _handlers.get(packet_id) 
			call(method_name, data)
		else:
			print_debug("packet con el id(%d) invalido!" % packet_id)
			Connection.disconnect_from_host()
			return

func parse_character_create(data:StreamPeerBuffer) -> void:
	var character_data = {
		"id" : data.get_32(),
		"name" : data.get_utf8_string(),
		"pos_x" : data.get_32(),
		"pos_y" : data.get_32(), 
		"helmet" : data.get_16(),
		"head" : data.get_16(),
		"body" : data.get_16(),
		"main_hand" : data.get_16(),
		"off_hand" : data.get_16() ,
		"direction" : data.get_u8(),
		"color" : data.get_32() }
	
	get_current_scene().create_character(character_data) 
	
func parse_switch_map(data:StreamPeerBuffer) -> void:
	get_current_scene().switch_map(data.get_16(), data.get_utf8_string())  
	
func parse_destroy_character(data:StreamPeerBuffer) -> void:
	get_current_scene().destroy_character(data.get_32(), data.get_u8())
 
func parse_logged(__):
	var game_scene = load("res://scenes/GameScene.tscn").instance()
	get_parent().switch_scene(game_scene)

func parse_my_character(data:StreamPeerBuffer):
	var id = data.get_32()
	get_current_scene().set_main_character(id)
	
func parse_move_character(data:StreamPeerBuffer):
	var id = data.get_32()
	var direction = data.get_u8()
	
	get_current_scene().character_move(id, direction)
	
func parse_render_item(data:StreamPeerBuffer):
	var x = data.get_16()
	var y = data.get_16()
	var grh_id = data.get_32()
	
	get_current_scene().render_item(x, y, grh_id)
	
func parse_remove_area(data:StreamPeerBuffer):
	var size = data.get_u8()
	
	for i in range(size):
		var x = data.get_16()
		var y = data.get_16()
		
		get_current_scene().destory_area(x, y)	
	
func get_current_scene():
	return get_parent().current_scene

func send_walk(direction:int) -> void:
	var packet = StreamPeerBuffer.new()
	packet.put_u8(Global.ClientPacketID.Walk)
	packet.put_u8(direction)
	
	Connection.send_data(packet)
