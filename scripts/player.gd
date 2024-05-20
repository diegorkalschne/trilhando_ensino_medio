extends CharacterBody2D

@onready var player = $Player
@onready var sprites = $sprites as AnimatedSprite2D

# Velocidade de movimento
const SPEED = 300.0

# Movimento do personagem
func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			sprites.flip_h = false # direita
		elif direction < 0:
			sprites.flip_h = true # esquerda
		
		velocity.x = direction * SPEED
		sprites.play("walk") # Personagem está andando
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprites.play("idle") # Personagem parou de andar

	move_and_slide()

# Método para setar todas as 'Textures' de todas as animações do personagem selecionado
func setTextureSprite():
	# Carrega todos os tipos de animações possíveis
	_loadTextureSprite("idle", "Idle")
	_loadTextureSprite("walk", "Walk")
	
	sprites.play("idle")  # Começa com animação de idle por padrão
	
func _loadTextureSprite(animation_name: String, keyword_file: String):
	# Caso o player já tenha frames setados, reutilizao o mesmo
	var sprite_frames = sprites.sprite_frames
	if sprite_frames == null:
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
	var dir = DirAccess.open(directory_path)
	if not dir:
		print("Failed to open directory")
		return 0

	var file_count = 0
	
	var files = dir.get_files()
	
	for i in range(files.size()):
		var file = files[i]
		if file.find(keyword) != -1:
			file_count += 1
			
	# Divido por 2 para ignorar os arquivos 'duplicados' que o próprio godot cria ao importar algo
	return file_count / 2 
