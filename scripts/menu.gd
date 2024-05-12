extends VBoxContainer

func _ready():
	$Comecar.grab_focus()

#Função para ação de "Começar" o jogo
func _on_comecar_pressed():
	get_tree().change_scene_to_file("res://scenes/select_character.tscn")
	
#Função para ir para a cena de "Ajuda"
func _on_ajuda_pressed():
	get_tree().change_scene_to_file("res://scenes/ajuda.tscn")

#Função para sair do jogo
func _on_sair_pressed():
	get_tree().quit()
