@icon("res://addons/conductor/icons/Conductor.png")
extends AudioStreamPlayer

var bpm : float = 120
var beats_per_measure : int = 4
var first_beat_offset : float = 0

# Tracking the beat and song position
var song_position:float = 0.0
var current_beat:float = 0
var sec_per_beat:float #= 60.0 / bpm
var beat_per_sec:float
var last_reported_beat:int = -1
var last_reported_update:float = 0
var last_reported_measure:int = -1
var current_measure:int = 0

var is_playing_offset:bool = false

signal beat(position)
signal measure(position)
signal update(delta, beat_position, measure_position)

func set_song(_stream:AudioStream, _bpm:float, _beats_per_measure:int = 4, _first_beat_offset:float = 0):
	if(stream!=_stream):
		stream=_stream
		bpm=_bpm
		beats_per_measure=_beats_per_measure
		
		sec_per_beat=60.0/bpm
		beat_per_sec=bpm/60.0
		
		last_reported_beat = -1
		last_reported_update = 0
		last_reported_measure = -1
		
		song_position=0
		current_beat=0
		
		first_beat_offset = _first_beat_offset

func play_song_from_beat(beat:float):
	play(sec_per_beat*beat)
	current_beat = beat
	#song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
	song_position = sec_per_beat*beat

func play_song_with_start_offset(offset:float):
	if(offset<=0):
		play_song_from_beat(-offset)
	current_beat = -offset
	song_position = sec_per_beat*-offset
	is_playing_offset = true

func difference_to_beat_with_offset(_beat:float, offset:float):
	return abs((current_beat+(offset*beat_per_sec)) - _beat)

func _physics_process(delta: float) -> void:
	if (playing):
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix() + first_beat_offset
		song_position -= AudioServer.get_output_latency()
		current_beat = song_position / sec_per_beat
		_report_beat()
		_report_update()
	elif (is_playing_offset):
		song_position += delta
		current_beat = beat_per_sec*song_position
		_report_beat()
		_report_update()
		if(current_beat>=-first_beat_offset):
			play(0)

func _report_beat():
	if last_reported_beat < floori(current_beat):
		last_reported_beat = floori(current_beat)
		
		beat.emit(floori(current_beat))
		#print("emitting beat: " + str(floori(current_beat)))
		
		_report_measure()

func _report_measure():
	if(floori(current_beat)%beats_per_measure == 0):
		current_measure = floori(current_beat)/beats_per_measure
	
	if(last_reported_measure < current_measure):
		last_reported_measure = current_measure
		measure.emit(current_measure)
		#print("emitting measure: " + str(current_measure))

func _report_update():
	update.emit(current_beat-last_reported_update, current_beat, current_measure)
	#print("emitting update")
	last_reported_update = current_beat
