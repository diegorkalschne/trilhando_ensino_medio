extends VBoxContainer

# Define um limite máximo de largura para os botões
var max_width = 500

# Ajusta o tamanho de todos os botões filhos quando a cena é carregada
func adjust_size():
	for child in get_children():
		if child is Button:
			_adjust_button_size(child)

# Ajusta o tamanho do botão com base no texto
func _adjust_button_size(button: Button):
	var text_size = button.get_theme_font("font").get_string_size(button.text)

	if text_size.x > max_width:
		var max_heigth = text_size.y * ceil(text_size.x / max_width)
		button.custom_minimum_size = Vector2(max_width, max_heigth)
	else:
		button.custom_minimum_size = text_size
