class_name NebulaExampleEditor
extends NebulaEditor

const VIEWPORT_EMPTY: PackedScene = preload("uid://nvh4x5sxnr7f")
const EXAMPLE_LEVEL_EDITOR: PackedScene = preload("uid://cfv2s7au2hhc4")
const FILESYSTEM_DOCK: PackedScene = preload("uid://bc2m8a8pmx73i")
const TEXT_EDITOR: PackedScene = preload("uid://cjs0c72eukt3x")

@export_group("Interface")
@export var interface: NebulaEditorInterface

@export_group("Dialogs")
@export var open_file_dialog: FileDialog

var editor: Nebula2DEditor


func _prepare_menu() -> void:
	interface.create_menu_item(&"File", "Open File", _open_file_request)
	open_file_dialog.file_selected.connect(_on_file_selected)
	
	interface.reload_menu_items()


func _prepare_docks() -> void:
	interface.get_main_dock().set_empty_scene(VIEWPORT_EMPTY)
	var fs: NebulaFilesystemDock = interface.get_secondary_dock().add_scene(FILESYSTEM_DOCK, "Filesystem")
	fs.root = loaded_project_path
	fs.file_open_request.connect(_on_project_file_open_request)



func _open_file_request() -> void:
	open_file_dialog.show()

func _on_file_selected(path: String) -> void:
	#ExampleLevelLoader.parse_level_file(path)
	interface.get_main_dock().add_scene(EXAMPLE_LEVEL_EDITOR, path.get_basename().get_file(), true)


func _on_project_file_open_request(path: String) -> void:
	var type: String = path.get_extension()
	
	match type:
		"txt", "json", "md":
			var text_editor: NebulaTextEditor = interface.get_main_dock().add_scene(TEXT_EDITOR, path.get_file())
			text_editor.file_path = path
		_:
			Singleton.send_notification("Unknown file type", "File of type \"%s\" is not recognized in Nebula" % type)
