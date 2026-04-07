extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction: # Se o jogador estiver apertando algum botão de andar...
		velocity.x = direction * SPEED # Aplica a velocidade
		anim.play("Walk") # Toca a animação "run"
		anim.flip_h = (direction < 0) # Vira a imagem para a esquerda se direction for negativo
	else: # Se soltou os botões...
		velocity.x = move_toward(velocity.x, 0, SPEED) # Freia o personagem
		anim.play("Idle") # Toca a animação "idle"

	move_and_slide()

# Adicione no final do script do Player.gd

func take_damage():
	Global.health -= 1 # Tira 1 do Global.health
	
	if Global.health <= 0: # Se a vida chegar a zero ou menos...
		die()              # ...chama a função de morte

func die():
	print("Game Over - O jogador morreu!")
	Global.health = 3 # Reseta vida para a próxima tentativa
	Global.coins = 0  # Opcional: faz o jogador perder as moedas ao morrer
	
	# Recarrega a cena atual imediatamente (recomeça a fase)
	# Mais tarde vamos mudar isso para ir para uma Tela de Game Over de verdade
	get_tree().reload_current_scene()
