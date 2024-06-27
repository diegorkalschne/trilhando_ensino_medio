extends Node

# Função para exibir um Snackbar
func showSnackbar(message: String):
	# Instancia um snackbar
	var snackbar = load("res://scenes/snackbar.tscn").instantiate() as Snackbar
	get_tree().root.add_child(snackbar)
		
	var tree = get_tree().root.get_child(0);
		
	# Exibe uma mensagem pro jogador
	snackbar.show_message(message, GameCore.getCurrentPlayerPosition(), 1)

func showSnackbarWithMarker(message: String, marker: Marker2D):
	# Instancia um snackbar
	var snackbar = load("res://scenes/snackbar.tscn").instantiate() as Snackbar
	get_tree().root.add_child(snackbar)
		
	var tree = get_tree().root.get_child(0);
		
	# Exibe uma mensagem pro jogador
	snackbar.show_message(message, marker.global_position, 1)
