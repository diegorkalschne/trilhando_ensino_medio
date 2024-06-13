extends Node2D

@onready var question = $question
@onready var options = $options
@onready var background = $background

var current_quiz

# Armazena se a resposta certa foi selecionada
# Usada para bloquear os clicks nas demais respostas, após acertar uma vez
var _correct_answer = false

func _ready():
	$music.play() # Inicia a música ao entrar na cena

# Função executada ao sair da cena.
func _exit_tree():
	$music.stop() # Para a música ao sair da cena

func initQuiz(quiz, background_path: String):
	# Seta o background da cena
	background.setTexture(background_path);
	
	current_quiz = quiz # Armazena globalmente qual o quiz atual
	question.text = quiz['question'] # Seta a questão na label
	
	for option in quiz['options']:
		# Cria um botão novo
		var button = Button.new()
		button.text = option
		
		# Função que será chamada quando clicar no botão
		var on_pressed = func():
			if (_correct_answer):
				return
			_on_pressed_answer(button, option)
		
		# Registrando o conector do botão
		button.pressed.connect(on_pressed)
		
		# Adiciona o botão na tela
		options.add_child(button)

# Função que é chamada sempre que uma das opções é pressionada
func _on_pressed_answer(button: Button, option: String):
	# Verificação se acertou a resposta
	if option == current_quiz['answer']:
		_correct_answer = true
		_on_correct_answer(button)
	else:
		_on_error_answer(button)

func _on_correct_answer(button: Button):
	_change_color_button(button, Color8(67, 160, 71, 255))
	
	button.disabled = true # Desabilita o botão ao errar
	$correct_answer.play()
	
	GameStats.addQuestionResolved(current_quiz["id"])
	
	await get_tree().create_timer(2).timeout
	
	queue_free() # Descarta a cena atual do quiz e volta para a anterior
	QuestionsGame.changeInQuizScene(false) # Marca que não está mais na cena do quiz
	

func _on_error_answer(button: Button):
	_change_color_button(button, Color(1, 0, 0))
		
	button.disabled = true # Desabilita o botão ao errar
	$incorrect_answer.play()
		

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
	
	
