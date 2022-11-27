extends Node

signal connection_established
signal connection_closed
signal connection_error
signal data_received(data)

var _client := WebSocketClient.new()
var _is_connected := false

func _ready() -> void:
	_client.connect("connection_closed", self, "_on_closed")
	_client.connect("connection_error", self, "_on_connection_error")
	_client.connect("connection_established", self, "_on_connected")
	_client.connect("data_received", self, "_on_data")

func connect_to_server(ip:String, port:int) -> int:
	var websocket_url := "ws://%s:%d" % [ip, port] 
	var err_code = _client.connect_to_url(websocket_url)
	
	if(err_code != OK):
		set_process(false) 
	else:
		set_process(true) 
	
	return err_code
	
func send_data(data:StreamPeerBuffer):
	if(not _is_connected): return
	_client.get_peer(1).put_packet(data.data_array)
	
func _process(_delta: float) -> void:
	_client.poll()

func get_connection_status() -> int:
	return _client.get_connection_status()

func _on_connected(protocol:String)->void:
	_is_connected = true
	emit_signal("connection_established")
	
func _on_connection_error() ->void:
	_is_connected = false
	emit_signal("connection_error")

func _on_closed(was_clean:bool): 
	_is_connected = false
	emit_signal("connection_closed")

func disconnect_from_host():
	if get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED or get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED :
		_client.disconnect_from_host()
	
func _on_data():
	var packet := _client.get_peer(1).get_packet()
	var data := StreamPeerBuffer.new()
	
	data.data_array = packet
	emit_signal("data_received", data)  
