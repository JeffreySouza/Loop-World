extends Control

onready var output_list = get_node("OutputList")
onready var input_list = get_node("InputList")

func _ready():
	for item in AudioServer.get_device_list():
		output_list.add_item(item)

	var output_device = AudioServer.get_device()
	for i in range(output_list.get_item_count()):
		if output_device == output_list.get_item_text(i):
			output_list.select(i)
			break

	for item in AudioServer.capture_get_device_list():
		input_list.add_item(item)

	var input_device = AudioServer.capture_get_device()
	for i in range(input_list.get_item_count()):
		if input_device == input_list.get_item_text(i):
			input_list.select(i)
			break


func _process(_delta):
	var speaker_mode_text = "Stereo"
	var speaker_mode = AudioServer.get_speaker_mode()

	if speaker_mode == AudioServer.SPEAKER_SURROUND_31:
		speaker_mode_text = "Surround 3.1"
	elif speaker_mode == AudioServer.SPEAKER_SURROUND_51:
		speaker_mode_text = "Surround 5.1"
	elif speaker_mode == AudioServer.SPEAKER_SURROUND_71:
		speaker_mode_text = "Surround 7.1"

	$OutputDeviceInfo.text = "Current Output Device: " + AudioServer.get_device() + "\n"
	$OutputDeviceInfo.text += "Speaker Mode: " + speaker_mode_text
	
	$InputDeviceInfo.text = "Current Input Device: " + AudioServer.capture_get_device() + "\n"


func _on_Play_Audio_button_down():
	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
		$PlayAudio.text = "Play Audio"
	else:
		$AudioStreamPlayer.play()
		$PlayAudio.text = "Stop Audio"


func _on_SetOutputDevice_pressed():
	for item in output_list.get_selected_items():
		var device = output_list.get_item_text(item)
		AudioServer.set_device(device)


func _on_SetInputDevice_pressed():
	for item in input_list.get_selected_items():
		var device = input_list.get_item_text(item)
		print(device)
		AudioServer.capture_set_device(device)


func _on_Done_pressed():
	queue_free()
