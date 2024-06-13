extends Node2D

@onready var player = $player

# Variável para armazenar se algumas das Area2D está acessada no momento
var bodyAreaEntered = {
	"door_201": false,
	"door_202": false,
	"door_203": false,
	"door_204": false,
	"door_205": false,
	"upstair": false,
	"downstair": false,
}

func _ready():
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameStats.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)
	
	# TODO: remover depois
	GameStats.onAddWhitelistQuestion(0)
	
	# Marca todas as labels como false
	for label in bodyAreaEntered:
		if has_node("label_%s" % label):
			var node = get_node("label_%s" % label)
			(node as Label).visible = false
	
	# Obtém todos os nós da cena atual
	for child in get_children():
		if child is Area2D:
			# Caso seja um objeto Area2D, adiciona os signals de body_entered e body_exited
			# Porém, o signal está configurado para chamar uma função que permite qual "area" que foi acessada
			var area = child as Area2D
			
			var onBodyEntered = func(body: Node2D):
				_on_area_entered(area)
			
			var onBodyExited = func(body: Node2D):
				_on_area_exited(area)
				
			area.body_entered.connect(onBodyEntered)
			area.body_exited.connect(onBodyExited)

# Quando uma das áreas foi acessada
func _on_area_entered(area: Area2D):
	bodyAreaEntered[area.name] = true
	if has_node("label_%s" % area.name):
		(get_node("label_%s" % area.name) as Label).visible = true;

# Quando o player saiu de uma das áreas
func _on_area_exited(area: Area2D):
	bodyAreaEntered[area.name] = false
	if has_node("label_%s" % area.name):
		(get_node("label_%s" % area.name) as Label).visible = false;

# Função que detecta quando algum evento aconteceu
func _input(event):
	# player pressionou "E" ao interagir com uma das portas
	if event.is_action_pressed("interact"):
		if bodyAreaEntered["door_201"]:
			GameMovement.setNextPositionPlayer(Vector2(-1008, 0))
		elif bodyAreaEntered["door_202"]:
			GameMovement.setNextPositionPlayer(Vector2(-741, 0))
		elif bodyAreaEntered["door_203"]:
			GameMovement.setNextPositionPlayer(Vector2(-416, 0))
		elif bodyAreaEntered["door_204"]:
			GameMovement.setNextPositionPlayer(Vector2(391, 0))
		elif bodyAreaEntered["door_205"]:
			GameMovement.setNextPositionPlayer(Vector2(700, 0))
		elif bodyAreaEntered["upstair"]:
			GameMovement.setNextPositionPlayer(Vector2(-924, 0))
			get_tree().change_scene_to_file("res://scenes/school/school4.tscn")
		elif bodyAreaEntered["downstair"]:
			GameMovement.setNextPositionPlayer(Vector2(1116, 0))
			get_tree().change_scene_to_file("res://scenes/school/school2.tscn")
