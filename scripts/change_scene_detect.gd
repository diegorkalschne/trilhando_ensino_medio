extends Node2D

# Quando o player chega na direita da tela
func _on_rigth_area_body_entered(body):
	var next_scene = GameStats.current_scene + 1;
	
	# Verifica se ainda pode ir para a próxima cena
	if (next_scene <= GameStats.max_scences):
		GameStats.current_scene = next_scene;
		var scene_path = "res://scenes/school/school%d.tscn" % next_scene;
		get_tree().change_scene_to_file(scene_path);

# Quando o player chega na esquerda da tela
func _on_left_area_body_entered(body):
	var previous_scene = GameStats.current_scene - 1;
	
	# Volta cenas da escola caso seja maior que 0
	if (previous_scene > 0):
		GameStats.current_scene = previous_scene;
		var scene_path = "res://scenes/school/school%d.tscn" % previous_scene;
		get_tree().change_scene_to_file(scene_path);
	elif (previous_scene == 0):
		# Cena zero volta para a introdução da escola (parte de fora)
		GameStats.current_scene = previous_scene;
		get_tree().change_scene_to_file("res://scenes/intro_school.tscn");
	
