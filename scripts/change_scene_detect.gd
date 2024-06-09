extends Node2D

@onready var _rigth_area = $rigth_area
@onready var _left_area = $left_area

# Função para alterar a posição X que a parede direita de colisão se encontra
func changeRigthEdgePosition(x):
	var current_position = _rigth_area.position
	_rigth_area.position = Vector2(x, current_position.y)

# Função para alterar a posição X que a parede esquerda de colisão se encontra
func changeLeftEdgePosition(x):
	var current_position = _left_area.position
	_left_area.position = Vector2(x, current_position.y)


# Quando o player chega na direita da tela
func _on_rigth_area_body_entered(_body):
	var next_scene = GameStats.getCurrentScene() + 1;
	
	# Verifica se ainda pode ir para a próxima cena
	if (next_scene <= GameStats.max_scences):
		GameStats.onChangeScene(next_scene);
		var scene_path = "res://scenes/school/school%d.tscn" % next_scene;
		get_tree().change_scene_to_file(scene_path);

# Quando o player chega na esquerda da tela
func _on_left_area_body_entered(_body):
	var previous_scene = GameStats.getCurrentScene() - 1;
	
	# Volta cenas da escola caso seja maior que 0
	if (previous_scene > 0):
		GameStats.onChangeScene(previous_scene);
		var scene_path = "res://scenes/school/school%d.tscn" % previous_scene;
		get_tree().change_scene_to_file(scene_path);
	elif (previous_scene == 0):
		# Cena zero volta para a introdução da escola (parte de fora)
		GameStats.onChangeScene(previous_scene);
		get_tree().change_scene_to_file("res://scenes/intro_school.tscn");
	
