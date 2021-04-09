#![feature(abi_thiscall)]
#![feature(asm)]
#![feature(array_methods)]

mod config;
mod hooks;
mod models;
mod user;
mod util;

use crate::hooks::{on_console_command, on_user_connect, on_user_recv_packet, send_character_list, on_user_set_attack, send_user_details, send_summon_request};
use crate::models::{CObjectConnection, CUser, SConnection};
use chrono::{Datelike, Local, Timelike};
use lazy_static::lazy_static;
use std::ffi::{CStr, CString};
use std::fs::{File, OpenOptions};
use std::io::Write;
use std::os::raw::c_char;
use std::path::Path;
use std::sync::Mutex;
use tiberius::{AuthMethod, Client, Config};
use tokio::net::TcpStream;
use tokio::runtime::Runtime;
use tokio_util::compat::{Compat, TokioAsyncWriteCompatExt};

/// Initialise the Teos addon singleton.
lazy_static! {
    pub static ref TEOS: Mutex<Teos> = Mutex::new(Teos::new());
}

/// The Teos addon.
pub struct Teos {
    log_file: File,
    runtime: Runtime,
}

impl Teos {
    /// Initialises the Teos addon.
    pub fn new() -> Self {
        // Initialise the log file.
        let mut log_file = get_log_file();

        // Initialise the async runtime.
        let runtime = Runtime::new();
        if runtime.is_err() {
            log_file
                .write(b"Error! Failed to initialise async runtime.")
                .unwrap();
            std::process::exit(1);
        }

        Teos {
            log_file,
            runtime: runtime.unwrap(),
        }
    }

    /// Logs a message to the Teos log file.
    ///
    /// # Arguments
    /// * `text`    - The text to write.
    pub fn log(&mut self, text: String) {
        let now = Local::now();
        let message = format!(
            "{}-{:02}-{:02} {:02}:{:02}:{:02} {}\r\n",
            now.year(),
            now.month(),
            now.day(),
            now.hour(),
            now.minute(),
            now.second(),
            text
        );
        self.log_file.write(message.as_bytes()).unwrap_or(0);
    }
}

/// Get the logging file.
fn get_log_file() -> File {
    OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open("Log/PS_GAME__teos.log")
        .unwrap()
}

/// Get the SQL client instance.
pub async fn get_sql_client() -> anyhow::Result<Client<Compat<TcpStream>>> {
    let mut config = Config::new();
    config.host("localhost");
    config.authentication(AuthMethod::sql_server("sa", "password123"));
    config.trust_cert();

    let tcp = TcpStream::connect(config.get_addr()).await?;
    tcp.set_nodelay(true)?;

    Ok(Client::connect(config, tcp.compat_write()).await?)
}

/// The entry point for the Teos library. This should initialise relevant connections to the database,
/// and initialise custom heap allocated structs.
///
/// # Arguments
/// * `cuser_size_addr` - The address to store the size of the CUser structure.
#[no_mangle]
pub extern "stdcall" fn startup(
    cuser_size_addr: *mut usize,
    cuser_connect_addr: *mut usize,
    cuser_packet_addr: *mut usize,
    console_command_addr: *mut usize,
    send_char_list_addr: *mut usize,
    cuser_set_attack_addr: *mut usize,
    cuser_send_details_addr: *mut usize,
    cuser_summon_addr: *mut usize,
) {
    // Initialise the Teos addon.
    let mut teos = TEOS.lock().unwrap();
    teos.log("============ Initialise Teos addon ============".to_string());

    // Initialise the function hooks.
    unsafe {
        let cuser_size = std::mem::size_of::<CUser>();
        *cuser_size_addr = cuser_size;
        teos.log(format!(
            "Modified CUser struct to occupy {} bytes ({:#X})",
            cuser_size, cuser_size
        ));

        *cuser_connect_addr = on_user_connect as usize;
        teos.log(format!(
            "Initialised on_user_connect to {:#X}",
            *cuser_connect_addr as usize
        ));

        *cuser_packet_addr = on_user_recv_packet as usize;
        teos.log(format!(
            "Initialised on_user_recv_packet to {:#X}",
            *cuser_packet_addr as usize
        ));

        *console_command_addr = on_console_command as usize;
        teos.log(format!(
            "Initialised on_console_command to {:#X}",
            *console_command_addr as usize
        ));

        *send_char_list_addr = send_character_list as usize;
        teos.log(format!(
            "Initialised send_character_list to {:#X}",
            *send_char_list_addr as usize
        ));

        *cuser_set_attack_addr = on_user_set_attack as usize;
        teos.log(format!(
            "Initialised on_user_set_attack to {:#X}",
            *cuser_set_attack_addr as usize
        ));

        *cuser_send_details_addr = send_user_details as usize;
        teos.log(format!(
            "Initialised send_user_details to {:#X}",
            *cuser_send_details_addr as usize
        ));

        *cuser_summon_addr = send_summon_request as usize;
        teos.log(format!(
            "Initialised send_summon_request to {:#X}",
            *cuser_summon_addr as usize
        ));
    }

    // Initialise the Teos systems.
    if let Err(e) = init(&mut teos) {
        teos.log("Fatal error! Failed to initialise Teos addon.".to_string());
        teos.log(format!("Error = {:}", e));
        std::process::exit(1);
    }
}

fn init(teos: &mut Teos) -> anyhow::Result<()> {
    teos.log("ok g".to_string());
    Ok(())
}
