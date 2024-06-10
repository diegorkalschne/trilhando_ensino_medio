extends Node2D

@onready var player = $player
@onready var label_door = $label_door
@onready var music = $music

var body_in_area_door = false

# Função executa quando a cena é instanciada
func _ready():	
	# Obtém o tamanho total da cena, em pixels
	var scene_width = GameStats.sceneWidth($background)

	# Define até onde a câmera irá se movimentar no lado direito da tela	
	player.setRigthCameraLimit(scene_width)
	
	label_door.visible = false # Esconde a label de entrar na porta
	
	music.play()

# Função executada ao sair da cena.
func _exit_tree():
	music.stop() # Para a música ao sair da cena

# Função que detecta quando algum evento aconteceu
func _input(event):
	# player pressionou "E" ao interagir com a porta da escola
	if event.is_action_pressed("interact") and body_in_area_door:
		GameStats.onChangeScene(1) # Foi para a cena 1
		GameStats.onChangeWalkDirectionState(GameStats.WalkState.FORWARD)
		get_tree().change_scene_to_file("res://scenes/school/school1.tscn")


# Função para quando o player entrar na área da porta da escola
func _on_door_school_area_body_entered(_body):
	label_door.visible = true
	body_in_area_door = true

# Função para quando o player sair na área da porta da escola
func _on_door_school_area_body_exited(_body):
	label_door.visible = false
	body_in_area_door = false
