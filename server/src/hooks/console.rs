use std::os::raw::c_char;
use std::ffi::CString;

/// Gets executed when a console command is sent from the psAgent.
///
/// # Arguments
/// * `text`    - The pointer to the input text.
/// * `len`     - The length of the input text.
/// * `output`  - A pointer to where the output text should be stored.
pub extern "stdcall" fn on_console_command(text: *mut u8, len: usize, output: *mut u8) -> bool {
    unsafe {
        let input = String::from_raw_parts(text, len - 1, len - 1);
        if input.trim() != "/hello" {
            return false;
        }

        // Write the output text
        copy_to_output("hello friend xd", output);
        true
    }
}

/// Copies a string to an output destination.
///
/// # Arguments
/// * `output`  - The output text.
/// * `dest`    - The address to write the text.
unsafe fn copy_to_output(output: &str, dest: *mut u8) {
    let text = CString::new(output);
    if let Ok(output) = text {
        let mut bytes = output.as_bytes_with_nul();
        for i in 0..bytes.len() {
            *dest.offset(i as isize) = bytes[i];
        }
    }
}