@tool
extends RigidBody2D

@export_range(0, 16) var energy: float = 0.5:
	set(value):
		if point_light_2d:
			point_light_2d.energy = value
		energy = value
		
@export_range(0, 16) var energy_scale: float = 1:
	set(value):
		if point_light_2d:
			point_light_2d.texture_scale = value
		energy_scale = value

@export_range(0, 16) var energy_shadow: float = 0.5:
	set(value):
		if point_light_2d_shadow:
			point_light_2d_shadow.energy = value
		energy_shadow = value

@export_range(0, 16) var energy_shadow_scale: float = 3:
	set(value):
		if point_light_2d_shadow:
			point_light_2d_shadow.texture_scale = value
		energy_shadow_scale = value


@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var point_light_2d_shadow: PointLight2D = $PointLight2DShadow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
