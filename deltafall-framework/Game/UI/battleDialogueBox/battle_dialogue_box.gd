extends Control

@onready var label = $box/label
@export var text: String = "":
	set(value):
		text = value
		call_deferred("resetTextState")
		
var finished_text_on_turn = false
var allowedToShow:bool=false

func battleStarted():
	await get_tree().create_timer(1).timeout
	allowedToShow=true

func _physics_process(delta:float)->void :
	#if gamesystem.battle_data.battle_start: # this should've been a signal
	#	active_delay -= delta
	
	if allowedToShow:
		var current_lines = label.get_visible_line_count()-1
		#$Label.text = str(current_lines)
		#$Label2.text = str(label.visible_characters)
		
		#$box.size.y = lerp($box.size.y, (63 + (63 / 3.7) * current_lines), delta / 0.2)
		$box.size.y = lerp($box.size.y, (label.position.y * 2 + label.size.y + 3.7), delta / 0.2)
		# a line is 63 pixels + offset (63 / 3.7)
		# $color.margin_bottom = $box.margin_bottom
		# $Position2D.position.y = $box.margin_bottom
		# tracks all the stuff to be the same
		
		# gamesystem.battle_data.flavor_text_anchor_down_pos = $Position2D.global_position
		# dont know what this does
		
		
		#if gamesystem.battle_data.battle_state.PLAYER_ATTACK or gamesystem.battle_data.battle_state.ENEMY_ATTACK:
		#	finished_text_on_turn = false
		#elif gamesystem.battle_data.battle_state.PLAYER_TURN:
		#	showAllChar()
		
		#　if last_flavour_text != text:
		#　	resetTextState()
		#　	label.bbcode_text = text
		#　	last_flavour_text = text
			
		#if finished_text_on_turn: showAllChar()
		
		#label.visible_characters += 2
		label.visible_characters += (text.length()-label.visible_characters)+2-abs(text.length()-label.visible_characters)
		#label.visible_characters += (text.length()-label.visible_characters+2)
		
		#@print(label.visible_characters)
		
		if label.visible_characters < text.length():
			if not finished_text_on_turn:
				pass
			$sfx.play()
			# idk why he did this
			# gamesystem.battle_data.flavor_text_finished = false
		else :
			finished_text_on_turn = true
			#gamesystem.battle_data.flavor_text_finished = true
				
		#if gamesystem.battle_data.current_battle_state == gamesystem.battle_data.battle_state.PLAYER_TURN or gamesystem.battle_data.current_battle_state == gamesystem.battle_data.battle_state.PLAYER_ATTACK and $Label.text != "":
		#	
		#	box_color_scale = 2
		#	if just_started == false: just_started = true
		#	
		#	$box.modulate = Color.white
		#	$color.modulate = Color.white
		#	$box.rect_scale += (Vector2.ONE - $box.rect_scale) * 0.2
		#	$color.rect_scale += (Vector2.ONE - $color.rect_scale) * 0.2
		#	
		#	position = position.linear_interpolate(Vector2.ZERO, delta * 10)
		#	
		#	if get_parent().get_parent().get_node("ui").current_state == get_parent().get_parent().get_node("ui").states.CHAR_ACTION_SELECT:
		#		inside_main_selection = true
		#		inside_char_submenu = false
		#	else :
		#		inside_char_submenu = true
		#		inside_main_selection = false
		#		
		#	if inside_main_selection:
		#		text = str(gamesystem.battle_data.scene_flavour_text)
		#	else :
		#		text = str(gamesystem.battle_data.flavor_text)
		#			
		#else :
	#
	
	
	
			# just_started = false
			# position.y += ( - 170 - position.y) * 0.2
			# var c = Color(1, 1, 1, (sin(OS.get_ticks_msec() * delta * 15) * 1) * box_color_scale)
			# box_color_scale /= 1.1
			# $box.modulate = c
			# $color.modulate = c
	
func showAllChar():
	label.visible_characters = text.length()

func resetTextState():
	label.visible_characters = 0
	label.text = text
