use std::process::Command;

/// The entry point for the Teos build script, which runs some additional code
/// before building the DLL. This includes modifying the assembly of the `ps_game` binary.
fn main() {
    // Run the assembler on the ps_game.
    Command::new("nasm")
        .args(&["-o", "ps_game.exe"])
        .arg("asm/game.asm")
        .status()
        .unwrap();
}