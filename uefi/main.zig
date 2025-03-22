const std = @import("std");
const uefi = std.os.uefi;
// this maps the function utf8ToUtf16LeStringLiteral to the variable utf16
const utf16 = std.unicode.utf8ToUtf16LeStringLiteral;

pub fn main() uefi.Status {
    const sys_table = uefi.system_table;
    // conout is an optional so therfore we have to make sure that the null case is handled properly
    const conout = sys_table.con_out orelse return uefi.Status.load_error;

    var Status = uefi.Status.success;

    Status = conout.clearScreen();
    if (Status != uefi.Status.success) {
        return Status;
    }
    // _ = is used to ignore the return value as Zig does not accept untreated return values
    _ = conout.outputString(utf16("Hello World ! \n"));

    return uefi.Status.success;
}
