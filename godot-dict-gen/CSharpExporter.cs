using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using Godot;

namespace GodotDictGen;

[GlobalClass]
public partial class CSharpExporter : Node
{

  public string[] WordList()
  {
    Assembly asm = Assembly.Load("GodotSharp");

    return asm.GetTypes()
              .SelectMany(ProcessClass)
              .Select(StripPrefixes)
              .Distinct()
              .ToArray();

  }

  private List<string> ProcessClass(Type cls)
  {
    var members = cls.GetMembers().Select((MemberInfo m) => m.Name);

    return [cls.Name, .. members];
  }

  private string StripPrefixes(string member) => member.TrimPrefix("get_").TrimPrefix("set_");
}
