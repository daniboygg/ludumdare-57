extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player

var initial_color = Color("#191919")
var lighter_color = Color("#bbbbbb")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = true
	canvas_modulate.color = initial_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_sonar_enabled() -> void:
	canvas_modulate.color = lighter_color
	
	var tween = get_tree().create_tween()
	tween.tween_property(canvas_modulate, "color", initial_color, 1)
