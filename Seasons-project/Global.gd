extends Node

const COLOR_LIGHT_BLUE = Color("#41a6f6")
const COLOR_BLUE = Color("#3b5dc9")
const COLOR_DARK_BLUE = Color("#29366f")
const COLOR_RED = Color("#b13e53")
const COLOR_ORANGE = Color("#ef7d57")
const COLOR_YELLOW = Color("#ffcd75")
const COLOR_LIGHT_GREEN = Color("#a7f070")
const COLOR_GREEN = Color("#38b764")
const COLOR_DARK_GREEN = Color("#257179")

const HEALTH_LOW = 2.0
const HEALTH_AVERAGE = 4.0
const HEALTH_PLAYER = 6.0
const HEALTH_HIGH = 8.0

const SIZE_SMALL = 8.0
const SIZE_AVERAGE = 16.0
const SIZE_PLAYER = 12.0
const SIZE_BIG = 32.0

const SPEED_SLOW = 25.0
const SPEED_AVERAGE = 50.0
const SPEED_FAST = 100.0

const DAMAGE_LOW = 1.0
const DAMAGE_AVERAGE = 2.0
const DAMAGE_HIGH = 3.0

const AWARENESS_SMALL = 24.0
const AWARENESS_AVERAGE = 48.0
const AWARENESS_BIG = 96.0

const DROP_CHANCE = 1

const UNIT = 16

var window_size_x
var window_size_y

func _ready():
	window_size_x = OS.get_window_size().x
	window_size_y = OS.get_window_size().y