extends VBoxContainer

func _ready():
	$player.visible = false # Esconde o player. É utilizado apenas para setar as sprites do mesmo
	$player.disableCamera() # Desabilita a câmera do player, no menu
	$player/canvas/pause_game.can_pause_game = false # Não pode abrir o menu
	
	$carregar_jogo.grab_focus()
	
	# Caso não tenha jogo salvo, esconde o botão de "carregar jogo"
	if (!GameStats.hasGameSaved()):
		$carregar_jogo.visible = false
		$comecar.grab_focus()

# Função para ação de "Começar" o jogo
func _on_comecar_pressed():
	GameStats.resetData() # Sempre que inicia um novo jogo, reinicia todas as stats
	get_tree().change_scene_to_file("res://scenes/select_character.tscn")
	
# Função para ir para a cena de "Ajuda"
func _on_ajuda_pressed():
	get_tree().change_scene_to_file("res://scenes/ajuda.tscn")

# Função para sair do jogo
func _on_sair_pressed():
	get_tree().quit()

# Função para recomeçar o jogo, da última cena carregada
func _on_carregar_jogo_pressed():
	var current_scene = GameStats.getCurrentScene()
	
	# Define os sprites do personagem
	$player.setTextureSprite()
	
	# Volta cenas da escola caso seja maior que 0
	if (current_scene > 0):
		var scene_path = "res://scenes/school/school%d.tscn" % current_scene;
		get_tree().change_scene_to_file(scene_path);
	elif (current_scene == 0):
		# Cena zero volta para a introdução da escola (parte de fora)
		get_tree().change_scene_to_file("res://scenes/intro_school.tscn");
