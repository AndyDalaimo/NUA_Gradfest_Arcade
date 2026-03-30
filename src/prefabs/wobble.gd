extends Control

# Wobble settings
@export var wobble_intensity: float = 3.0  # How far it moves (pixels)
@export var wobble_speed: float = 1.0      # How fast it wobbles
@export var rotation_intensity: float = 2.0 # How much it rotates (degrees)
@export var scale_intensity: float = 0.03   # How much it scales (0.05 = 5%)

# Individual axis settings for more control
@export var x_frequency: float = 0.8      # X movement frequency multiplier
@export var y_frequency: float = 1.2      # Y movement frequency multiplier  
@export var rotation_frequency: float = 0.6 # Rotation frequency multiplier
@export var scale_frequency: float = 1.4    # Scale frequency multiplier

# Phase offsets for randomization
@export var randomize_phase: bool = true
var x_phase: float
var y_phase: float
var rotation_phase: float
var scale_phase: float

# Store original values
var original_position: Vector2
var original_rotation: float
var original_scale: Vector2

func _ready():
	# Store original transform values
	original_position = position
	original_rotation = rotation_degrees
	original_scale = scale
	
	# Randomize phase offsets for variety
	if randomize_phase:
		x_phase = randf() * TAU
		y_phase = randf() * TAU
		rotation_phase = randf() * TAU
		scale_phase = randf() * TAU
	else:
		x_phase = 0
		y_phase = 0
		rotation_phase = 0
		scale_phase = 0

func _process(_delta):
	# Calculate time-based offsets using sine waves
	var time = Time.get_ticks_msec() / 1000.0 * wobble_speed
	
	# Position wobble (figure-8 style movement)
	var x_offset = sin(time * x_frequency + x_phase) * wobble_intensity
	var y_offset = cos(time * y_frequency + y_phase) * wobble_intensity * 0.7  # Slightly less Y movement
	
	# Rotation wobble (gentle spinning)
	var rotation_offset = sin(time * rotation_frequency + rotation_phase) * rotation_intensity
	
	# Scale wobble (gentle breathing effect)
	var scale_offset = sin(time * scale_frequency + scale_phase) * scale_intensity
	
	# Apply transformations
	position = original_position + Vector2(x_offset, y_offset)
	rotation_degrees = original_rotation + rotation_offset
	scale = original_scale + Vector2(scale_offset, scale_offset)
