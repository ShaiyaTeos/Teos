use crate::models::CUser;
use crate::util::TeosLogger;
use crate::{get_sql_client, user, TEOS};
use byteorder::{BigEndian, ByteOrder, LittleEndian};
use std::sync::Arc;
use std::time::Duration;

/// The maximum packet size
const MAXIMUM_PACKET_SIZE: usize = 2046;

/// Gets executed when a user connects to the game world.
///
/// # Arguments
/// * `user`    - The loaded character instance.
pub extern "stdcall" fn on_user_connect(user: *mut CUser) {}

/// Gets executed when the server receives a packet from the user. If this function returns
/// true, the original packet processing function will return and not operate on this packet.
///
/// # Arguments
/// * `user`    - The user instance.
/// * `packet`  - The packet payload.
pub extern "stdcall" fn on_user_recv_packet(user: *mut CUser, packet: *mut u8) -> bool {
    unsafe {
        let data = Vec::from_raw_parts(packet, MAXIMUM_PACKET_SIZE, MAXIMUM_PACKET_SIZE);
        let payload = data.as_slice();

        let opcode = LittleEndian::read_u16(payload);
        let mut teos = TEOS.lock().unwrap();
        teos.log(format!("recv opcode {:#X}", opcode));

        if opcode == 0x030A || opcode == 0x0309 {
            return true;
        }
    }

    false
}

/// Sends the character list for a given user.
///
/// # Arguments
/// * `user`    - The user instance.
pub extern "stdcall" fn send_character_list(user: *const CUser) -> bool {
    let mut teos = TEOS.lock().unwrap();
    let rt = &teos.runtime;
    let user = unsafe { user.as_ref().unwrap() };

    rt.spawn(async move {
        let client = get_sql_client().await;
        client.log_error();

        if let Ok(sql) = client {
            let result = user::send_character_list(user, sql).await;
            result.log_error();
        }
    });

    true
}
