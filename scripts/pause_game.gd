
extends Control

@onready var container = $"."

# Label de missão atual
@onready var current_mission = $margin_container/vbox_container/container/current_mission

var game_paused: bool = false
var can_pause_game: bool = true

# Fecha o jogo
func _on_close_game_button_pressed():
	get_tree().quit()

# Função para despausar o jogo através do botão de "Voltar"
func _on_voltar_button_pressed():
	onPauseGame()

# Função que identifica quando o menu mudou de estado entre hide/show
func _on_container_visibility_changed():
	if visible and current_mission != null:
		# Quando visível, atualiza o texto da missão atual
		current_mission.text = GameStats.getCurrentMission()

# Função que detecta quando algum evento aconteceu
func _input(event):
	# Player pressionou "esc" para pausar o jogo
	if event.is_action_pressed("pause"):
		onPauseGame()

func onPauseGame():
	# Não pode pausar o jogo, não faz nada
	if !can_pause_game:
		return
	
	if game_paused:
		container.hide()
		Engine.time_scale = 1
	else:
		container.show()
		Engine.time_scale = 0
	
	game_paused = !game_paused

func resetPause():
	game_paused = false
	container.hide()

# Função para voltar ao menu principal do jogo
func _on_voltar_main_menu_button_pressed():
	game_paused = false
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
