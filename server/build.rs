use std::process::Command;
use std::fs::File;
use std::io::Write;

/// The entry point for the Teos build script, which runs some additional code
/// before building the DLL. This includes modifying the assembly of the `ps_game` binary.
fn main() {
    // Set the GIT_REF environment variable
    let commit_ref_output = Command::new("git").args(&["rev-parse", "--abbrev-ref", "HEAD"]).output().unwrap();
    let git_ref = String::from_utf8(commit_ref_output.stdout).unwrap();
    println!("cargo:rustc-env=GIT_REF={}", git_ref);

    // Set the GIT_HASH environment variable
    let commit_hash_output = Command::new("git").args(&["rev-parse", "--short", "HEAD"]).output().unwrap();
    let git_hash = String::from_utf8(commit_hash_output.stdout).unwrap();
    println!("cargo:rustc-env=GIT_HASH={}", git_hash);

    // Run the assembler on the ps_game.
    assemble(git_ref, git_hash);
}

/// Run the assembler and codegen
///
/// # Arguments
/// * `hash` - The current Git hash.
fn assemble(branch: String, hash: String) {
    // Generate the assembly file with the Git information.
    let text = format!("\
        %ifndef metadata_asm\n\
        %define metadata_asm\n\
        branch_name db  \"{}\", 0\n\
        git_hash   db   \"{}\", 0\n\
        %endif\
    ", branch.trim(), hash.trim());
    let mut file = File::create("asm/metadata.asm").unwrap();
    file.write_all(text.as_bytes()).unwrap();

    // Run the assembler
    Command::new("nasm")
        .args(&["-o", "../ps_game.exe"])
        .arg("asm/game.asm")
        .status()
        .unwrap();
}