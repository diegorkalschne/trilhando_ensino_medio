extends Node2D

@onready var name_textfield = $name_textfield

# Ao clicar no botão de próximo
func _on_proximo_button_pressed():
	var name_player: String = name_textfield.text.strip_edges()
	
	if name_player.is_empty():
		return #Não faz nada
	
	GameStats.onChangeNamePlayer(name_player) # Seta o nome do jogador
	
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")
