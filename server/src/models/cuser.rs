use crate::models::{CObjectConnection, SConnection};

/// Represents the CUser player structure in the Shaiya server.
#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CUser {
    pub connection: CObjectConnection,
    pub info: StUserInfo,
    strength: u32,
    dexterity: u32,
    intelligence: u32,
    wisdom: u32,
    reaction: u32,
    luck: u32,
    pub hp: u32,
    mp: u32,
    sp: u32,
}
unsafe impl Sync for CUser {}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StUserInfo {
    char_id: u32,
    slot: u8,
    country: u8,
    family: u8,
    grow: u8,
    max_grow: u8,
    hair: u8,
    face: u8,
    size: u8,
    job: u8,
    sex: u8,
    pub level: u16,
    stat_points: u16,
    skill_points: u16,
    experience: u32,
    money: u32,
    first_money: u32,
    bank_money: u32,
    kills: u32,
    deaths: u32,
    victories: u32,
    defeats: u32,
    kill_rank: u32,
    death_rank: u32,
    pub map: u16,
    direction: u16,
    hg: u16,
    vg: u16,
    cg: u8,
    og: u8,
    ig: u8,
    base_str: u16,
    base_dex: u16,
    base_int: u16,
    base_wis: u16,
    base_rec: u16,
    base_luc: u16,
    max_hp: u32,
    max_mp: u32,
    max_sp: u32,
    pub name: [u8; 21],
}

impl CUser {
    /// Get the character name of the user.
    pub fn name(&self) -> String {
        let name = String::from_utf8_lossy(&self.info.name);
        name.trim().to_owned()
    }

    /// Sends a packet to this user.
    ///
    /// # Arguments
    /// * `packet`  - The packet to send.
    pub fn send<T>(&self, packet: &T) {
        unsafe {
            let func = std::mem::transmute::<
                usize,
                extern "thiscall" fn(*const CUser, *const T, usize),
            >(0x4D4D20);
            func(
                self as *const CUser,
                packet as *const T,
                std::mem::size_of::<T>(),
            );
        }
    }

    pub fn connection(&self) -> &SConnection {
        &self.connection.connection
    }
}
