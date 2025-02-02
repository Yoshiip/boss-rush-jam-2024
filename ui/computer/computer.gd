extends Node2D

var phase := 0

const START_TEXT := """Mission Complete!

----------

[SYSTEM] Welcome to your personal terminal!
- You have (1 NEW MESSAGE)

----------

[SYSTEM] Congratulations on completing your mission.
To reward you for your efforts, you have been credited with 5 research points for your ship. Use them as you see fit!
A new contract will soon be assigned to you. Until then, take this time to rest and recover.
(click to continue)
"""


@onready var terminal_text: RichTextLabel = $Canvas/Container/TerminalText

func _generate_earning(amount: float) -> String:
	var deductions := {
		"Ship Rental (Cabin)": 0.014,
		"Food Supply": 0.016,
		"Fuel Costs": 0.078,
		"Debt Interest Repayment": 0.1,
		"Ship Maintenance": 0.13,
		"Decontamination Fees": 0.662
	}
	
	var result := "Mission Earnings: $%d\n\n----------\n\nDeductions:\n\n" % int(amount)
	
	var max_length = 30
	
	for key in deductions.keys():
		var deduction_value = int(amount * deductions[key])
		var dots = ".".repeat(max_length - key.length())
		result += "- %s%s$%d\n" % [key, dots, deduction_value]
	result += "\nNet Earnings: $1"
	result += "\n(click to continue)"
	
	return result



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	terminal_text.text = START_TEXT
	terminal_text.visible_characters = 0


const AMOUNTS := [
	26430.0,
	43312.0,
	95418.0,
	111065.0,
	208764.0,
]

var char_timer := 0.05
const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

func _process(delta: float) -> void:
	char_timer -= delta
	var skipping := Input.is_action_pressed("fire")
	if terminal_text.visible_characters < terminal_text.text.length() && char_timer <= 0.0:
		terminal_text.visible_characters += 1
		$Keyboard.pitch_scale = randf_range(0.8, 1.2)
		if not skipping:
			$Keyboard.play()
		var current_character := terminal_text.text[terminal_text.visible_characters - 1]
		match current_character:
			":":
				char_timer = 0.25
			"\n":
				char_timer = 0.25
			".":
				char_timer = 0.1
			"!":
				char_timer = 0.15
			"-":
				char_timer = 0.1
			_:
				char_timer = 0.05
		if skipping:
			char_timer *= 0.1
			
	if Input.is_action_just_pressed("fire") && terminal_text.visible_characters == terminal_text.text.length():
		if phase == 0:
			terminal_text.text = _generate_earning(AMOUNTS[GameManager.save_data.level])
			terminal_text.visible_characters = 0
			phase += 1
			
		elif phase == 1:
			phase += 1
			
			set_process(false)
			$Canvas/Container/TerminalText.visible = false
			$Canvas/Container/Shader.visible = false
			
			dialogue = DIALOGUE.instantiate()
			var arr: Array[String]
			arr.assign(GameDialogues.MISSIONS[GameManager.save_data.level])
			dialogue.dialogue = arr
			dialogue.event.connect(_on_dialogue_event)
			dialogue.ended.connect(_on_dialogue_ended)
			$Canvas/Container.add_child(dialogue)
		
var dialogue: Dialogue
func _on_dialogue_event(id: String) -> void:
	match id:
		"switch_to_chief":
			dialogue.set_other("Chief", MAN_TEXTURE)
		"switch_to_mysterious":
			dialogue.set_other("???", PHONE_TEXTURE)

const MAN_TEXTURE = preload("res://ui/dialogue/portraits/man.jpg")
const PHONE_TEXTURE = preload("res://ui/dialogue/portraits/phone.jpg")

func _on_dialogue_ended() -> void:
	GameManager.save_data.level += 1
	GameManager.save_data.points += 5
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
