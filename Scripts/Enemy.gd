extends CharacterBody2D
var gravity = 980.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

# Função gerada pelo sinal timeout() do Timer! Ela roda a cada 2 segundos.
func _on_jump_timer_timeout():
	if is_on_floor():
		anim.play("Idle") 
		velocity.y = -350.0 # Pula para cima
		# randi_range sorteia um número aleatório. Aqui sorteamos se vai pra esquerda ou direita!
		velocity.x = randi_range(-1, 1) * 100
