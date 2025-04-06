extends RigidBody2D

@onready var fall_wait: Timer = $FallWait

func _ready() -> void:
	freeze = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = get_tree().get_nodes_in_group("player")[0]
	if body == player:
		fall_wait.start()


func _on_fall_wait_timeout() -> void:
	set_deferred("freeze", false)
