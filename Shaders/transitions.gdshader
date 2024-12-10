shader_type canvas_item;

uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;
uniform vec2 center = vec2(0.5);
uniform vec2 player = vec2(0.5);

uniform float progress : hint_range(0.0, 1.0);
uniform float pixel_size = 15.0;
uniform float circle_size : hint_range(0.0, 2.0) = 1.5;
uniform float curtains : hint_range(0.0, 1.0) = 1.0;

uniform int type : hint_range(0, 4) = 0;

void fragment() {
    vec2 uv = UV;

    // Tipo Diamante Pixel
    if (type == 0) {
        float x_fraction = fract(SCREEN_UV.x * screen_width / pixel_size);
        float y_fraction = fract(SCREEN_UV.y * screen_height / pixel_size);

        float x_distance = abs(x_fraction - 0.5);
        float y_distance = abs(y_fraction - 0.5);

        if (x_distance + y_distance > progress * 4.0) {
            discard;
        }
    }
    // Tipo Círculo no player
    else if (type == 1) {
        float ratio = screen_width / screen_height;
        if (distance(player, vec2(mix(player.x, uv.x, ratio), uv.y)) < circle_size * (1.0 - progress)) {
            COLOR.a = 0.0;
        }
    }
    // Tipo Círculo no Centro
    else if (type == 2) {
        float ratio = screen_width / screen_height;
        if (distance(center, vec2(mix(center.x, uv.x, ratio), uv.y)) < circle_size * (1.0 - progress)) {
            COLOR.a = 0.0;
        }
    }
    // Tipo Corte Vertical
    else if (type == 3) {
        if (abs(uv.x - 0.5) < curtains * (1.0 - progress)) {
            COLOR.a = 0.0;
        }
    }
    // Tipo Corte Horizontal
    else if (type == 4) {
        if (abs(uv.y - 0.5) < curtains * (1.0 - progress)) {
            COLOR.a = 0.0;
        }
    }
}