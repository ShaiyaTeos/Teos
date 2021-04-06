use std::process::Command;
use std::fs::File;
use std::io::Write;

/// The entry point for the Teos build script, which runs some additional code
/// before building the DLL. This includes modifying the assembly of the `game` binary.
fn main() {
    // Run the assembler
    Command::new("nasm")
        .args(&["-o", "../game.exe"])
        .arg("asm/client.asm")
        .status()
        .unwrap();
}