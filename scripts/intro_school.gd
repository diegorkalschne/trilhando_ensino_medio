extends Node2D

@onready var player = $player

func _ready():	
	player.setTextureSprite()


func _on_area_2d_body_entered(body):
	print(body)
