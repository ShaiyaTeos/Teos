use crate::models::CUser;

#[repr(C, packed)]
#[derive(Debug)]
pub struct CMinigame {
    pub status: u32,
    pub npc: u32,
    pub batting_money: u32,
    pub num_batting_slot: u32,
    pub slot_get_money: u32,
    pub card_game_grade: u32,
    pub npc_card: u32,
    pub user: *mut CUser,
}