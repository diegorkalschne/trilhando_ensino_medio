extends Node2D

# Quando o personagem "Boy" é selecionado
func _on_boy_button_pressed():
	GameCore.onSelectPlayer("res://sprites/boy/")
	_change_scene()

# Quando o personagem "Girl" é selecionado
func _on_girl_button_pressed():
	GameCore.onSelectPlayer("res://sprites/girl/")
	_change_scene()

func _change_scene():
	get_tree().change_scene_to_file("res://scenes/change_name_player.tscn")
