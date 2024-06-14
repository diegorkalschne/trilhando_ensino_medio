extends CharacterBody2D

@onready var sprites = $sprites as AnimatedSprite2D
@onready var collision = $collision as CollisionShape2D
@onready var camera = $camera as Camera2D

# Velocidade de movimento
const SPEED = 500 #200
var scale_factor = 0.3 # Escala do tamanho do personagem
var animation_scale = 10 # Altera a velocidade dos frames da animação

func _ready():
	var parent = get_parent() # Obtém a cena "pai" onde o player está
	var background_node = getBackgroundNode()
	var scene_width
	
	if (sprites.sprite_frames == null or sprites.sprite_frames.get_animation_names().size() == 1):
		setTextureSprite();
	
	sprites.speed_scale = animation_scale
	sprites.scale = Vector2(scale_factor, scale_factor) # Altera a escala do personagem
	
	if (!GameMovement.getSetAutomaticPosition()):
		# No momento o player está configurado para ser setado em uma cena em específica
		setInitialPositionPlayer(GameMovement.getNextPositionPlayer()) # Seta o jogar na posição determinada
		GameMovement.clearNextPosition() # Reseta a posição determinada, para a próxima movimentação
		return
	
	var y_position = 430 #Posição padrão do Y do jogador
	if (background_node):
		scene_width = GameStats.sceneWidth(background_node)
		
		y_position = getPlayerPositionY(background_node)
	else:
		return #Se não tiver um background na cena, não seta a posição do player
	
	if (GameStats.getWalkDirectionState() == GameStats.WalkState.FORWARD):
		# Personagem está indo para a direita
		# Seta a posição inicial dos sprites
		sprites.position = Vector2(120, y_position)
		
		# Seta a posição inicial dos collisions
		if (GameStats.getSelectedPlayer().find("boy") != -1):
			# personagem 'boy' está selecionado
			collision.position = Vector2(70, y_position)
		elif  (GameStats.getSelectedPlayer().find("girl") != -1):
			# personagem 'girl' está selecionado
			collision.position = Vector2(130, y_position)
	elif (GameStats.getWalkDirectionState() == GameStats.WalkState.BACK):
		# Personagem está indo para a esquerda
	
		if (GameStats.getSelectedPlayer().find("boy") != -1):
			sprites.position = Vector2(scene_width - 100, y_position) #1130
			sprites.flip_h = true
			adjust_sprite_position()
			# personagem 'boy' está selecionado
			collision.position = Vector2(scene_width - 150, y_position) #1080
		elif  (GameStats.getSelectedPlayer().find("girl") != -1):
			# personagem 'girl' está selecionado
			sprites.position = Vector2(scene_width - 100, y_position) #1050
			sprites.flip_h = true
			adjust_sprite_position()
			collision.position = Vector2(scene_width - 110, y_position) #1060
	
	# Leva a câmera até a posição que o player está
	camera.position = sprites.position
	

# Movimento do personagem
func _physics_process(_delta):
	if QuestionsGame.getInQuizScene():
		# Caso o player esteja na cena do quiz, a movimentação é desabilitada
		return
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			# Inverter horizontalmente o personagem para ele olhar para a 'direita'
			if (sprites.flip_h):
				sprites.flip_h = false
				adjust_sprite_position()
				GameStats.onChangeWalkDirectionState(GameStats.WalkState.FORWARD) # Para setar globalmente que o personagem foi pra direita
		elif direction < 0:
			# Inverter horizontalmente o personagem para ele olhar para a 'esquerda'
			if (!sprites.flip_h):
				sprites.flip_h = true
				adjust_sprite_position()
				GameStats.onChangeWalkDirectionState(GameStats.WalkState.BACK) # Para setar globalmente que o personagem foi pra esquerda
		
		velocity.x = direction * SPEED
		sprites.play("walk") # Personagem está andando
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprites.play("idle") # Personagem parou de andar

	move_and_slide()
	
	print(position)

# Método para ajustar a posição do sprite ao inverter
func adjust_sprite_position():	
	#var current_animation = sprites.animation
	#var current_frame = sprites.frame
	#var texture = sprites.sprite_frames.get_frame_texture(current_animation, current_frame)
	
	var offset
	if (GameStats.getSelectedPlayer().find("boy") != -1):
		offset = Vector2(100, 0)
	elif  (GameStats.getSelectedPlayer().find("girl") != -1):
		offset = Vector2(-15, 0)
	
	
	if sprites.flip_h:
		sprites.position -= offset
	else:
		sprites.position += offset

# Método para setar todas as 'Textures' de todas as animações do personagem selecionado
func setTextureSprite():
	# Carrega todos os tipos de animações possíveis
	_loadTextureSprite("idle", "Idle")
	_loadTextureSprite("walk", "Walk")
	
	sprites.play("idle")  # Começa com animação de idle por padrão
	
func _loadTextureSprite(animation_name: String, keyword_file: String):
	# Caso o player já tenha frames setados, reutiliza o mesmo
	# Utilizado para não sobreescrever sprites já existentes
	var sprite_frames = sprites.sprite_frames
	if sprite_frames == null:
		# Caso não tenha, inicia um novo
		sprite_frames = SpriteFrames.new()
	
	# Adiciona a animação no SpriteFrames
	sprite_frames.add_animation(animation_name)
	
	# Verifica quantos arquivos tem no diretório pro atual personagem, com determina animação
	var countIdle = count_files_with_keyword(GameStats.getSelectedPlayer(), keyword_file)
	
	# Carrega as texturas e adiciona dinamicamente ao personagem
	for i in range(countIdle):
		var path = "%s%s (%d).png" % [GameStats.getSelectedPlayer(), keyword_file, (i + 1)]
		var texture = load(path)
		
		if (texture != null):
			sprite_frames.add_frame(animation_name, texture, i)

	# Seta o sprite frame no player
	sprites.frames = sprite_frames

# Função para contar quantos arquivos tem em um diretório, conforme uma string
func count_files_with_keyword(directory_path: String, keyword: String) -> int:
	# Tenta achar o diretório
	var dir = DirAccess.open(directory_path)
	if not dir:
		print("Failed to open directory")
		return 0

	# Obtém todos os arquivo do diretório
	var files = dir.get_files()
	
	var file_count = 0
	for i in range(files.size()):
		var file = files[i]
		# Verifica se o arquivo atual, possui a "keyword" no nome
		if file.find(keyword) != -1:
			file_count += 1
			
	# Divide por 2 para ignorar os arquivos 'duplicados' que o próprio godot cria ao importar algo
	@warning_ignore("integer_division")
	return file_count / 2 


func disableCamera():
	camera.enabled = false

func setPositionCamera(offset):
	camera.offset = offset

func setRigthCameraLimit(limit):
	camera.limit_right = float(limit)

func getBackgroundNode():
	var parent = get_parent() # Obtém a cena "pai" onde o player está
	var background_node
	
	# Procura se a cena pai tem um nó chamado "background", o que se espera ser o TileSet
	if parent and parent.has_node("background"):
		background_node = parent.get_node("background")
		
		return background_node
	else:
		return null
	
func getPlayerPositionY(background_node: TileMap):
	var scene_heigth = GameStats.sceneHeigth(background_node)
	var texture = sprites.sprite_frames.get_frame_texture("idle", 0)
	var texture_heigth = texture.get_height()
	
	print(GameStats.getCurrentScene())
	
	var adjust = 0
	if GameStats.getCurrentScene() == 0:
		# Na cena 0 ("intro_school"), há uma diferença no background
		if GameStats.getSelectedPlayer().find("boy") != -1:
			# Boy
			adjust = 280
		else:
			# Girl
			adjust = 123
	elif GameStats.getCurrentScene() == 4:
		# Na cena 3 (top floor), é necessário fazer um ajuste apenas para a menina
		if GameStats.getSelectedPlayer().find("girl") != -1:
			adjust = 25
	else:
		# Todas as outras cenas
		if GameStats.getSelectedPlayer().find("boy") != -1:
			# Boy
			adjust = 70
		else:
			# Girl
			adjust = 15
	
	# Calcula a posição padrão do "boy"
	var y_position = (scene_heigth - (texture_heigth * scale_factor)) + adjust
	
	if (GameStats.getSelectedPlayer().find("girl") != -1):
		# Para a "girl" tira alguns pixels
		y_position += adjust
	
	return y_position

# Dado as posições X e Y da cena, seta o player diretamente naquela posição
func setInitialPositionPlayer(position: Vector2):	
	sprites.flip_h = false # Irá deixar sempre o jogador indo para a direita
	adjust_sprite_position()
	GameStats.onChangeWalkDirectionState(GameStats.WalkState.FORWARD) # Para setar globalmente que o personagem foi pra direita
	
	var background_node = getBackgroundNode()
	if (background_node == null):
		return
	
	var y_position = getPlayerPositionY(background_node)
	
	# Seta a posição inicial dos sprites
	sprites.position = Vector2(position.x, y_position)
	
	# Seta a posição inicial dos collisions
	if (GameStats.getSelectedPlayer().find("boy") != -1):
		# personagem 'boy' está selecionado
		collision.position = Vector2(position.x - 50, y_position)
	elif (GameStats.getSelectedPlayer().find("girl") != -1):
		# personagem 'girl' está selecionado
		collision.position = Vector2(position.x + 10, y_position)
	
	# Leva a câmera até a posição que o player está
	camera.position = sprites.position
