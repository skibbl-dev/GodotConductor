# GodotConductor
A simple addon for syncing game events to the music.

# Conductor Autoload/Global:
When enabling the plugin, it should automatically add the Conductor script to the Globals/Autoload section. If it doesn't, disable and re-enable the plugin.
The conductor has a few handy functions and signals

## Conductor Functions:

### set_song(stream:AudioStream, bpm:float, beats_per_measure:int = 4, first_beat_offset:float = 0):
This sets the Conductor audio, bpm, and first beat offset.

stream = song audio stream,

bpm = song beats per minute,

beats_per_measure = how many beats are in every measure (top number of time signurature),

first_beat_offset = how much time (seconds, not beats) passes before the first beat happens.


### play_song_from_beat(beat:float):
This function starts playing the song, at the specified beat.


### play(from_position: float = 0.0):
This function starts playing the song, at the specified time (seconds). Leave blank to start at the beginning.


### play_song_with_start_offset(offset:float):
This function starts playing the song with an offset. The offset is in beats, and will stil emit beat, measure, and update signals. once the specified amount of beats passes, then the song will start playing (at beat 0)

#### example:
play_song_with_start_offset(4)
#starts playing at -4, until it reaches 0 when the song starts playing.

### difference_to_beat_with_offset(_beat:float, offset:float):
This function gives the difference (in beats) from the current beat to a given beat, with a given offset (in seconds)

#### example:
if difference_to_beat_with_offset(3, 0.03) <= 0.2:
  print("you hit the note!")
# this will print if you hit within 0.2 beats of beat 3, and a given offset of 0.03 seconds.

## Conductor Signals:
To add a signal to a script, use Conductor.SIGNAL_NAME.connect(FUNC_NAME), where SIGNAL_NAME is the signal you want to connect (i.e. beat), and FUNC_NAME is the function you want to call.
### beat(position)
this signal gets called once every beat. The position variable is set to the current beat


### measure(position)
this signal gets called once at the start of every measure. The position variable is set to which measure it is.


### update(delta, beat_position, measure_position)
this signal gets called once at the start of every measure. The position variable is set to which measure it is.

# New Nodes:
## ConductedTimer:
i was too lazy to write at the time

Works like the normal timer, but It's to the beat.
Round start beat makes it so if you say ConductedTimer.start() at "1.1" beats, it'll round to 1

## ConductedAnimationPlayer:
Works similar to the normal AnimationPlayer, has some limited functionality.

1 second in timeline = 1 beat
Round start beat makes it so if you say ConductedTimer.start() at "1.1" beats, it'll round to 1

If you use call functions, it will repeatedly call the same function unless you put code to disable.

## Quick Tutorial:
i was too lazy to write at the time
