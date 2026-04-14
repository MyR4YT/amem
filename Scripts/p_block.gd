extends StaticBody2D

# Se 'starts_active' for true, o bloco começa sólido e DESATIVA com o botão.
# Se for false, ele começa atravessável e ATIVA com o botão.
@export var starts_active: bool = false 

@onready var anim = $AnimatedSprite2D 
@onready var collision = $CollisionShape2D

func _process(_delta: float) -> void:
	if Global.p_button_active:
		# Se o botão global está ativo, o bloco assume o estado OPOSTO ao inicial
		update_block_state(not starts_active)
	else:
		# Se o botão está desligado, o bloco assume o estado inicial dele
		update_block_state(starts_active)

func update_block_state(should_be_solid: bool) -> void:
	if should_be_solid:
		# Estado ATIVO: Sólido e animação 'Active'
		collision.set_deferred("disabled", false)
		if anim.animation != "Active":
			anim.play("Active")
	else:
		# Estado INATIVO: Sem colisão e animação 'Normal'
		collision.set_deferred("disabled", true)
		if anim.animation != "Normal":
			anim.play("Normal")
