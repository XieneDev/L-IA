extends CanvasLayer

const levels = [
	"res://Scenes/Tutorial/Walking.tscn",
	"res://Scenes/Tutorial/Jumping.tscn",
	"res://Scenes/Challenges/Challenge1.tscn",
	"res://Scenes/Tutorial/Shooting0.tscn",
	"res://Scenes/Tutorial/Shooting1.tscn",
	"res://Scenes/Tutorial/Doors.tscn",
	"res://Scenes/Challenges/Challenge1.25.tscn",
	"res://Scenes/Tutorial/Shooting.tscn",
	"res://Scenes/Challenges/Challenge3.tscn",
	"res://Scenes/Challenges/Challenge1.5.tscn",
	"res://Scenes/Tutorial/Plates1.tscn",
	"res://Scenes/Challenges/Challenge2.tscn",
	"res://Scenes/Puzzles/Plates2.tscn",
	"res://Scenes/Challenges/Challenge4.tscn",
	"res://Scenes/Tutorial/InvertedDoor0.tscn",
	"res://Scenes/Challenges/Challenge5.tscn",
	"res://Scenes/Puzzles/InvertedDoor1.tscn",
	"res://Scenes/Challenges/Challenge5.5.tscn",
	"res://Scenes/Puzzles/MultipleDoors1.tscn",
	"res://Scenes/Challenges/Challenge7.tscn",
	"res://Scenes/Challenges/Challenge6.tscn",
	
	"res://Scenes/PreGG.tscn",
	"res://Scenes/GG.tscn"
]

var current_level : int = 0
var current_scene
var next_level : int
var next_scene


onready var animation_player := $AnimationPlayer


func goto_next_level() -> void:
	load_level(current_level+1)


func load_level(level: int) -> void:
	animation_player.play("FadeIn")
	next_level = level
	next_scene = load(levels[level])


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeIn":
		current_level = next_level
		get_tree().change_scene_to(next_scene)
		yield(get_tree(), "idle_frame")
		
		animation_player.play("FadeOut")
		
		Globals.reset_state()
		Globals.new_level()
		current_scene = get_tree().current_scene
		for child in current_scene.get_children():
			if child is TileMap:
				TileManager.open(child)
				break
