use crate::models::{CObjectConnection, SConnection, CItem, StBillingItemInfo, SSyncList, CSkill, ActionBarItem, CQuest, SNode, StTarget, StDamage, CNpc, CExchange, CExchangePvp, CParty, CGuild, CGuildCreate, CMinigame, CFriend, SVector, RtCriticalSection, CUserCrypto};
use crate::util::types::FixedLengthArray;

/// Represents the CUser player structure in the Shaiya server. We should aim to refactor these field
/// names to be a bit more legible - for now they mirror that of the Ep4 PDB.
#[repr(C, packed)]
#[derive(Debug)]
pub struct CUser {
    pub connection: CObjectConnection,
    pub info: StUserInfo,
    missing: [u8; 128], // `StUserInfo` doesn't seem to be correct.
    pub strength: u32,
    pub dexterity: u32,
    pub intelligence: u32,
    pub wisdom: u32,
    pub reaction: u32,
    pub luck: u32,
    pub hp: u32,
    pub mp: u32,
    pub sp: u32,

    // Likely "attack recover hitpoints".
    pub atk_rec_hp: u32,
    pub atk_rec_sp: u32,
    pub atk_rec_mp: u32,

    // Sitting recover hitpoints
    pub sit_rec_hp: u32,
    pub sit_rec_sp: u32,
    pub sit_rec_mp: u32,

    // If recover status is 0, it uses these values?
    pub sit_rec_hpp: u32,
    pub sit_rec_spp: u32,
    pub sit_rec_mpp: u32,

    // The current recover status.
    pub recover_status: u32,

    // The amount of mp/sp to decrease on next recover tick.
    pub decrease_mp: u32,
    pub decrease_sp: u32,

    // Attack and defense element?
    pub attrib_atk: u32,
    pub attrib_def: u32,

    pub state_block: [u32; 17],
    pub attrib_atk_buff: [u8; 9],
    pub item_attack: u32,
    pub item_attack_var: u32,
    pub item_defense: u32,
    pub item_defense_mg: u32,
    pub attack_range: u32,
    pub attack_speed: u32,
    pub move_speed: u32,
    pub critical: u32,
    pub cool_time: u32, // Attack speed?
    pub reduce_damage: u32, // Absorption?
    pub language: u32,
    pub max_bag: u32,
    pub weapon_speed: [u8; 20],
    pub weapon_damage: [u8; 20],
    pub cross_road: u32,
    pub shield_value: u8,
    pub giveup_spmp: u32,
    pub stop: u32,
    pub stun: u32,
    pub sleep: u32,
    pub transform_mob: u32,
    pub transform_target_mod: u16,
    pub chase_id: u32,
    pub shape: u8,
    pub shape_type: u32,
    pub clone_user: *const StCloneUser, // Used for Ranger disguise
    pub block_all: u32,
    pub block_death: bool,
    pub block_dying: bool,
    pub not_see_mob: bool,
    pub hp_ability: StHpAbility,
    pub attack_add: [StAttackAdd; 3],
    pub attack: [StAttack; 3],
    pub disable_by_skill: u32,
    pub status: u32,
    pub status_life: u32,
    pub motion: u8,
    pub move_motion: u8,
    pub run: u32,
    pub attack_mode: u32,
    pub attack_next: u32,
    pub attack_skill: u32,
    pub prev_skill: u8,
    pub quality_dec: u32,
    pub next_attack_time: u32,
    pub rebirth_time: u32,
    pub rebirth_type: u32,
    pub drop_experience: u32,
    pub vehicle_status: u32,
    pub vehicle_time: u32,
    pub next_vehicle_time: u32,
    pub vehicle_type: u32,
    pub vehicle_type_add: u32,
    pub vehicle_partner_char_id: u32,
    pub vehicle_partner_request_id: u32,
    pub time_over_vehicle_partner: u32,
    pub party_call_request_id: u32,
    pub next_recover_time: u32,
    pub next_potion_reuse_time: [u32; 12],
    pub kill_count_status: [u32; 28],
    pub target: StTarget,
    pub target_prev: StTarget,
    pub attack_damage: StDamage,
    pub use_npc: *mut CNpc,
    pub exchange: CExchange,
    pub exchange_pvp: CExchangePvp,
    pub party: *mut CParty,
    pub party_req_id: u32,
    pub party_find_reg: bool,
    pub guild_id: u32,
    pub guild_master_req_id: u32,
    pub guild: *mut CGuild,
    pub guild_create: *mut CGuildCreate,
    pub minigame: CMinigame,
    pub friends: CFriend,
    pub move_check: StUserMoveCheck,
    pub guild_join_remain_hour: u32,
    pub ranking_zone_enter_flag: u32,
    pub move_instance_zone_flag: u32,
    pub pvp_status: u32,
    pub pvp_time: u32,
    pub pvp_user: u32,
    pub pvp_pos: SVector,

    // GvG?
    pub pvp_guild_id: u32,
    pub pvp_guild_pos: SVector,
    pub pvp_guild_time: u32,

    pub pvp_join_user: bool,
    pub pvp_guild_ready: u32,
    pub cs_nprotect: RtCriticalSection,
    pub nprotect_received: bool,
    pub nprotect_recv_time: u32,
    pub nprotect_csa: u32,
    pub crypto: CUserCrypto,
    pub n_where: u32,
    pub uid: u32,
    pub session_id: u64,
    pub user_permission: u8,
    pub admin_info: StAdminInfo,
    pub idk: [u8; 542],
    pub billing_id: i32,
    pub server_db_id: u32,
    pub username: FixedLengthArray<32>,
}

unsafe impl Sync for CUser {}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StHpAbility {
    pub apply: bool,
    pub id: u16,
    pub level: u8,
    pub prev_time: u32,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StAttackAdd {
    pub attack_add: u32,
    pub attack: u32,
    pub per_defense: u32,
    pub defense: u32
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StAttack {
    pub disable: u32,
    pub block: u32,
    pub block_value: u32,
    pub mirror: u32,
    pub mirror_level: u32,
    pub per_attack: u32,
    pub attack: u32,
    pub per_defense: u32,
    pub defense: u32,
    pub critical_attack: u32,
    pub critical_defense: u32,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StCloneUser {
    pub node: SNode,
    pub death: u8,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StUserMoveCheck {
    back_time: u32,
    check_time: u32,
    back_pos: SVector,
    prev_time: u32,
    prev_pos: SVector,
    total_dist: f32,
    max_speed: f32,
}

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
    pub ig: u16,
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

#[repr(C, packed)]
#[derive(Debug)]
pub struct StAdminInfo {
    process_id: u32,
    send_to_user_id: u32,
    visible: bool,
    attackable: bool,
    enable_move_time: u32,
    enable_chat_time: u32,
    listen_chat_id: u32,
    listen_chat_id_from: u32,
    notice: u32,
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
