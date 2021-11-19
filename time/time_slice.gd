class_name TimeSlice

const ADD = 4.0

var bpm = 0.0
var start = 0.0


func calculate(minutes: int, seconds: float, bpm: float):
	start = minutes * 60.0 + seconds + ADD
	self.bpm = bpm
