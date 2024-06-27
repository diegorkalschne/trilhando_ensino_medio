extends Node2D

@onready var result = $canvas/label_melhor_result

func _ready():
	var max_pontuacao_key = GameCore.getMaxPontuacao()
	
	var pontuacao_all = GameCore.getPontuacaoAllAreas()
	
	result.text = "%s, com %d pontos" % [max_pontuacao_key, pontuacao_all[max_pontuacao_key]]

# Ir para a cena de resultado totais
func _on_proximo_button_pressed():
	get_tree().change_scene_to_file("res://scenes/result_player_total.tscn")
