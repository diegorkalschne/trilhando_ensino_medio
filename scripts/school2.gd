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
		if bodyAreaEntered["door_101"]:
			GameStats.openDialogic("res://assets/characters/scene-3-1.dtl")
			#if (QuestionsGame.canGoQuestion("2")):
				#QuestionsGame.changeInQuizScene(true)
				#Dialogic.start("res://assets/timelines/timeline1.dtl")
		elif bodyAreaEntered["door_102"]:
			GameStats.openDialogic("res://assets/characters/scene-7-1.dtl")
		elif bodyAreaEntered["door_103"]:
			GameMovement.setNextPositionPlayer(Vector2(816, 0))
		elif bodyAreaEntered["door_104"]:
			GameMovement.setNextPositionPlayer(Vector2(1400, 0))
		elif bodyAreaEntered["bathroom_boy"]:
			GameMovement.setNextPositionPlayer(Vector2(1641, 0))
		elif bodyAreaEntered["bathroom_girl"]:
			GameMovement.setNextPositionPlayer(Vector2(1790, 0))
		elif bodyAreaEntered["upstair"]:
			GameMovement.setNextPositionPlayer(Vector2(1141, 0))
			GameStats.onChangeScene(3)
			get_tree().change_scene_to_file("res://scenes/school/school3.tscn");

# Função quando irá voltar a cena
func _on_left_area_body_entered(body):
	GameStats.onChangeScene(1);
	get_tree().change_scene_to_file("res://scenes/school/school1.tscn");
