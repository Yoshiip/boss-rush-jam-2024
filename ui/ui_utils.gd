extends Node


const TRANSITION_DURATION := 0.5
const TEXT_APPEAR_COLOR := Color("73bed3")

func apply_transition(node: Node) -> void:
	var _base_modulates = []
	for child in node.get_children():
		if is_instance_of(child, CanvasItem):
			_base_modulates.push_front(child.modulate)
		child.modulate = child.modulate * Color.TRANSPARENT
	for i in range(node.get_child_count()):
		var child := node.get_child(i)
		if !is_instance_valid(child): return
		if is_instance_of(child, CanvasItem):
			var tween := get_tree().create_tween().set_parallel(true).bind_node(node).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			if is_instance_of(child, Label) or is_instance_of(child, RichTextLabel):
				child.visible_ratio = 0
				child.modulate = TEXT_APPEAR_COLOR * Color.TRANSPARENT
				tween.tween_property(child, "visible_ratio", 1, TRANSITION_DURATION * 0.8)
			
			tween.tween_property(child, "modulate", _base_modulates[i], TRANSITION_DURATION)
			await get_tree().create_timer(TRANSITION_DURATION * 1 / 4).timeout

func smooth_queue_free(node: CanvasItem) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(node, "modulate", node.modulate * Color.TRANSPARENT, TRANSITION_DURATION)	
	tween.tween_callback(node.queue_free)
