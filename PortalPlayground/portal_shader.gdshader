shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D portal_tex : source_color;
uniform vec2 c1;
uniform vec2 c2;
uniform vec2 c3;
uniform vec2 c4;

bool point_in_quad(vec2 uv, vec2 a, vec2 b, vec2 c, vec2 d) {
    // Split into 2 triangles (a,b,c) and (a,c,d)
    float s1 = sign(cross(vec3(b - a, 0.0), vec3(uv - a, 0.0)).z);
    float s2 = sign(cross(vec3(c - b, 0.0), vec3(uv - b, 0.0)).z);
    float s3 = sign(cross(vec3(a - c, 0.0), vec3(uv - c, 0.0)).z);
    bool inTri1 = (s1 == s2) && (s2 == s3);

    float t1 = sign(cross(vec3(c - a, 0.0), vec3(uv - a, 0.0)).z);
    float t2 = sign(cross(vec3(d - c, 0.0), vec3(uv - c, 0.0)).z);
    float t3 = sign(cross(vec3(a - d, 0.0), vec3(uv - d, 0.0)).z);
    bool inTri2 = (t1 == t2) && (t2 == t3);

    return inTri1 || inTri2;
}

void fragment() {

	vec2 uv = UV;
	
	if (point_in_quad(uv, c1, c2, c3, c4)) {
        vec4 col = texture(portal_tex, uv);
	    ALBEDO = col.rgb;
	    ALPHA = 1.0;
    } else {
        discard; // Do not draw outside
    }
}
