@icon("res://addons/conductor/icons/AnimationPlayer.png")
class_name ConductedAnimationPlayer
extends AnimationPlayer

@export var round_start_beat:bool = false
var start_beat:float

func _ready() -> void:
	Conductor.update.connect(_update)

func _update(delta,_beat_pos,_measure_pos):
	if(is_playing()):
		seek((Conductor.current_beat-start_beat)*speed_scale,true,false)

func play(name: StringName = &"", custom_speed: float = speed_scale, custom_blend: float = -1, from_end: bool = false):
	if(round_start_beat):
		start_beat = roundi(Conductor.current_beat)
	else:
		start_beat = Conductor.current_beat
	current_animation = name
	speed_scale = custom_speed
