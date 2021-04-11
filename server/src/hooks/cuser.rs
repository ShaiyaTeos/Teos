use crate::models::CUser;
use crate::util::TeosLogger;
use crate::{get_sql_client, user, TEOS};
use byteorder::{BigEndian, ByteOrder, LittleEndian};
use std::sync::Arc;
use std::time::Duration;
use crate::models::packets::{CharacterAdditionalStats, SummonRequest, CharacterDetails};
use crate::util::types::FixedLengthArray;

/// The maximum packet size
const MAXIMUM_PACKET_SIZE: usize = 2046;

/// Gets executed when the user's stats are updated.
///
/// # Arguments
/// * `user`    - The character instance.
pub extern "stdcall" fn on_user_set_attack(user: *mut CUser) {
    let char = unsafe { user.as_ref().unwrap() };
    let info = &char.info;
    let mut additional_stats = CharacterAdditionalStats::new();

    // The "yellow stats" are equal to the total stat, less the base stat.
    additional_stats.yellow_strength = char.strength - info.base_str as u32;
    additional_stats.yellow_dexterity = char.dexterity - info.base_dex as u32;
    additional_stats.yellow_reaction = char.reaction - info.base_rec as u32;
    additional_stats.yellow_intelligence = char.intelligence - info.base_int as u32;
    additional_stats.yellow_wisdom = char.wisdom - info.base_wis as u32;
    additional_stats.yellow_luck = char.luck - info.base_luc as u32;

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
    let mut packet = CharacterDetails::new();
    let pos = &char.connection.object.pos;
    let info = &char.info;

    // HP, MP, SP
    packet.max_hitpoints = info.max_hp;
    packet.max_stamina = info.max_sp;
    packet.max_mana = info.max_mp;

    // Money
    packet.gold = info.money;

    // Stat and skillpoints
    packet.statpoints = char.info.stat_points;
    packet.skillpoints = char.info.skill_points;

    // Kills, deaths etc
    packet.kills = info.kills;
    packet.deaths = info.deaths;
    packet.victories = info.victories;
    packet.defeats = info.defeats;

    // Position vector
    packet.x = pos.x;
    packet.y = pos.y;
    packet.z = pos.z;
    packet.direction = info.direction;

    char.send(&packet);
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
    teos.log(format!("user={:#?}", char));
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
        if opcode == 0x030A || opcode == 0x0309 || opcode == 0x0308 {
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
