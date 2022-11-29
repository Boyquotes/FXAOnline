extends Node

const SERVER_IP = "192.168.0.245"
const SERVER_PORT = 3030

const CREAPJ_SCENE =  preload("res://scenes/CrearPJScene.tscn") 
export(Array, PackedScene) var map_scenes 


enum State{
	None,
	Login,
	Register
}

var state = State.None 
var user_name = ""
var user_password = ""

# Called when the node enters the scene tree for the first time.
func _ready(): 
	var map = map_scenes[ randi() % map_scenes.size()].instance()
	$MapContainer.add_child(map)
	
	if OS.get_name() == "HTML5": 
		get_node("UI/FondoColor/BtnExit/Label").text = "----"
		get_node("UI/FondoColor/BtnExit").disabled = true
		
	Connection.connect("connection_established", self, "_on_connection_established")		
	Connection.connect("connection_error", self, "_on_connection_error") 
	
func _on_connection_established():
	if state == State.Register:
		get_parent().switch_scene(CREAPJ_SCENE.instance())
		return
	elif state == State.Login:
		var packet = StreamPeerBuffer.new()
		packet.put_u8(Global.ClientPacketID.Login)
		
		packet.put_utf8_string(user_name)
		packet.put_utf8_string(user_password)   
		Connection.send_data(packet)

func _exit_tree() -> void:
	pass

func _on_BtnExit_pressed():
	get_tree().quit()
 
func _on_ToggleMusic_toggled(button_pressed):
	if(button_pressed):
		$Music.play()
	else:
		$Music.stop()


func _on_BtnRegister_pressed() -> void:
	if Connection.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		Connection.disconnect_from_host()
	
	state = State.Register
	Connection.connect_to_server(SERVER_IP, SERVER_PORT)
		
 
func _on_BtnConnect_pressed() -> void:
	if Connection.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		Connection.disconnect_from_host()
	
	state = State.Login
	user_name = $UI/FondoColor/UserName.text
	user_password = $UI/FondoColor/UserPassword.text
	
	Connection.connect_to_server(SERVER_IP, SERVER_PORT)
