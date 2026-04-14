extends StaticBody2D

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Normal")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.velocity.y >= 0:
		activate_button()

func activate_button():
	if Global.p_button_active: return # Evita resetar se já estiver ativo
	
	Global.p_button_active = true
	anim.play("Pressed")
	
	# Espera o tempo do efeito (ex: 5 segundos)
	await get_tree().create_timer(5.0).timeout
	
	Global.p_button_active = false
	anim.play("Normal")
