extends Node

# Variável para armazenar as questões do quiz
var questions = []
var current_question_index = 0

var dialog_node

func _ready():
	# Carregar as perguntas do arquivo JSON ao iniciar
	questions = load_questions_from_json("res://assets/questions/questions.json")

# Função para carregar perguntas de um arquivo JSON
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

# Função para criar um diálogo para uma questão específica
func display_question():
	if current_question_index < questions.size():
		var question = questions[current_question_index]
		
		# Adiciona a Label da pergunta
		var question_label = Label.new()
		question_label.text = question["question"]
		add_child(question_label)
		
		# Adiciona os botões de alternativas
		var options = question["options"]
		for option in options:
			var option_button = Button.new()
			option_button.text = option
			option_button.pressed.connect(Callable(self._on_option_button_pressed).bind(option).bind(question['answer']))
			add_child(option_button)
		
	else:
		print("Quiz terminado!")

func _on_option_button_pressed(selected_option: String, correct_answer: String):
	if selected_option == correct_answer:
		print("Correto!")
	else:
		print("Incorreto, a resposta correta era: " + correct_answer)
	
	current_question_index += 1
	clear_scene()
	display_question()

func clear_scene():
	# Remove todos os filhos da cena
	for child in get_children():
		remove_child(child)
