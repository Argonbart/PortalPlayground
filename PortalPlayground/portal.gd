class_name Portal
extends MeshInstance3D


@export var player_cam: Camera3D
@export var target_portal: Portal


func _ready() -> void:
	set_portal_to_viewport(self, target_portal.get_child(0))


func _process(_delta: float) -> void:
	get_child(0).get_child(0).transform = self.global_transform * target_portal.global_transform.affine_inverse() * player_cam.global_transform


func set_portal_to_viewport(portal: Portal, viewport: SubViewport):
	var mat = portal.get_surface_override_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		portal.set_surface_override_material(0, mat)
	mat.albedo_texture = viewport.get_texture()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
