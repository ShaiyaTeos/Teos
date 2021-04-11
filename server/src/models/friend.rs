use crate::util::types::FixedLengthArray;
use crate::models::RtCriticalSection;

#[repr(C, packed)]
#[derive(Debug)]
pub struct CFriend {
    pub friend_count: u32,
    pub list_friend: [StFriendInfo; 100],
    pub block_count: u32,
    pub list_block: [StBlockInfo; 100],
    pub friend_req_id: u32,
    pub critical_section: RtCriticalSection,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct StFriendInfo {
    pub char_id: u32,
    pub family: u8,
    pub grow: u8,
    pub job: u8,
    pub name: FixedLengthArray<21>,
    pub memo: FixedLengthArray<51>
}
#[repr(C, packed)]
#[derive(Debug)]
pub struct StBlockInfo {
    pub char_id: u32,
    pub name: FixedLengthArray<21>,
    pub memo: FixedLengthArray<51>
}

