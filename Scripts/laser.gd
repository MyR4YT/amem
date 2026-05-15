extends ColorRect # Ou Sprite2D, dependendo do que usou

# Configuração de quando o ataque acontece (em batidas)
@export var beat_to_warn: float = 26.0
@export var beat_to_fire: float = 27.0
@export var beat_to_流_end: float = 34.0
@export var drop_duration_beats: float = 0.5

var shader_material: ShaderMaterial

func _ready():
	shader_material = material as ShaderMaterial
	# Inicializa o laser invisível/desativado
	shader_material.set_shader_parameter("laser_progress", 0.0)
	shader_material.set_shader_parameter("is_warning", 0.0)
	
	# Conecta ao seu Conductor (substitua pelo caminho correto do seu Singleton/Nó)
	var conductor = $".."
	conductor.beat_changed.connect(_on_music_beat)

func _on_music_beat(current_beat: float):
	# FASE 1: Sinalizar Aviso (Vermelho piscando)
	if current_beat >= beat_to_warn and current_beat < beat_to_fire:
		shader_material.set_shader_parameter("is_warning", 1.0)
		shader_material.set_shader_parameter("laser_progress", 1.0) # Linha inteira acende fraca
		monitoring_damage(false) # Função fictícia: aviso não dá dano
		
	# FASE 2: Disparar o Laser (De cima para baixo no ritmo)
	# FASE 2: Disparar o Laser (Ativo, azul/ciano de cima para baixo)
	elif current_beat >= beat_to_fire and current_beat < beat_to_流_end:
		shader_material.set_shader_parameter("is_warning", 0.0)
		
		# Contamos o tempo decorrido especificamente a partir do momento do disparo
		var time_since_fired = current_beat - beat_to_fire
		
		# O progresso de descida agora depende APENAS da velocidade que você escolheu
		var drop_progress = time_since_fired / drop_duration_beats
		var laser_drop = clamp(drop_progress, 0.0, 1.0) 
		
		shader_material.set_shader_parameter("laser_progress", laser_drop)
		monitoring_damage(true)
		
	# FASE 3: Desativar o Laser
	else:
		shader_material.set_shader_parameter("laser_progress", 0.0)
		shader_material.set_shader_parameter("is_warning", 0.0)
		monitoring_damage(false)

func monitoring_damage(active: bool):
	# Aqui você liga/desliga a colisão do seu Area2D de dano
	pass
