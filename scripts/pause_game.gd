
extends Control

# Obtém uma instância do player, onde o menu está instanciado
@onready var main = $"../../../player"

# Label de missão atual
@onready var current_mission = $margin_container/vbox_container/container/current_mission

# Fecha o jogo
func _on_close_game_button_pressed():
	get_tree().quit()

# Função para despausar o jogo através do botão de "Voltar"
func _on_voltar_button_pressed():
	main.onPauseGame()

# Função que identifica quando o menu mudou de estado entre hide/show
func _on_container_visibility_changed():
	if visible and current_mission != null:
		# Quando visível, atualiza o texto da missão atual
		current_mission.text = GameStats.getCurrentMission()
