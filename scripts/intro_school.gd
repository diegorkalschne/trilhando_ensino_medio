extends Node2D

@onready var player = $player

func _ready():	
	player.setTextureSprite()
	
	# Obtém o tamanho total da cena, em pixels
	var scene_width = sceneWidth()

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)
	
	# Define onde está a área de detecção de mudança de cena
	$ChangeSceneDetect.changeRigthEdgePosition(900)

# Função que retorna o tamanho total da cena, em pixels, conforme o tamanho do tile map
func sceneWidth():
	var tile_map = $background # Substitua pelo caminho correto do seu TileMap na cena
	
	var scene_size_rect = tile_map.get_used_rect().size
	
	var tile_size = tile_map.tile_set.tile_size
	
	return (scene_size_rect.x - 1) * tile_size.x
