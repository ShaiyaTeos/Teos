use crate::models::{CObjectConnection, SConnection, CItem, StBillingItemInfo, SSyncList, CSkill, ActionBarItem, CQuest};
use crate::util::types::FixedLengthArray;

/// Represents the CUser player structure in the Shaiya server.
#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CUser {
    pub connection: CObjectConnection,
    pub info: StUserInfo,
    missing: [u8; 129], // `StUserInfo` doesn't seem to be correct.
    pub strength: u32,
    pub dexterity: u32,
    pub intelligence: u32,
    pub wisdom: u32,
    pub reaction: u32,
    pub luck: u32,
    pub hp: u32,
    pub mp: u32,
    pub sp: u32,
}
unsafe impl Sync for CUser {}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StUserInfo {
    pub char_id: u32,
    pub slot: u8,
    pub country: u8,
    pub family: u8,
    pub grow: u8,
    pub max_grow: u8,
    pub hair: u8,
    pub face: u8,
    pub size: u8,
    pub job: u8,
    pub sex: u8,
    pub level: u16,
    pub stat_points: u16,
    pub skill_points: u16,
    pub experience: u32,
    pub money: u32,
    pub first_money: u32,
    pub bank_money: u32,
    pub kills: u32,
    pub deaths: u32,
    pub victories: u32,
    pub defeats: u32,
    pub kill_rank: u32,
    pub death_rank: u32,
    pub map: u16,
    pub direction: u16,
    pub hg: u16,
    pub vg: u16,
    pub cg: u8,
    pub og: u8,
    pub ig: u8,
    pub base_str: u16,
    pub base_dex: u16,
    pub base_int: u16,
    pub base_wis: u16,
    pub base_rec: u16,
    pub base_luc: u16,
    pub max_hp: u32,
    pub max_mp: u32,
    pub max_sp: u32,
    pub name: FixedLengthArray<21>,
    item_quality_level: [u8; 13],
    item_quality_base: [u16; 13],
    equipment: [*mut CItem; 24],
    inventory: [[*mut CItem; 24]; 5],
    warehouse: [*mut CItem; 240],
    bank: [StBillingItemInfo; 240],
    buffs: SSyncList<CSkill>,
    learned_skill_qty: u32,
    skills: [*mut CSkill; 256],
    action_bar_entry_qty: u32,
    action_bar: [ActionBarItem; 128],
    finished_quests: SSyncList<CQuest>,
    active_quests: SSyncList<CQuest>
}

impl CUser {
    /// Get the character name of the user.
    pub fn name(&self) -> String {
        let name = self.info.name.as_string();
        name.trim_matches(char::from(0)).to_string()
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
