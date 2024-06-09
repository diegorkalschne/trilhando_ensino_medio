extends Sprite2D

func setTexture(background_path):
	# Carrega a textura dinamicamente
	var texture = load(background_path)
	self.texture = texture
	
	# Chama a função para ajustar a escala
	adjust_scale_to_fill_viewport()

func adjust_scale_to_fill_viewport():
	# Obtém o tamanho da textura
	var texture_size = self.texture.get_size()
		
	# Obtém o tamanho da tela
	var screen_size = DisplayServer.window_get_size()
	
	# Calcula a escala necessária para preencher a janela
	var scale_x = 1
	if (texture_size.x > screen_size.x):
		scale_x = texture_size.x / screen_size.x
	else:
		scale_x = screen_size.x / texture_size.x
	
	var scale_y = 1
	if (texture_size.y > screen_size.y):
		scale_y = texture_size.y / screen_size.y
	else:
		scale_y = screen_size.y / texture_size.y

	# Define a escala do sprite para que ele preencha a janela
	self.scale = Vector2(scale_x, scale_y)
