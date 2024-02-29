extends Control

@export var _output: TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  output("Generating GDScript dictionaries")
  var gds_list = %GDSExporter.word_list()
  output("Extracted %s unique entries" % gds_list.size())

  output("Generating C# dictionaries")
  var csharp_list = %CSharpExporter.WordList()
  output("Extracted %s unique entries" % csharp_list.size())

  var gds_file: String = await filepath("GDScript");
  output("Exporting GDS Script dictionary to %s" % gds_file)
  export_list(gds_list, gds_file)

  await get_tree().process_frame

  var csharp_file: String = await filepath("CSharp");
  output("Exporting CSharp Script dictionary to %s" % csharp_file)
  export_list(csharp_list, csharp_file)


func export_list(list: Array, path: String) -> void:
  var file = FileAccess.open(path, FileAccess.WRITE)

  for word in list:
    file.store_line(word)

  file.close();

func output(line: String) -> void:
  print(line)
  _output.insert_line_at(_output.get_line_count()-1, line)


func filepath(type: String) -> String:
  # Try command line arguments first
  for arg in OS.get_cmdline_args():
    if arg.begins_with("%s=" % type):
      return extract_path(arg)

  # Fall back to a prompt
  var file = (%FileDialog as FileDialog)
  file.title = "Save %s dictionary" % type
  file.popup_centered_ratio(0.9)
  file.visible = true
  output("Awaiting %s" % type)
  var result: String =  await file.file_selected

  return result

func extract_path(arg: String) -> String:
  return arg.split('=',1)[1]
