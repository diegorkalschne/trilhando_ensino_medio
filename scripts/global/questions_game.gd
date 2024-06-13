extends Node

# Questões disponíveis
var _questions = []

# Armazena se o player está vendo a cena de quiz ou não
var _in_quiz_scene = false

# Função para mudar o estado se o player está na cena de quiz ou não
func changeInQuizScene(value: bool):
	_in_quiz_scene = value

func getInQuizScene():
	return _in_quiz_scene

func _ready():
	# Iniciliza o script carregando as questões do arquivo json
	_questions = load_questions_from_json("res://assets/questions/questions.json")

# Lê um arquivo .json e retorna o conteúdo
func load_questions_from_json(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var conteudo_arquivo = data_file.get_as_text()
		data_file.close()
		
		var parsedResult = JSON.parse_string(conteudo_arquivo)
		return parsedResult
	else:
		print("O arquivo não existe")
		return []

# Função para verificar se o usuário está apto para responder ou não uma questão no momento
func _can_go_to_question(question_id: int):
	# Verifica se o player já não resolveu a questão. Continua apenas enquanto não resolveu
	if (!GameStats.playerHasResolvedQuestion(question_id)):
		# Verifica se o player está apto a responder a questão
		if (GameStats.playerCanResponseQuestion(question_id)):
			return true # Player está apto a responder a questão
	
	return false # Player não está apto a responder a questão

# Função para mudar para a cena de quiz
func changeSceneQuiz(question_id: int, background_path: String):
	# Verificação para ver se o usuário pode responder a questão selecionada
	if !_can_go_to_question(question_id):
		return
	
	var scene = load("res://scenes/quiz.tscn").instantiate()
	get_tree().root.add_child(scene)
	#get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
	changeInQuizScene(true) # Marca que está na cena do quiz
	
	if scene.has_method("initQuiz"):
		scene.call("initQuiz", _questions[question_id], background_path)
