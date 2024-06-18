extends Node2D

@onready var player = $player

func _ready():
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameStats.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)

# Função para voltar para a cena inicial do jogo (entrada da escola)
func _on_left_area_body_entered(body):
	GameStats.onChangeScene(0);
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn");
	GameMovement.setNextPositionPlayer(Vector2(1616, 40))

# Vai para a school1
func _on_rigth_area_body_entered(body):
	GameStats.onChangeScene(2);
	get_tree().change_scene_to_file("res://scenes/school/school2.tscn");
