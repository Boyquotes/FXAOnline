extends Node

var user_class := 0
var user_race := 0
var user_gender := 0

var LOGIN_Ls = load("res://scenes/LoginScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_class_info()
	update_race_info()
	
	Connection.connect("connection_closed", self, "_back_to_login")
	
func _back_to_login():
	get_parent().switch_scene(LOGIN_Ls.instance()) 

func on_selected_class(index:int) ->void:
	user_class = clamp(user_class + index, 0, Global.Classes.size() - 1)
	update_class_info()

func on_selected_race(index:int) ->void:
	user_race = clamp(user_race + index, 0, Global.Races.size() - 1)
	update_race_info()
	
func on_selected_gender(index:int) ->void:
	user_gender = clamp(user_gender + index, 0, 1)
	$UI/LeftPanel/UserGender/Info/Text.text = "Hombre" if user_gender == 0 else "Mujer"
	
func update_class_info():
	var name_class = (Global.Classes.keys()[user_class]).to_lower()  
	var icon_path = "res://assets/textures/ui/class_icons/%s.jpg" % name_class
	var texture = load(icon_path) 
	
	$UI/LeftPanel/ClassIcon.texture = texture
	$UI/LeftPanel/UserClass/Info/Text.text = Global.NameClasses[user_class]

func update_race_info():
	$UI/LeftPanel/UserRace/Info/Text.text = Global.NameRaces[user_race]


func _on_BtnCancel_pressed() -> void:
	Connection.disconnect_from_host()
 
func _on_BtnOK_pressed() -> void:
	send_data_to_server()
	
	
func send_data_to_server():
	var packet = StreamPeerBuffer.new()
	packet.put_u8(Global.ClientPacketID.Register)
	
	packet.put_utf8_string($UI/RightPanel/UserName.text)
	packet.put_utf8_string($UI/RightPanel/UserPassword0.text)
	packet.put_utf8_string($UI/RightPanel/UserEmail.text)
	
	packet.put_u8(user_race)
	packet.put_u8(user_class)
	packet.put_u8(user_gender)

	Connection.send_data(packet)
