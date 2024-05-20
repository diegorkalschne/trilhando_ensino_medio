extends Node2D

@onready var player = $player

func _ready():
	# Setando a textura automaticamente do player
	#player.texture = load(GameStats.selected_player + "Dead (1).png")
	# Redefinindo a scale
	#player.scale = Vector2(0.3, 0.3)
	
	player.setTextureSprite()

	player.position = Vector2(60, 500)
