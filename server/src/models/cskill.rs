use crate::models::SNode;
use crate::util::types::FixedLengthArray;

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CSkill {
    node: SNode,
    skill_id: u32,
    skill_level: u32,
    skill_number: u32,
    attack_time: u32,
    reset_time: u32,
    end_time: u32,
    prev_tick: u32,
    attacker: StTarget,
    skill_info: *const StSkillInfo
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StSkillInfo {
    skill_id: u16,
    level: u8,
    name: FixedLengthArray<32>,
    required_level: u16,
    faction: u8,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StTarget {
    target_type: u32,
    id: u32
}