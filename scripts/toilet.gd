extends Node2D

@onready var music = $canvas/audio

func _ready():
	music.play()
	
	await get_tree().create_timer(3).timeout # Delay de 3 segundos
	
	# Remove a cena
	queue_free() # Descarta a cena atual do quiz e volta para a anterior
	QuestionsGame.changeInQuizScene(false) # Marca que não está mais na cena do quiz


