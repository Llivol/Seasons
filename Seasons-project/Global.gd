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

const HEALTH_LOW = 2
const HEALTH_AVERAGE = 4
const HEALTH_PLAYER = 6
const HEALTH_HIGH = 8

const SIZE_SMALL = 8
const SIZE_AVERAGE = 16
const SIZE_PLAYER = 12
const SIZE_BIG = 32

const SPEED_SLOW = 50
const SPEED_AVERAGE = 100
const SPEED_FAST = 200

const DAMAGE_LOW = 1
const DAMAGE_AVERAGE = 2
const DAMAGE_HIGH = 3

const AWARENESS_SMALL = 48
const AWARENESS_AVERAGE = 96
const AWARENESS_BIG = 192

const DROP_CHANCE = 0.5

const UNIT = 16

var window_size_x
var window_size_y

func _ready():
	window_size_x = OS.get_window_size().x
	window_size_y = OS.get_window_size().y