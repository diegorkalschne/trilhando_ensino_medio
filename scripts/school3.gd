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
	GameMusic.playMusic()
	
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameCore.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)
	
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
		if GameCore.getPlayerInDialogic():
			return
		
		if bodyAreaEntered["door_201"]:
			GameUtils.showSnackbarWithMarker("Não disponível", $marker_201)
		elif bodyAreaEntered["door_202"]:
			if GameCore.canOpenDialogic("res://assets/characters/scene-8-1.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-8-1.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-8-2.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-8-2.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-8-3.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-8-3.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-8-4.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-8-4.dtl")
			else:
				GameUtils.showSnackbarWithMarker("Não disponível", $marker_202)
		elif bodyAreaEntered["door_203"]:
			GameUtils.showSnackbarWithMarker("Não disponível", $marker_203)
		elif bodyAreaEntered["door_204"]:
			GameUtils.showSnackbarWithMarker("Não disponível", $marker_204)
		elif bodyAreaEntered["door_205"]:
			GameUtils.showSnackbarWithMarker("Não disponível", $marker_205)
		elif bodyAreaEntered["upstair"]:
			GameMovement.setNextPositionPlayer(Vector2(899, 0))
			GameCore.onChangeScene(4)
			get_tree().change_scene_to_file("res://scenes/school/school4.tscn")
		elif bodyAreaEntered["downstair"]:
			GameMovement.setNextPositionPlayer(Vector2(1116, 0))
			GameCore.onChangeScene(2)
			get_tree().change_scene_to_file("res://scenes/school/school2.tscn")
