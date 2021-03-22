use std::process::Command;
use std::fs::File;
use std::io::Write;

/// The entry point for the Teos build script, which runs some additional code
/// before building the DLL. This includes modifying the assembly of the `ps_game` binary.
fn main() {
    // Set the GIT_HASH environment variable
    let output = Command::new("git").args(&["rev-parse", "HEAD"]).output().unwrap();
    let git_hash = String::from_utf8(output.stdout).unwrap();
    println!("cargo:rustc-env=GIT_HASH={}", git_hash);

    // Run the assembler on the ps_game.
    assemble(git_hash);
}

/// Run the assembler and codegen
///
/// # Arguments
/// * `hash` - The current Git hash.
fn assemble(hash: String) {
    // Generate the assembly file with the Git information.
    let text = format!("\
        %ifndef metadata_asm\n\
        %define metadata_asm\n\
        git_hash   db   '{}', 0\n\
        %endif\
    ", hash.trim());
    let mut file = File::create("asm/metadata.asm").unwrap();
    file.write_all(text.as_bytes()).unwrap();

    // Run the assembler
    Command::new("nasm")
        .args(&["-o", "ps_game.exe"])
        .arg("asm/game.asm")
        .status()
        .unwrap();
}