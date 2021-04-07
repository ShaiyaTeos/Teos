use crate::models::SNode;
use crate::util::types::FixedLengthArray;

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CQuest {
    node: SNode,
    id: u32,
    success: bool,
    start_time: u32,
    end_time: u32,
    end_success_time: u32,
    count: [u8; 3],
    quest_info: *const StQuestInfo
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StQuestInfo {
    id: u16,
    name: FixedLengthArray<256>
}