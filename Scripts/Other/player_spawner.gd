extends Node

@onready var player_scene = preload("res://Scenes/player.tscn")

func _ready() -> void:
	if PlayerStats.is_multiplayer:
		add_player(str(multiplayer.get_unique_id()))
		if multiplayer.is_server():
			for peer in multiplayer.get_peers():
				add_player(str(peer))
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	else:
		add_player()

func add_player(_name := "Player"):
	var player = player_scene.instantiate()
	player.name = _name
	if get_children().size() == 1:
		player.global_position = get_child(0).global_position
	else:
		var spawnpoint : Marker2D = get_children().pick_random()
		player.global_position = spawnpoint.global_position
		spawnpoint.queue_free()
	
	if PlayerStats.is_multiplayer:
		player.set_multiplayer_authority(int(_name))
	get_parent().call_deferred("add_child", player)
	if get_node("../CameraLimiter") != null:
		get_node("../CameraLimiter").limit_camera()

func _on_peer_connected(id):
	add_player(str(id))

func _on_peer_disconnected(id):
	if id == 1:
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/main_menu.tscn")
	else:
		get_parent().get_node(str(id)).queue_free()
