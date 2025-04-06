extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
