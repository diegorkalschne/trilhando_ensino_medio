extends Node2D

@onready var question = $question
@onready var options = $options
@onready var background = $background
@onready var pontuacao_ganha = $pontuacao_ganha
@onready var pontuacao = $pontuacao
@onready var label_area = $label_area

var quiz_general_id = "" # Armaneza o "id" geral do quiz (o ID "pai")
var current_quiz # Armazena o quiz atual (todas as perguntas disponíveis)

var index_current_pergunta: int = 0 # Armazena qual pergunta está sendo atualmente exibida

var _total_respostas_erradas = 0 # Armazena a quantidade de respostas erradas que o jogador teve por quiz

# Armazena se a resposta certa foi selecionada
# Usada para bloquear os clicks nas demais respostas, após acertar uma vez
var _correct_answer = false

func _ready():
	pontuacao_ganha.visible = false
	$music.play() # Inicia a música ao entrar na cena

# Função executada ao sair da cena.
func _exit_tree():
	$music.stop() # Para a música ao sair da cena

func initQuiz(quiz, quiz_id, background_path: String):
	# Seta o background da cena
	background.setTexture(background_path);
	
	current_quiz = quiz # Armazena globalmente qual o quiz atual
	quiz_general_id = quiz_id
	
	_show_questions(0) # Começa sempre na pergunta 0

func _show_questions(index: int):	
	# Caso não tenha perguntas ou todas as perguntas já foram exibidas, fecha a cena atual
	if current_quiz.size() == 0 or index >= current_quiz.size():
		queue_free() # Descarta a cena atual do quiz e volta para a anterior
		QuestionsGame.changeInQuizScene(false) # Marca que não está mais na cena do quiz
		GameStats.addQuestionResolved(quiz_general_id) # Salva que o quiz foi completado por inteiro
		return
	
	_reset_on_correct() # Reseta o quiz
	
	var _quiz = current_quiz[index]; # Obtém a pergunta atual
	
	# Seta a pontuação atual que o jogador tem na área da pergunta
	retrievePontuacaoArea()
	
	question.text = _quiz['question'] # Seta a questão na label
	
	var options_question = _quiz['options'] # Obtém as opções de resposta
	
	# Obtém qual é a resposta correta
	var correct_answer = options_question[_quiz['correct_index']]
	
	var question_id = _quiz['id']
	
	# Verifica se o player já não acertou a questão atual. Caso sim, pula para a próxima
	if (GameStats.playerHasResolvedQuestion(question_id)):
		index_current_pergunta += 1 # Incrementa o index atual da pergunta
		_show_questions(index_current_pergunta); # Chama a própria função, passando o ID novo

	options_question.shuffle() # Embaralha as opções, para sempre ser diferente
	
	for option in options_question:
		# Cria um botão novo
		var button = Button.new()
		button.text = option
		
		# Função que será chamada quando clicar no botão
		var on_pressed = func():
			if (_correct_answer):
				return
			_on_pressed_answer(button, option, correct_answer, question_id)
		
		# Registrando o conector do botão
		button.pressed.connect(on_pressed)
		
		# Adiciona o botão na tela
		options.add_child(button)
	
	# Ajusta a altura dos botões conforme o tamanho do texto
	options.adjust_size()

# Função para resetar o quiz após acertar uma resposta
func _reset_on_correct():
	_correct_answer = false
	_total_respostas_erradas = 0
	
	# Remove todos os botões de perguntas setados atualmente
	for child in options.get_children():
		if child is Button:
			options.remove_child(child)
		

# Função que é chamada sempre que uma das opções é pressionada
func _on_pressed_answer(button: Button, option: String, correct_answer: String, question_id: String):
	# Verificação se acertou a resposta
	if option == correct_answer:
		_correct_answer = true
		_on_correct_answer(button, question_id)
	else:
		_on_error_answer(button)

func _on_correct_answer(button: Button, question_id: String):
	_change_color_button(button, Color8(67, 160, 71, 255))
	
	button.disabled = true # Desabilita o botão ao errar
	$correct_answer.play()
	
	GameStats.addQuestionResolved(question_id)
	
	_show_pontos(1, false) # Jogador ganhou pontos
	
	await get_tree().create_timer(2).timeout # Delay de 2 segundos
	
	index_current_pergunta += 1 # Incrementa o index atual da pergunta
	
	_show_questions(index_current_pergunta); # Verifica se tem próxima pergunta para exibir
	

func _on_error_answer(button: Button):
	_change_color_button(button, Color(1, 0, 0))
		
	button.disabled = true # Desabilita o botão ao errar
	$incorrect_answer.play()
	
	# Jogador perdeu pontos
	var pontos_perdidos = (_total_respostas_erradas * 1 + 1) * (-1) # Vezes -1 para deixar negativo
	_show_pontos(pontos_perdidos, true)
	
	await get_tree().create_timer(2).timeout


# Exibe a pontuação que o jogador ganhou/perdeu por cada resposta
# e salva a pontuação
func _show_pontos(pontuacao: int, isError: bool):
	var signal_str = "+"
	var color = Color8(67, 160, 71, 255) #verde
	if pontuacao < 0:
		signal_str = ""
		color = Color(1, 0, 0) # vermelho
	
	$pontuacao_ganha.text = signal_str + str(pontuacao)
	$pontuacao_ganha.label_settings.font_color = color
	$pontuacao_ganha.visible = true
	_total_respostas_erradas += 1
	
	# Salva a pontuacao do jogador
	GameStats.onAddPontuacao(pontuacao, current_quiz[index_current_pergunta]["area"])
	retrievePontuacaoArea()
	
	await get_tree().create_timer(2).timeout
	
	$pontuacao_ganha.visible = false

# Atualiza a pontuação que o jogador tem na área atual
func retrievePontuacaoArea():
	var current_area = current_quiz[index_current_pergunta]["area"]
	
	var current_pontuacao = GameStats.getPontuacaoByArea(current_area)
	
	pontuacao.text = str(current_pontuacao)
	label_area.text = current_area

func _change_color_button(button: Button, color: Color):
	# Altera a cor do botão
	var style = StyleBoxFlat.new()
	style.bg_color = color
	
	# Padding do botçao
	style.content_margin_left = 5  # Padding esquerdo
	style.content_margin_top = 5   # Padding superior
	style.content_margin_right = 5 # Padding direito
	style.content_margin_bottom = 5 # Padding inferior
		
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("disabled", style)
	
	# Muda a cor da fonte para branco
	var font_color = Color(1, 1, 1)
	button.add_theme_color_override("font_color", font_color)
	
	
