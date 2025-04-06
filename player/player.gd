extends CharacterBody2D

signal sonar_activated(charges: int)

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var light_increase_timer: Timer = $LightIncreaseTimer
@onready var light_decrease_timer: Timer = $LightDecreaseTimer

@onready var coyote_timer: Timer = $CoyoteTimer
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

func _ready():
	point_light_2d.visible = true
	point_light_2d.texture_scale = light_scale
	point_light_2d.energy = MAX_ENERGY
	light_increase_timer.wait_time = light_increasee_time
	
	set_charges()
	
	
func _process(delta: float) -> void:
	increase_sonar_size(delta)	


func _draw():
	if not light_increase_timer.is_stopped() or not light_decrease_timer.is_stopped():
		draw_circle(point_light_2d.position, circle_radius, Color.WHITE, false, 1.5)
		draw_circle(point_light_2d.position, circle_radius * 0.8, Color.WHITE, false, 1.25)


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
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

	move_and_slide()
	
	
func is_on_coyote_floor():
	return is_on_floor() or (coyote_timer.time_left > 0 and not already_jumped)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and light_decrease_timer.is_stopped():
				enable_sonar()
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and light_decrease_timer.is_stopped():
				# cheat!
				charges += 1
				set_charges()
				

func enable_sonar():
	charges = clamp(charges - 1, MIN_CHARGES, MAX_CHARGES)
	
	point_light_2d.energy = 1.5
	var target_energy = remap(charges, MIN_CHARGES, MAX_CHARGES, MIN_ENERGY, MAX_ENERGY)
	print(target_energy)
	
	var tween = get_tree().create_tween()
	tween.tween_property(point_light_2d, "energy", target_energy, 2)
	
	set_charges()
	light_increase_timer.start()
	sonar_activated.emit(charges)


func increase_sonar_size(delta):
	if not light_increase_timer.is_stopped():
		var prev := point_light_2d.texture_scale
		point_light_2d.texture_scale += light_increase_speed * delta
		
		var factor_change := (point_light_2d.texture_scale - prev)  / prev 
		circle_radius = circle_radius * (1 + factor_change)
		queue_redraw()
		
	
func disable_sonar():
	point_light_2d.texture_scale = min_light_scale
	circle_radius = INITIAL_CIRCLE_RADIUS
	queue_redraw()
	

func set_charges():
	label.text = "%s" % charges


func _on_light_increase_timer_timeout() -> void:
	light_decrease_timer.start()


func _on_light_decrease_timer_timeout() -> void:
	disable_sonar()
