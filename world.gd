extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player

var lighter_color = Color("#eeeeee")

var colors: Array[Color] = [
	Color("#323232"),
	Color("#505050"),
	Color("#6e6e6e"),
	Color("#8c8c8c"),
	Color("#aaaaaa"),
	Color("#c8c8c8"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = true
	canvas_modulate.color = colors[4]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_sonar_activated(charges: int) -> void:
	canvas_modulate.color = lighter_color
	
	var tween = get_tree().create_tween()
	
	assert(charges < 5)
	tween.tween_property(canvas_modulate, "color", colors[charges], 1)
