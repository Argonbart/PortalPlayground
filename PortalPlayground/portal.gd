class_name Portal
extends MeshInstance3D

const PORTAL_SHADER = preload("uid://bnqa1pcv8pp71")

@export var player_cam: Camera3D
@export var target_portal: Portal

var portal_camera: Camera3D
var player_last_side: bool
var player_inside_portal: bool


func _ready() -> void:
	set_shader_texture(target_portal.get_child(0))
	portal_camera = get_child(0).get_child(0)
	player_last_side = get_player_side()
	player_inside_portal = false


func set_shader_texture(viewport: SubViewport):
	var mat = get_surface_override_material(0)
	if mat == null or not (mat is ShaderMaterial):
		mat = ShaderMaterial.new()
		mat.shader = PORTAL_SHADER
		set_surface_override_material(0, mat)
	mat.set_shader_parameter("portal_tex", viewport.get_texture())


func _process(_delta: float) -> void:
	
	# --- Update portal camera mirror ---
	portal_camera.transform = global_transform * target_portal.global_transform.affine_inverse() * player_cam.global_transform
	
	# Cull mask swap (layer 2 vs 3)
	var player_is_in_front = get_player_side()
	portal_camera.set_cull_mask_value(2, !player_is_in_front)
	portal_camera.set_cull_mask_value(3, player_is_in_front)
	
	var current_side = get_player_side()
	var player = $"../../Player"
	var player_to_portal_distance = (player.global_position - self.global_position).length()
	if not player.ported and player_to_portal_distance < 4.0 and current_side != player_last_side:
		teleport_player()
		player.ported = true
		await RenderingServer.frame_post_draw
		player.ported = false
		player_inside_portal = false
	player_last_side = current_side


func get_player_side() -> bool:
	var portal_normal = global_transform.basis.z.normalized()
	var to_camera = player_cam.global_transform.origin - global_transform.origin
	return portal_normal.dot(to_camera) >= 0.0


# --- Teleport ---
func teleport_player():
	var player_root = player_cam.get_parent().get_parent()
	var relative = global_transform.affine_inverse() * player_root.global_transform
	player_root.global_transform = target_portal.global_transform * relative

	# Immediately update portal cameras
	portal_camera.transform = global_transform * target_portal.global_transform.affine_inverse() * player_cam.global_transform
	target_portal.portal_camera.transform = target_portal.global_transform * global_transform.affine_inverse() * player_cam.global_transform


func _on_portal_area_body_entered(_body: Node3D) -> void:
	player_inside_portal = true


func _on_portal_area_body_exited(_body: Node3D) -> void:
	player_inside_portal = false
