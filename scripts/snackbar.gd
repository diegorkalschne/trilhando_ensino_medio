extends Control

class_name Snackbar

# Referências aos nodes
@onready var label = $label as Label
@onready var timer = $timer as Timer

# Função para mostrar o aviso
func show_message(message: String, position: Vector2, duration: float = 2.0):
	label.text = message
	position_label(position)
	label.visible = true
	timer.wait_time = duration
	timer.start()

func position_label(position: Vector2):
	label.position = position

# Função chamada quando o Timer termina
func _on_Timer_timeout():
	label.visible = false

# Conecta o sinal timeout do Timer à função _on_Timer_timeout
func _ready():
	timer.timeout.connect(_on_Timer_timeout)
	label.visible = false
