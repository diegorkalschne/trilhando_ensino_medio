extends CharacterBody2D

@onready var player = $Player as CharacterBody2D
@onready var sprites = $sprites as AnimatedSprite2D
@onready var collision = $collision as CollisionShape2D

# Velocidade de movimento
const SPEED = 200

func _ready():
	sprites.speed_scale = 10 # Altera a velocidade dos frames da animação
	sprites.scale = Vector2(0.3, 0.3) # Altera a escala do personagem
	
	if (GameStats.walk_direction_state == GameStats.WalkState.FORWARD):
		# Personagem está indo para a direita
		sprites.position = Vector2(120, 500)
	
		if (GameStats.selected_player.find("boy") != -1):
			# personagem 'boy' está selecionado
			collision.position = Vector2(70, 500)
		elif  (GameStats.selected_player.find("girl") != -1):
			# personagem 'girl' está selecionado
			collision.position = Vector2(130, 500)
	elif (GameStats.walk_direction_state == GameStats.WalkState.BACK):
		# Personagem está indo para a esquerda
	
		if (GameStats.selected_player.find("boy") != -1):
			sprites.position = Vector2(1130, 500)
			sprites.flip_h = true
			adjust_sprite_position()
			# personagem 'boy' está selecionado
			collision.position = Vector2(1080, 500)
		elif  (GameStats.selected_player.find("girl") != -1):
			# personagem 'girl' está selecionado
			sprites.position = Vector2(1050, 500)
			sprites.flip_h = true
			adjust_sprite_position()
			collision.position = Vector2(1060, 500)
	

# Movimento do personagem
func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			# Inverter horizontalmente o personagem para ele olhar para a 'direita'
			if (sprites.flip_h):
				sprites.flip_h = false
				adjust_sprite_position()
				GameStats.walk_direction_state = GameStats.WalkState.FORWARD # Para setar globalmente que o personagem foi pra direita
		elif direction < 0:
			# Inverter horizontalmente o personagem para ele olhar para a 'esquerda'
			if (!sprites.flip_h):
				sprites.flip_h = true
				adjust_sprite_position()
				GameStats.walk_direction_state = GameStats.WalkState.BACK # Para setar globalmente que o personagem foi pra esquerda
		
		velocity.x = direction * SPEED
		sprites.play("walk") # Personagem está andando
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprites.play("idle") # Personagem parou de andar

	move_and_slide()

# Método para ajustar a posição do sprite ao inverter
func adjust_sprite_position():	
	#var current_animation = sprites.animation
	#var current_frame = sprites.frame
	#var texture = sprites.sprite_frames.get_frame_texture(current_animation, current_frame)
	
	var offset
	if (GameStats.selected_player.find("boy") != -1):
		offset = Vector2(100, 0)
	elif  (GameStats.selected_player.find("girl") != -1):
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
	var countIdle = count_files_with_keyword(GameStats.selected_player, keyword_file)
	
	# Carrega as texturas e adiciona dinamicamente ao personagem
	for i in range(countIdle):
		var path = "%s%s (%d).png" % [GameStats.selected_player, keyword_file, (i + 1)]
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
	return file_count / 2 
