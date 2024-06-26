extends Node2D

@onready var player = $player

# Variável para armazenar se algumas das Area2D está acessada no momento
var bodyAreaEntered = {
	"door_301": false,
	"door_302": false,
	"door_303": false,
	"door_304": false,
	"door_305": false,
	"door_306": false,
	"downstair": false,
}

func _ready():
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameStats.sceneWidth($background)

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
		if bodyAreaEntered["door_301"]:
			GameUtils.showSnackbar("Não disponível")
		elif bodyAreaEntered["door_302"]:
			GameUtils.showSnackbar("Não disponível")
		elif bodyAreaEntered["door_303"]:
			GameStats.openDialogic("res://assets/characters/scene-5-1.dtl")
		elif bodyAreaEntered["door_304"]:
			GameUtils.showSnackbar("Não disponível")
		elif bodyAreaEntered["door_305"]:
			if GameStats.canOpenDialogic("res://assets/characters/scene-9-1.dtl"):
				GameStats.openDialogic("res://assets/characters/scene-9-1.dtl")
			elif GameStats.canOpenDialogic("res://assets/characters/scene-9-2.dtl"):
				GameStats.openDialogic("res://assets/characters/scene-9-2.dtl")
			elif GameStats.canOpenDialogic("res://assets/characters/scene-9-3.dtl"):
				GameStats.openDialogic("res://assets/characters/scene-9-3.dtl")
			elif GameStats.canOpenDialogic("res://assets/characters/scene-9-4.dtl"):
				GameStats.openDialogic("res://assets/characters/scene-9-4.dtl")
			else:
				GameUtils.showSnackbar("Não disponível")	
		elif bodyAreaEntered["door_306"]:
			GameUtils.showSnackbar("Não disponível")
		elif bodyAreaEntered["downstair"]:
			GameMovement.setNextPositionPlayer(Vector2(833, 0))
			GameStats.onChangeScene(3)
			get_tree().change_scene_to_file("res://scenes/school/school3.tscn")
