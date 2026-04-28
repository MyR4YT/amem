extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var is_hurting := false 

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Aplica a gravidade sempre
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Lógica do Knockback
	if is_hurting:
		# A MÁGICA AQUI: Só sai do estado de dano se tocar o chão E a velocidade Y
		# for maior ou igual a zero (ou seja, você já subiu e agora caiu/pousou).
		if is_on_floor() and velocity.y >= 0:
			is_hurting = false
		else:
			# Se ainda está voando pelo empurrão, apenas move e encerra o frame
			move_and_slide()
			return 

	# --- DAQUI PRA BAIXO É O MOVIMENTO NORMAL (só roda se is_hurting for false) ---

	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	
	# Gerenciamento de Animações
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("Jump")
		else:
			anim.play("Fall")
	elif direction != 0:
		anim.play("Walk")
		anim.flip_h = (direction < 0)
	else:
		anim.play("Idle")

	# Movimentação Horizontal
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# --- FUNÇÕES EXTRAS ---

func take_damage(knockback_force := Vector2(-200, -200)):
	if is_hurting: return 
	
	is_hurting = true
	Global.health -= 1
	
	# Aplica o empurrão (Isso faz a velocity.y ficar negativa instantaneamente)
	velocity = knockback_force
	anim.play("Damage")
	
	if Global.health <= 0:
		die()
	
	# Removemos totalmente o Timer daqui! 
	# A física no _physics_process agora cuida de saber a hora exata de parar.

# No arquivo Player.gd
func die():
	Global.health = 3
	Global.coins = 0
	# Em vez de reload_current_scene(), chamamos a tela nova!
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
