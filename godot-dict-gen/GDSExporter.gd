extends Node

func word_list() -> Array:
  var words: Dictionary = {}

  for klass: StringName in ClassDB.get_class_list():
    _process_class(klass, words)

  return(words.keys())

func _process_class(klass_name: StringName, words: Dictionary):
  words[klass_name] = true
  for enum_name in ClassDB.class_get_enum_list(klass_name, true):
    words[enum_name] = true
    for enum_value in ClassDB.class_get_enum_constants(klass_name, enum_name, true):
      words[enum_value] = true
  for method in ClassDB.class_get_method_list(klass_name, true):
    words[method['name']] = true
    for arg in method['args']:
      words[arg['name']] = true
  for property in ClassDB.class_get_property_list(klass_name, true):
    words[property['name']] = true
  for signl in ClassDB.class_get_signal_list(klass_name, true):
    words[signl['name']] = true
    for arg in signl['args']:
      words[arg['name']] = true
