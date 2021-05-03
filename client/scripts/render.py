nameSymbol(0x2261C28, "g_textClient") # Not 100% sure what this is, but it's used as a constant in drawing text.

nameFunc(0x54EE00, "drawString", return_type="u32", args=[("text_client", "f32"), ("x", "u32"), ("y", "u32"), ("r", "u8"), ("g", "u8"), ("b", "u8"), ("a", "u8"), ("text", "string")])
nameFunc(0x412B50, "playAnimation", return_type="u32", args=[("anim_id","u32")])
nameFunc(0x4508F0, "renderEffect", return_type="f32", args=[("effect_id", "u32"),("scene_id", "u32"),("x","f32"),("y","f32"),("z","f32"),("unknown","u8")])