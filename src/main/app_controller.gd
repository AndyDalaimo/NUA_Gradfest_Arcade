class_name AppController
extends Control

 
@onready var app_shortcut_v_box_container: VBoxContainer = %AppShortcutVBoxContainer

@export var applications: Array[AppData]

var MAX_APPS: int
var WINDOW_SIZE: Vector2i
var root_path: String = ""
var active_pid: int = -1
var temp_pid: int = -1
var current_project_path: String
var curr_app_index: int = 0:
	set(value):
		if value >= MAX_APPS:
			value = 0
		if value < 0: 
			value = MAX_APPS-1
		curr_app_index = value

var tween: Tween

const APP_SELECT_BUTTON = preload("uid://dxyc3tx713eqr")

func _ready():
	MAX_APPS = applications.size()
	init_app_data_path()
	WINDOW_SIZE = DisplayServer.window_get_size()
	print("On Start - Window Size: ", WINDOW_SIZE)
	set_file_path(applications[curr_app_index].app_path)
	set_app_description()
	
	fill_app_select_container()

## Quit Application on SHIFT-ESC
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("EscapeArcade"):
		get_tree().quit()
	if event.is_action_pressed("RestartArcade"):
		reload_scene()

## Sets root path on initializing App
func init_app_data_path() -> void:
	root_path = OS.get_executable_path()
	var temp_path = root_path.rsplit("/", true, 1)
	root_path = temp_path[0] + "/AppData/"
	current_project_path = root_path
	print(root_path)

func set_file_path(path: String) -> void:
	init_app_data_path()
	current_project_path = current_project_path + path
	
func reload_scene() -> void:
		print_debug("Screen size: ", DisplayServer.screen_get_size())
		DisplayServer.window_set_size(WINDOW_SIZE)
		if OS.is_process_running(active_pid):
			print_debug("App running, terminating process: ", active_pid)
			OS.kill(active_pid)
		get_tree().reload_current_scene()

func next_app_data() -> void:
	if applications != null:
		curr_app_index += 1
		set_file_path(applications[curr_app_index].app_path)
		set_app_description()
		%DebugPathLabel.text = "Current Path: " + current_project_path

func previous_app_data() -> void:
	if applications != null:
		curr_app_index -= 1
		set_file_path(applications[curr_app_index].app_path)
		set_app_description()
		%DebugPathLabel.text = "Current Path: " + current_project_path

func set_app_description() -> void:
	%AppTitleLabel.text = applications[curr_app_index].app_title
	%AppSprite.texture = applications[curr_app_index].app_texture
	%AppDescriptionLabel.text = applications[curr_app_index].app_description
	## Center Screenshots
	if applications[curr_app_index].sc_1 == null and applications[curr_app_index].sc_2 == null:
		%VBoxContainer.visible = false
	else:
		%VBoxContainer.visible = true

	%SC1.texture = applications[curr_app_index].sc_1
	%SC2.texture = applications[curr_app_index].sc_2
	%QRRect.texture = applications[curr_app_index].qr_texture
	if %QRRect.texture == null:
		%ScanLabel.text = ""
	else:
		%ScanLabel.text = "Scan for this\nStudent's Work!"
	%NumberLabel.text = "%s/%s" % [curr_app_index+1, applications.size()]
	%AppTagLabel.text = applications[curr_app_index].app_tag
	%AppTagLabel.anim_tag_label()

func fill_app_select_container() -> void:
	var app_index_it = 0
	for app in applications:
		var app_button: AppSelectButton = APP_SELECT_BUTTON.instantiate()
		app_button.app_index = app_index_it
		#app_button.text = app.app_title
		app_button.icon = app.app_texture
		app_button.app_selected.connect(set_app_data)
		app_shortcut_v_box_container.add_child(app_button)
		app_index_it += 1

func set_app_data(app_index: int) -> void:
	if applications != null:
		curr_app_index = app_index
		set_file_path(applications[curr_app_index].app_path)
		set_app_description()
		%DebugPathLabel.text = "Current Path: " + current_project_path

func launch_application() -> void:
	# var output = []
	# OS.execute(current_project_path, [], output)
	if !OS.is_process_running(active_pid):
		active_pid = OS.create_process(current_project_path, [], false)
	else:
		printerr("Process already running. Attempting new Process if none active.")
		OS.kill(active_pid)
		if active_pid != -1:
			await get_tree().create_timer(2.0).timeout
			active_pid = OS.create_process(current_project_path, [], false)
		
	printerr("Active pid: ", active_pid)
	
	
	%RunButton.disabled = true
	await get_tree().create_timer(5.0).timeout
	%RunButton.disabled = false
	print("Can Run Now")
	pass
