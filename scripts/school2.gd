extends Node2D

@onready var player = $player

# Variável para armazenar se algumas das Area2D está acessada no momento
var bodyAreaEntered = {
	"door_101": false,
	"door_102": false,
	"door_103": false,
	"door_104": false,
	"bathroom_boy": false,
	"bathroom_girl": false,
	"upstair": false,
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
		
		if bodyAreaEntered["door_101"]:
			if GameCore.canOpenDialogic("res://assets/characters/scene-3-1.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-3-1.dtl")
			else:
				GameUtils.showSnackbarWithMarker("Não disponível", $marker_101)
		elif bodyAreaEntered["door_102"]:
			# Cena 7
			if GameCore.canOpenDialogic("res://assets/characters/scene-7-1.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-7-1.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-7-2.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-7-2.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-7-3.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-7-3.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-7-4.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-7-4.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-7-5.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-7-5.dtl")
			# Cena 11
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-1.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-1.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-2.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-2.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-3.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-3.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-4.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-4.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-5.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-5.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-6.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-6.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-11-7.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-11-7.dtl")
			else:
				GameUtils.showSnackbarWithMarker("Não disponível", $marker_102)
		elif bodyAreaEntered["door_103"]:
			GameUtils.showSnackbarWithMarker("Não disponível", $marker_103)
		elif bodyAreaEntered["door_104"]:
			if GameCore.canOpenDialogic("res://assets/characters/scene-10-1.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-10-1.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-10-2.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-10-2.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-10-3.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-10-3.dtl")
			elif GameCore.canOpenDialogic("res://assets/characters/scene-10-4.dtl"):
				GameCore.openDialogic("res://assets/characters/scene-10-4.dtl")
			else:
				GameUtils.showSnackbarWithMarker("Não disponível", $marker_104)
		elif bodyAreaEntered["bathroom_boy"]:
			if GameCore.getSelectedPlayer().find("boy") != -1:
				goToToilet()
			else:
				GameUtils.showSnackbarWithMarker("Banheiro masculino!", $marker_bathroom_boy)
		elif bodyAreaEntered["bathroom_girl"]:
			if GameCore.getSelectedPlayer().find("girl") != -1:
				goToToilet()
			else:
				GameUtils.showSnackbarWithMarker("Banheiro feminino!", $marker_bathroom_girl)
		elif bodyAreaEntered["upstair"]:
			GameMovement.setNextPositionPlayer(Vector2(1141, 0))
			GameCore.onChangeScene(3)
			get_tree().change_scene_to_file("res://scenes/school/school3.tscn");

# Função quando irá voltar a cena
func _on_left_area_body_entered(body):
	GameCore.onChangeScene(1);
	get_tree().change_scene_to_file("res://scenes/school/school1.tscn");

# Função para ir ao "banheiro"
func goToToilet():
	var scene = load("res://scenes/toilet.tscn").instantiate()
	get_tree().root.add_child(scene)
	QuestionsGame.changeInQuizScene(true)
