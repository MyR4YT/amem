shader_type canvas_item;

// Parâmetros que controlaremos por código no ritmo da música
uniform vec4 laser_color : source_color = vec4(0.0, 0.8, 1.0, 1.0); // Cor do laser (ex: azul/ciano)
uniform vec4 warning_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Vermelho do aviso
uniform float is_warning : hint_range(0.0, 1.0) = 1.0; // 1.0 para aviso, 0.0 para laser ativo
uniform float laser_progress : hint_range(0.0, 1.0) = 0.0; // Controla o laser descendo (0 a 1)

// Parâmetros do efeito de onda (Cachoeira)
uniform float wave_speed = 15.0;
uniform float wave_frequency = 20.0;
uniform float wave_amplitude = 0.03;

void fragment() {
    vec2 uv = UV;
    
    // Efeito de onda nas laterais (distorce o UV em X baseado no Y e no Tempo)
    float wave = sin(uv.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
    
    // Aplica a distorção apenas nas bordas (atenuando no centro para o laser não quebrar)
    float border_mask = smoothstep(0.0, 0.3, uv.x) * smoothstep(1.0, 0.7, uv.x);
    uv.x += wave * border_mask;
    
    // Máscara para o corpo do laser (corta as laterais fora do formato)
    float laser_mask = smoothstep(0.1, 0.2, uv.x) * smoothstep(0.9, 0.8, uv.x);
    
    // Efeito de aparecer de cima para baixo
    float growth_mask = step(uv.y, laser_progress);
    
    // Cor de aviso pisca com o tempo
    float flash = mod(TIME * 5.0, 1.0) > 0.5 ? 1.0 : 0.4;
    vec4 final_warning = warning_color * flash;
    
    // Interpola entre a cor de aviso e a cor do laser real
    vec4 current_color = mix(laser_color, final_warning, is_warning);
    
    // Se for aviso, o laser já aparece inteiro na tela, mas translúcido e piscando
    // Se for o laser ativo, ele obedece o crescimento de cima para baixo (growth_mask)
    float final_alpha = mix(laser_mask * growth_mask, laser_mask * 0.6, is_warning);
    
    COLOR = vec4(current_color.rgb, final_alpha * current_color.a);
}