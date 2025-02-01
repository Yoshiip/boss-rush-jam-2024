extends Control
@onready var root: FightRoot = $"../../.."

@onready var title: RichTextLabel = $Title

func _ready() -> void:
	visible = true
		
	# skip animation in editor
	if OS.is_debug_build():
		$AnimationPlayer.speed_scale = 10.0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	root.transition_ended()
	queue_free()
