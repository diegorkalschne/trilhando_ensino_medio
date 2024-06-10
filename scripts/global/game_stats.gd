extends Node

enum WalkState {
	FORWARD,
	BACK
}

# Lista de questões que estão pe
var _whitelist_questions = []

# Caminho onde serão salvos os dados do usuário
var save_path = "user://variable.save"
# Armazena o número máximo de cenas que o jogo terá
var max_scences = 3

# Qual personagem está atualmente selecionado
var _selected_player = ''

# Cena 0 é da introdução da escola
var _current_scene = 0

var _walk_direction_state = WalkState.FORWARD

# Armazena se possui jogo salvo ou não
var _has_game_saved = false

func _ready():
	# Ao iniciar o script, carrega os dados do usuário
	loadData()

# Função ao alterar o estado da direção do personagem
func onChangeWalkDirectionState(state):
	_walk_direction_state = state
	saveData()

# Retorna o estado da direção do personagem
func getWalkDirectionState():
	return _walk_direction_state

# Função chamada quando é alterado a cena que o usuário está
func onChangeScene(scene):
	_current_scene = scene
	saveData()

# Retorna a cena atual que o usuário está
func getCurrentScene():
	return _current_scene

# Função chamada ao selecionar um novo player.
# Salva as informações do usuário
func onSelectPlayer(player):
	_selected_player = player
	saveData()

# Retorna o player atualmente selecionado
func getSelectedPlayer():
	return _selected_player
	
# Função para verificar se há ou não algum jogo salvo
func hasGameSaved():
	return _has_game_saved

# Função para resetar o jogo do usuário. Chamado sempre que um novo jogo é iniciado
func resetData():
	saveData({}) # Salva um dicionário vazio

# Função para salvar os dados do usuário localmente
func saveData(data=null):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	# Dicionário para salvar as variáveis como json
	var dict = {
		"selected_player": _selected_player,
		"current_scene": _current_scene,
		"walk_direction_state": int(_walk_direction_state), # Salva a enum como index
	}
	
	if (data != null):
		dict = data
	
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
		
		# Caso o dicionário estiver vazio, é o mesmo que não ter dados salvos
		if (dict == null || dict.size() == 0):
			_has_game_saved = false
			return
		
		# Através do dicionário, resgata todas as variáveis e seta cada
		# uma individualmente
		if (dict.has("selected_player")):
			_selected_player = dict["selected_player"]
		if (dict.has("current_scene")):
			_current_scene = dict["current_scene"]
		if (dict.has("walk_direction_state")):
			_walk_direction_state = WalkState.values()[dict["walk_direction_state"]]
	else:
		_has_game_saved = false

# Função que retorna o tamanho total da cena, em pixels, conforme o tamanho do tile map
func sceneWidth(tile_map):
	var scene_size_rect = tile_map.get_used_rect().size
	
	var tile_size = tile_map.tile_set.tile_size
	
	return (scene_size_rect.x - 1) * tile_size.x

func sceneHeigth(tile_map):
	var scene_size_rect = tile_map.get_used_rect().size
	
	var tile_size = tile_map.tile_set.tile_size
	
	return (scene_size_rect.y - 1) * tile_size.y
