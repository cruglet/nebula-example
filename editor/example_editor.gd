class_name NebulaExampleEditor
extends NebulaEditor

signal file_moved(old_file: String, new_file: String)

const VIEWPORT_EMPTY: PackedScene = preload("uid://nvh4x5sxnr7f")
const EXAMPLE_LEVEL_EDITOR: PackedScene = preload("uid://cfv2s7au2hhc4")
const FILESYSTEM_DOCK: PackedScene = preload("uid://bc2m8a8pmx73i")
const TEXT_EDITOR: PackedScene = preload("uid://cjs0c72eukt3x")
const PROPERTIES: PackedScene = preload("uid://dwoslainqrwl6")

@export_group("Interface")
@export var interface: NebulaEditorInterface

@export_group("Dialogs")
@export var open_file_dialog: FileDialog

var editor: Nebula2DEditor


func _prepare_menu() -> void:
	interface.create_menu_item(&"File", "Open File", _open_file_request)
	open_file_dialog.file_selected.connect(open_file)
	
	interface.reload_menu_items()


func _prepare_docks() -> void:
	# Primary dock
	interface.get_main_dock().set_empty_scene(VIEWPORT_EMPTY)
	interface.get_main_dock().tab_close_display_policy = TabBar.CLOSE_BUTTON_SHOW_ACTIVE_ONLY
	interface.get_main_dock().fixed = true
	
	# Top Right dock
	interface.get_top_right_dock().auto_close_tabs = false
	var fs: NebulaFilesystemDock = interface.get_top_right_dock().add_scene(FILESYSTEM_DOCK, "Filesystem")
	if fs:
		fs.root = loaded_project_path
		fs.file_open_request.connect(open_file)
		fs.file_renamed.connect(_on_file_moved)
	
	# Bottom Right Dock
	interface.get_bottom_right_dock().auto_close_tabs = false
	interface.get_bottom_right_dock().hide_on_empty = true
	
	var props: NebulaEditorPropertiesDock = interface.get_bottom_right_dock().add_scene(PROPERTIES, "Properties")
	interface.get_main_dock().bind_node(props, &"Nebula2DEditor")


func _on_finish() -> void:
	interface.done()

 
func _open_file_request() -> void:
	open_file_dialog.show()


func open_file(path: String) -> void:
	var type: String = path.get_extension()
	match type:
		"json" when path.get_file().ends_with("level.json"):
			interface.get_main_dock().add_scene(EXAMPLE_LEVEL_EDITOR, path.get_basename().get_file(), true)
			return
		"txt", "json", "md":
			var text_editor: NebulaTextEditor = interface.get_main_dock().add_scene(TEXT_EDITOR, path.get_file())
			if text_editor:
				text_editor.file_path = path
				file_moved.connect(text_editor._on_file_moved)
			return
		_:
			if not DirAccess.dir_exists_absolute(path):
				Singleton.send_notification("Unknown file type", "File of type \"%s\" is not recognized in Nebula" % type)


func _on_file_moved(old_file: String, new_file: String) -> void:
	file_moved.emit(old_file, new_file)
