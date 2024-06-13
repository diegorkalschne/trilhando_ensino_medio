# Script utilizado para gerenciar as posições do player ao trocar de cenas
extends Node

var _set_automatic_position: bool = true

var _next_position_player: Vector2 = Vector2(0,0)

func setNextPositionPlayer(position: Vector2):
	_set_automatic_position = false
	_next_position_player = position

func clearNextPosition():
	_set_automatic_position = true
	_next_position_player = Vector2(0,0)

func getNextPositionPlayer():
	return _next_position_player

func getSetAutomaticPosition():
	return _set_automatic_position
