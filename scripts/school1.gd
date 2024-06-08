extends Node2D

@onready var change_scene_detect = $change_scene_detect
@onready var player = $player

func _ready():
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameStats.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)
	
	# Define onde ficará o "collider" que detecta que o player chegou no final da cena
	change_scene_detect.changeRigthEdgePosition(900);
