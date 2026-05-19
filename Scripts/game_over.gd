extends Control

# Função ativada quando o jogador clica no botão com o mouse ou teclado
func _on_restart_button_pressed():
	# Volta o jogador para o Level 1
	get_tree().change_scene_to_file("res://Scenes/fase_1.tscn")
