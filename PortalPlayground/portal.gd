class_name Portal
extends MeshInstance3D


const PORTAL_SHADER = preload("uid://bnqa1pcv8pp71")
const UV_DEBUGGING = preload("uid://dbgf723wn4bda")


@export var player_cam: Camera3D
@export var target_portal: Portal

var mat


func _ready() -> void:
	set_shader_texture(target_portal.get_child(0))


func _process(_delta: float) -> void:
	
	var camera: Camera3D = get_child(0).get_child(0)
	
	# update camera transform
	camera.transform = self.global_transform * target_portal.global_transform.affine_inverse() * player_cam.global_transform
	
	# update uvs
	var corner_a: Vector3 = self.global_position + Vector3(-3.0, -2.0, 0.0)
	var corner_b: Vector3 = self.global_position + Vector3(3.0, -2.0, 0.0)
	var corner_c: Vector3 = self.global_position + Vector3(3.0, 2.0, 0.0)
	var corner_d: Vector3 = self.global_position + Vector3(-3.0, 2.0, 0.0)
	var corner_a_cam: Vector2 = camera.unproject_position(corner_a)
	var corner_b_cam: Vector2 = camera.unproject_position(corner_b)
	var corner_c_cam: Vector2 = camera.unproject_position(corner_c)
	var corner_d_cam: Vector2 = camera.unproject_position(corner_d)
	var corner_a_cam_adjusted_uv: Vector2 = corner_a_cam / camera.get_viewport().get_visible_rect().size
	var corner_b_cam_adjusted_uv: Vector2 = corner_b_cam / camera.get_viewport().get_visible_rect().size
	var corner_c_cam_adjusted_uv: Vector2 = corner_c_cam / camera.get_viewport().get_visible_rect().size
	var corner_d_cam_adjusted_uv: Vector2 = corner_d_cam / camera.get_viewport().get_visible_rect().size
	target_portal.mat.set_shader_parameter("c1", corner_a_cam_adjusted_uv)
	target_portal.mat.set_shader_parameter("c2", corner_b_cam_adjusted_uv)
	target_portal.mat.set_shader_parameter("c3", corner_c_cam_adjusted_uv)
	target_portal.mat.set_shader_parameter("c4", corner_d_cam_adjusted_uv)


func set_shader_texture(viewport: SubViewport):
	mat = get_surface_override_material(0)
	
	if mat == null or not (mat is ShaderMaterial):
		mat = ShaderMaterial.new()
		mat.shader = UV_DEBUGGING
		set_surface_override_material(0, mat)
	
	# Now mat is guaranteed to be a ShaderMaterial
	mat.set_shader_parameter("portal_tex", viewport.get_texture())
