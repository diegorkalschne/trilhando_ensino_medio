extends Node2D

func _ready():
	pass # Replace with function body.

# Quando o personagem "Boy" é selecionado
func _on_boy_button_pressed():
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")

# Quando o personagem "Boy 2" é selecionado
func _on_boy_2_button_pressed():
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")

# Quando o personagem "Girl" é selecionado
func _on_girl_button_pressed():
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")
