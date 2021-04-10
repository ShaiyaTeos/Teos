use crate::models::CUser;
use crate::util::TeosLogger;
use crate::{get_sql_client, user, TEOS};
use byteorder::{BigEndian, ByteOrder, LittleEndian};
use std::sync::Arc;
use std::time::Duration;
use crate::models::packets::{CharacterAdditionalStats, SummonRequest};
use crate::util::types::FixedLengthArray;

/// The maximum packet size
const MAXIMUM_PACKET_SIZE: usize = 2046;

/// Gets executed when the user's stats are updated.
///
/// # Arguments
/// * `user`    - The character instance.
pub extern "stdcall" fn on_user_set_attack(user: *mut CUser) {
    let char = unsafe { user.as_ref().unwrap() };
    let mut additional_stats = CharacterAdditionalStats::new();

    // The "yellow stats" are equal to the total stat, less the base stat.
    additional_stats.yellow_strength = 1;
    additional_stats.yellow_dexterity = 2;
    additional_stats.yellow_reaction = 3;
    additional_stats.yellow_intelligence = 4;
    additional_stats.yellow_wisdom = 5;
    additional_stats.yellow_luck = 6;

    additional_stats.min_physical_attack = 123;
    additional_stats.max_physical_attack = 456;
    additional_stats.min_magic_attack = 234;
    additional_stats.max_magic_attack = 567;
    additional_stats.defense = 333;
    additional_stats.resistance = 444;
    char.send(&additional_stats);
}

/// Send the user's details.
///
/// # Arguments
/// * `user`    - The user instance.
pub extern "stdcall" fn send_user_details(user: *mut CUser) {
    let char = unsafe { user.as_ref().unwrap() };
}

/// Sends a summon request packet from a user, to a target player.
///
/// # Arguments
/// * `user`    - The user sending the packet..
/// * `target`  - The player who should receive the summon request.
pub extern "stdcall" fn send_summon_request(user: *mut CUser, target: *mut CUser) {
    let user = unsafe { user.as_ref().unwrap() };
    let target = unsafe { target.as_ref().unwrap() };

    let mut packet = SummonRequest::new();
    packet.id = user.info.char_id;
    packet.map = user.info.map;
    target.send(&packet);
}

/// Gets executed when a user connects to the game world.
///
/// # Arguments
/// * `user`    - The loaded character instance.
pub extern "stdcall" fn on_user_connect(user: *mut CUser) {
    let char = unsafe { user.as_ref().unwrap() };
    let mut teos = TEOS.lock().unwrap();

    let name_offset = &char.username as *const _;
    teos.log(format!("The username: {}, billing_id: {}, status: {}, name_addr: {:#X}", char.username.as_string(), char.billing_id, char.user_permission, name_offset as usize));
}

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
