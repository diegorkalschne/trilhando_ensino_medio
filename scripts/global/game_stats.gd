extends Node

enum WalkState {
	FORWARD,
	BACK
}

# Caminho onde serão salvos os dados do usuário
var save_path = "user://variable.save"
# Armazena o número máximo de cenas que o jogo terá
var max_scences = 3

# Qual personagem está atualmente selecionado
var selected_player = ''

# Cena 0 é da introdução da escola
var current_scene = 0

var walk_direction_state = WalkState.FORWARD

# Armazena se possui jogo salvo ou não
var _has_game_saved = false

func _ready():
	# Ao iniciar o script, carrega os dados do usuário
	loadData()

func onSelectPlayer(player):
	selected_player = player
	saveData()
	
# Função para verificar se há ou não algum jogo salvo
func hasGameSaved():
	return _has_game_saved

# Função para salvar os dados do usuário localmente
func saveData():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	# Dicionário para salvar as variáveis como json
	var dict = {
		"selected_player": selected_player,
	}
	
	# Salva as variáveis
	file.store_var(dict)

# Função para ler os dados do usuário salvos localmente e carregar em memória
func loadData():
	# Verifica se o arquivo existe
	if FileAccess.file_exists(save_path):
		_has_game_saved = true
		var file = FileAccess.open(save_path, FileAccess.READ)
		# Resgata as variáveis salvas
		var dict = file.get_var()
		
		# Através do dicionário, resgata todas as variáveis e seta cada
		# uma individualmente
		selected_player = dict["selected_player"]
	else:
		_has_game_saved = false
