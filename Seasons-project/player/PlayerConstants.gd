extends Node

# Member variables
const GRAVITY = 2250 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1000
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 250
const STOP_FORCE = 5000
const JUMP_SPEED = 500
const JUMP_MAX_AIRBORNE_TIME = 0.01

const SLIDE_STOP_VELOCITY = 0.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 0.0 # one pixel

enum PlayerStates {
	idle,		#0
	walk,		#1
	jump,		#2
	hover		#3
	falling		#4
}