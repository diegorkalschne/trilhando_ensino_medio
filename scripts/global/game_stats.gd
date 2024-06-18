extends Node

enum WalkState {
	FORWARD,
	BACK
}

# Lista de questões que estão permitidas pro usuário fazer
var _whitelist_questions = []

# Lista de questões que o jogador já fez
var _questions_player_resolved = []

# Caminho onde serão salvos os dados do usuário
var save_path = "user://variable.save"
# Armazena o número máximo de cenas que o jogo terá
var max_scences = 3

# Qual personagem está atualmente selecionado
var _selected_player = ''

var _current_player_position: Vector2 = Vector2(0,0)

# Cena 0 é da introdução da escola
var _current_scene = 0

var _walk_direction_state = WalkState.FORWARD

# Armazena se possui jogo salvo ou não
var _has_game_saved = false

func _ready():
	# Ao iniciar o script, carrega os dados do usuário
	loadData()

# Método que atualiza a posição atual do player sempre que ela muda
func onChangePlayerPosition(position: Vector2):
	_current_player_position = position

# Recupera a última posição do player
func getCurrentPlayerPosition():
	return _current_player_position

# Função ao alterar o estado da direção do personagem
func onChangeWalkDirectionState(state: WalkState):
	_walk_direction_state = state
	saveData()

# Retorna o estado da direção do personagem
func getWalkDirectionState():
	return _walk_direction_state

# Função chamada quando é alterado a cena que o usuário está
func onChangeScene(scene: int):
	_current_scene = scene
	saveData()

# Retorna a cena atual que o usuário está
func getCurrentScene():
	return _current_scene

# Adiciona uma nova questão que estará disponível para o player fazer
func onAddWhitelistQuestion(question_id: String):
	# Adiciona apenas caso já não esteja na lista
	if (!_whitelist_questions.has(question_id)):
		_whitelist_questions.append(question_id)
		saveData()

# Verifica se o player pode respondeu uma questão ou não
func playerCanResponseQuestion(question_id: String):
	if _whitelist_questions.size() == 0:
		return false
	
	return _whitelist_questions[-1] == question_id

# Salva uma questão que o player já finalizou
func addQuestionResolved(question_id: String):
	# Adiciona apenas caso já não esteja na lista
	if (!_questions_player_resolved.has(question_id)):
		_questions_player_resolved.append(question_id)
		saveData()

# Função para verificar se o player já resolveu ou não uma questão
func playerHasResolvedQuestion(question_id: String):
	if (_questions_player_resolved.size() == 0):
		return false
	
	return _questions_player_resolved.has(question_id)

# Função chamada ao selecionar um novo player.
# Salva as informações do usuário
func onSelectPlayer(player: String):
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
	
	# Reseta todas as variáveis de controle
	_selected_player = ''
	_current_scene = 0
	_walk_direction_state = WalkState.FORWARD
	_whitelist_questions = []
	_questions_player_resolved = []
	_has_game_saved = false
	

# Função para salvar os dados do usuário localmente
func saveData(data=null):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	# Dicionário para salvar as variáveis como json
	var dict = {
		"selected_player": _selected_player,
		"current_scene": _current_scene,
		"walk_direction_state": int(_walk_direction_state), # Salva a enum como index
		"whitelist_questions": _whitelist_questions,
		"questions_player_resolved": _questions_player_resolved
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
		if dict.has("selected_player"):
			_selected_player = dict["selected_player"]
		if dict.has("current_scene"):
			_current_scene = dict["current_scene"]
		if dict.has("walk_direction_state"):
			_walk_direction_state = WalkState.values()[dict["walk_direction_state"]]
		if dict.has("whitelist_questions"):
			_whitelist_questions = dict["whitelist_questions"]
		if dict.has("questions_player_resolved"):
			_questions_player_resolved = dict["questions_player_resolved"]
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
