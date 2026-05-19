extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var is_hurting := false 

@onready var anim = $AnimatedSprite2D
@onready var anit = $AnimationPlayer
@onready var cam = $Camera2D
var side = 2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_hurting:
		if is_on_floor() and velocity.y >= 0:
			is_hurting = false
		else:
			move_and_slide()
			return

	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("Jump")
		else:
			anim.play("Fall")
	elif direction != 0:
		anim.play("Walk")
		if direction > 0 and side != 1:
			print("b")
			side = 1
			anit.play("flip")
		elif direction < 0 and side != 2:
			print("a")
			side = 2
			anit.play("flip2")
	else:
		anim.play("Idle")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func take_damage(knockback_force := Vector2(-200, -200)):
	if is_hurting: return 
	
	is_hurting = true
	Global.health -= 1
	
	velocity = knockback_force
	anim.play("Damage")
	
	if Global.health <= 0:
		die()
	
func die():
	Global.health = 3
	Global.coins = 0
	# Em vez de reload_current_scene(), chamamos a tela nova!
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("d")
		die()
