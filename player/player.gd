extends CharacterBody2D

signal sonar_activated(charges: int)

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var helmet_light: PointLight2D = $HelmetLight
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ligth_bar_scene = preload("res://objects/light_bar.tscn")

var can_trigger_coyote_time := true
var already_jumped := false

const SPEED = 75.0
const JUMP_VELOCITY = -200.0
const INITIAL_CIRCLE_RADIUS := 32.0

var light_increasee_time: float = 0.15
var light_increase_speed: float = 20
var circle_radius := INITIAL_CIRCLE_RADIUS

var min_light_scale := 1
var max_light_scale := 3
var light_scale := min_light_scale

@onready var label: Label = $Label

var MIN_CHARGES := 0
var MAX_CHARGES := 5
var charges := MAX_CHARGES

var MIN_ENERGY := 0.3
var MAX_ENERGY := 1
var BURST_ENERGY := 1.5

var light_x_position := 0

func _ready():
	$ColorRect.visible = false
	light_x_position = helmet_light.position.x
	set_charges()
	
	
func _process(delta: float) -> void:
	pass


#func _draw():
	#if not light_increase_timer.is_stopped() or not light_decrease_timer.is_stopped():
		#draw_circle(point_light_2d.position, circle_radius, Color.WHITE, false, 1.5)
		#draw_circle(point_light_2d.position, circle_radius * 0.8, Color.WHITE, false, 1.25)
	#var tween = get_tree().create_tween()
	#tween.tween_property(point_light_2d, "energy", target_energy, 2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if can_trigger_coyote_time:
			coyote_timer.start()
			can_trigger_coyote_time = false
	else:
		can_trigger_coyote_time = true
		already_jumped = false
		coyote_timer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_coyote_floor():
		velocity.y = JUMP_VELOCITY
		already_jumped = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		helmet_light.position.x = -light_x_position
		helmet_light.scale.x = -1
		animation_player.play("run")
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		helmet_light.position.x = light_x_position
		helmet_light.scale.x = 1
		animation_player.play("run")
	else:
		animation_player.play("idle")

	move_and_slide()
	
	
func is_on_coyote_floor():
	return is_on_floor() or (coyote_timer.time_left > 0 and not already_jumped)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			drop_light_bar()
				
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# cheat!
			charges += 1
			set_charges()


func drop_light_bar():
	var item: RigidBody2D = ligth_bar_scene.instantiate()
	item.position = global_position + Vector2.UP * 10
	var container = get_tree().get_nodes_in_group("lights_container")[0]
	assert(container)
	if container.get_child_count() >= MAX_CHARGES:
		var child = container.get_children()[0]
		container.remove_child(child)
		child.queue_free()
	
	var force = 50
	if velocity.x > 0 or velocity.x < 0:
		force *= 3
	if $Sprite2D.flip_h:
		force = force * -1
	force = Vector2(force, -200)
	item.linear_velocity
	item.apply_central_impulse(force)
	container.add_child(item)


func set_charges():
	label.text = "%s" % charges
