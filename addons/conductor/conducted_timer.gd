@icon("res://addons/conductor/icons/Timer.png")
class_name ConductedTimer
extends Node

@export var wait_beats:float = 1.0:
	get = get_wait_beats,
	set = set_wait_beats
func get_wait_beats():
	return wait_beats
func set_wait_beats(value:float):
	wait_beats = value

@export var round_start_beat:bool = false:
	get = is_round_start_beat,
	set = set_round_start_beat
func is_round_start_beat():
	return round_start_beat
func set_round_start_beat(value:bool):
	round_start_beat = value

@export var one_shot:bool = false:
	get = is_one_shot,
	set = set_one_shot
func is_one_shot():
	return one_shot
func set_one_shot(value:bool):
	one_shot = value

@export var autostart:bool = false:
	get = has_autostart,
	set = set_autostart
func has_autostart():
	return autostart
func set_autostart(value:bool):
	autostart = value

var paused:bool = false:
	get = is_paused,
	set = set_paused
func is_paused():
	return paused
func set_paused(value:bool):
	paused = value

var time_left:float = -100:
	get = get_time_left
func get_time_left():
	return time_left

var _start_time:float

signal timeout

func _ready() -> void:
	Conductor.update.connect(_update)
	if(autostart):
		start(wait_beats)
	else:
		time_left = -100

func is_stopped():
	if(paused):
		return true
	if(time_left == -100):
		return true

func start(beats:float=wait_beats):
	wait_beats = beats
	if(round_start_beat):
		time_left = wait_beats - (Conductor.current_beat - roundi(Conductor.current_beat))
		_start_time = roundi(Conductor.current_beat)
	else:
		time_left = wait_beats
		_start_time = Conductor.current_beat

func stop():
	time_left = -100

func _update(delta, _pos, _measure):
	if(paused):
		return
	
	if(time_left == -100):
		return
	
	if(time_left>=0):
		time_left-=delta
	elif(time_left<=0):
		timeout.emit()
		if(one_shot):
			time_left = -100
		else:
			#start(wait_beats)
			_start_time = _start_time+wait_beats
			time_left = wait_beats - (Conductor.current_beat - _start_time)
