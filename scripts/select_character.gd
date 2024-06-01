extends Node2D

# Quando o personagem "Boy" é selecionado
func _on_boy_button_pressed():
	GameStats.onSelectPlayer("res://sprites/boy/")
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")

# Quando o personagem "Girl" é selecionado
func _on_girl_button_pressed():
	GameStats.onSelectPlayer("res://sprites/girl/")
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")
