<img align="right" alt="Teos logo" width="100" src="../etc/logo.png">

# Shaiya Teos
A project which aims to modify the original Ep4 Shaiya files in order to provide modern
functionality.

## Prerequisites
* [Rust (nightly-i686-pc-windows-msvc)][rust] (can be installed via [Rustup][rustup])
* [NASM][nasm]

## Building
Shaiya Teos uses Cargo for building (this is included with Rust by default). To build the full
project, you can run `cargo build` in the root directory to build the project. This will also
run the buildscript for each project, which also invokes [NASM][nasm] to modify the binaries.

[nasm]: https://nasm.us
[rust]: https://www.rust-lang.org/
[rustup]: https://rustup.rs/