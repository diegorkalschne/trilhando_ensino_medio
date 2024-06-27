extends Node2D

@onready var container = $canvas/container

func _ready():
	var pontuacao_all = GameCore.getPontuacaoAllAreas()
	
	# Ordena o dicionário
	pontuacao_all = sort_dict_by_value(pontuacao_all) # Transforma em uma matriz
	pontuacao_all.reverse() # Inverte o array, para ficar de forma decrescente
	
	for area in pontuacao_all:
		# Cria um botão novo
		var button = Button.new()
		var label = Label.new()
		label.text = ''
		button.add_child(label)
		button.text = "%s: %d" % [area[0], area[1]]
	
		# Adiciona o botão na tela
		container.add_child(button)

# Função para ordenar o dicionário
func sort_dict_by_value(dict: Dictionary) -> Array:
	var arrayOfKeyValuePairs: Array = []
	for key in dict.keys():
		var keyValuePair: Array = [key, dict[key]]
		arrayOfKeyValuePairs.append(keyValuePair)
	
	arrayOfKeyValuePairs.sort_custom(_sort_by_value)

	return arrayOfKeyValuePairs

# Compara os valores do dicionário e retorna o maior
# Ordena de forma decrescente
func _sort_by_value(a, b) -> int:
	return b[1] - a[1]

# Volta para o início do jogo, já finalizado
func _on_finalizar_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
