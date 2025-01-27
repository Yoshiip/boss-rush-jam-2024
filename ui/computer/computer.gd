extends Node2D

var phase := 0

const START_TEXT := """Mission Complete!

----------

[SYSTEM] Welcome to your personal terminal!
- You have (1 NEW MESSAGE)

----------

[SYSTEM] Congratulations on completing your mission.
Your efforts have been instrumental to the company's success.
A new contract will soon be assigned to you. Until then, take this time to rest and recover.
(click to continue)
"""

const EARNINGS_TEXT := """Mission Earnings: $100,000

----------

Deductions:

- Ship Rental (Cabin)..........$1,000
- Food Supply..................$1,000
- Fuel Costs..................$10,000
- Debt Interest Repayment.....$10,000
- Ship Maintenance............$10,000
- Decontamination Fees........$67,900

- Net Balance....................$100
(click to continue)
"""

@onready var terminal_text: RichTextLabel = $Canvas/Container/TerminalText

func _ready() -> void:
	terminal_text.text = START_TEXT
	terminal_text.visible_characters = 0


var char_timer := 0.05
func _process(delta: float) -> void:
	char_timer -= delta
	if terminal_text.visible_characters < terminal_text.text.length() && char_timer <= 0.0:
		terminal_text.visible_characters += 1
		$Keyboard.pitch_scale = randf_range(0.8, 1.2)
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
			
	if Input.is_action_just_pressed("fire") && terminal_text.visible_characters == terminal_text.text.length():
		if phase == 0:
			terminal_text.text = EARNINGS_TEXT
			terminal_text.visible_characters = 0
			phase += 1
			
		elif phase == 1:
			phase += 1
			await get_tree().create_timer(0.25).timeout
			$Canvas/Container/TerminalText.visible = false
			$Canvas/Container/Upgrades.visible = true


func _on_continue_pressed() -> void:
	GameManager.save_data.level += 1;
	get_tree().change_scene_to_file("res://levels/fight/fight.tscn")
