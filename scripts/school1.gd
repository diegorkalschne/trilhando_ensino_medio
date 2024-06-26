extends Node2D

@onready var player = $player

func _ready():
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameCore.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)

# Função para voltar para a cena inicial do jogo (entrada da escola)
func _on_left_area_body_entered(body):
	GameCore.onChangeScene(0);
	get_tree().change_scene_to_file("res://scenes/intro_school.tscn");
	GameMovement.setNextPositionPlayer(Vector2(1616, 40))

# Vai para a school1
func _on_rigth_area_body_entered(body):
	GameCore.onChangeScene(2);
	get_tree().change_scene_to_file("res://scenes/school/school2.tscn");

# Abertura do diálogo
func _on_intro_dialogic_body_entered(body):
	GameCore.openDialogic("res://assets/characters/scene-2-1.dtl", false)
