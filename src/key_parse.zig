const std = @import("std");
const ghostty = @import("ghostty-vt");
const msgpack = @import("msgpack.zig");

const KeyEvent = ghostty.input.KeyEvent;
const Key = ghostty.input.Key;

// Mods isn't publicly exposed, but we need it
const Mods = packed struct(u16) {
    shift: bool = false,
    ctrl: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    sides: u4 = 0,
    _padding: u6 = 0,
};

/// Parse key from msgpack map to ghostty KeyEvent
/// Expected format: { "key": "a", "shiftKey": false, "ctrlKey": false, "altKey": false, "metaKey": false }
pub fn parseKeyMap(map: msgpack.Value) !KeyEvent {
    if (map != .map) return error.InvalidKeyFormat;

    var key_str: ?[]const u8 = null;
    var mods: Mods = .{};

    for (map.map) |entry| {
        if (entry.key != .string) continue;
        const field = entry.key.string;

        if (std.mem.eql(u8, field, "key")) {
            if (entry.value == .string) {
                key_str = entry.value.string;
            }
        } else if (std.mem.eql(u8, field, "shiftKey")) {
            if (entry.value == .boolean) mods.shift = entry.value.boolean;
        } else if (std.mem.eql(u8, field, "ctrlKey")) {
            if (entry.value == .boolean) mods.ctrl = entry.value.boolean;
        } else if (std.mem.eql(u8, field, "altKey")) {
            if (entry.value == .boolean) mods.alt = entry.value.boolean;
        } else if (std.mem.eql(u8, field, "metaKey")) {
            if (entry.value == .boolean) mods.super = entry.value.boolean;
        }
    }

    if (key_str == null) return error.MissingKey;
    const key = key_str.?;

    // Map key string to ghostty Key enum
    const key_enum = mapKeyString(key);

    return .{
        .key = key_enum,
        .utf8 = if (key_enum == .unidentified) key else "",
        .mods = @bitCast(mods),
    };
}

fn mapKeyString(key: []const u8) Key {
    // Single character -> unidentified (use utf8)
    if (key.len == 1) return .unidentified;

    // Named keys
    if (std.mem.eql(u8, key, "Enter")) return .enter;
    if (std.mem.eql(u8, key, "Tab")) return .tab;
    if (std.mem.eql(u8, key, "Backspace")) return .backspace;
    if (std.mem.eql(u8, key, "Escape")) return .escape;
    if (std.mem.eql(u8, key, " ")) return .space;
    if (std.mem.eql(u8, key, "Delete")) return .delete;
    if (std.mem.eql(u8, key, "Insert")) return .insert;
    if (std.mem.eql(u8, key, "Home")) return .home;
    if (std.mem.eql(u8, key, "End")) return .end;
    if (std.mem.eql(u8, key, "PageUp")) return .page_up;
    if (std.mem.eql(u8, key, "PageDown")) return .page_down;
    if (std.mem.eql(u8, key, "ArrowUp")) return .arrow_up;
    if (std.mem.eql(u8, key, "ArrowDown")) return .arrow_down;
    if (std.mem.eql(u8, key, "ArrowLeft")) return .arrow_left;
    if (std.mem.eql(u8, key, "ArrowRight")) return .arrow_right;

    // Function keys
    if (std.mem.eql(u8, key, "F1")) return .f1;
    if (std.mem.eql(u8, key, "F2")) return .f2;
    if (std.mem.eql(u8, key, "F3")) return .f3;
    if (std.mem.eql(u8, key, "F4")) return .f4;
    if (std.mem.eql(u8, key, "F5")) return .f5;
    if (std.mem.eql(u8, key, "F6")) return .f6;
    if (std.mem.eql(u8, key, "F7")) return .f7;
    if (std.mem.eql(u8, key, "F8")) return .f8;
    if (std.mem.eql(u8, key, "F9")) return .f9;
    if (std.mem.eql(u8, key, "F10")) return .f10;
    if (std.mem.eql(u8, key, "F11")) return .f11;
    if (std.mem.eql(u8, key, "F12")) return .f12;

    // Multi-byte UTF-8 or unknown -> use utf8 field
    return .unidentified;
}
