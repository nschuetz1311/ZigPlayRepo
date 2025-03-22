const std = @import("std");
const uefi = std.os.uefi;
// this maps the function utf8ToUtf16LeStringLiteral to the variable utf16
const utf16 = std.unicode.utf8ToUtf16LeStringLiteral;

pub fn main() uefi.Status {
    const sys_table = uefi.system_table;
    // conout is an optional so therfore we have to make sure that the null case is handled properly
    const conout = sys_table.con_out orelse return uefi.Status.load_error;
    const conin = sys_table.con_in orelse return uefi.Status.load_error;
    const boot_services = sys_table.boot_services orelse return uefi.Status.load_error;

    var Status = uefi.Status.success;
    var index: usize = undefined;
    var input_key: uefi.protocol.SimpleTextInputEx.Key.Input = undefined;

    Status = conout.clearScreen();
    if (Status != uefi.Status.success) {
        return Status;
    }

    // _ = is used to ignore the return value as Zig does not accept untreated return values
    _ = conout.outputString(utf16("Hello World ! \n"));

    const input_events = [_]uefi.Event{
        conin.wait_for_key,
    };

    while (boot_services.waitForEvent(input_events.len, &input_events, &index) == uefi.Status.success) {
        if (index == 0) {
            if (conin.readKeyStroke(&input_key) == uefi.Status.success) {
                if (input_key.unicode_char == @as(u16, 'Q')) {
                    return uefi.Status.success;
                }
                const slice: [*:0]const u16 = &[_:0]u16{input_key.unicode_char};
                _ = conout.outputString(slice);
            }
        }
    }

    return uefi.Status.success;
}
