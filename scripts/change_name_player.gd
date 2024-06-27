extends Node2D

@onready var name_textfield = $canvas/name_textfield

func _ready():
	name_textfield.grab_focus()
	name_textfield.text_changed.connect(_on_text_changed)

# Função para detectar quando é dado "enter" no campo de texto
func _on_text_changed():
	if Input.is_action_just_pressed("Enter"):
		_on_proximo_button_pressed()

# Ao clicar no botão de próximo
func _on_proximo_button_pressed():
	var name_player: String = name_textfield.text.strip_edges()
	
	if name_player.is_empty():
		return #Não faz nada
	
	GameMusic.stopMusicMenu()
	
	GameCore.onChangeNamePlayer(name_player) # Seta o nome do jogador
	
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn")
