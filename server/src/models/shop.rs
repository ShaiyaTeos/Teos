use crate::models::CUser;
use crate::util::types::FixedLengthArray;

#[repr(C, packed)]
pub struct StMyShop {
    pub user: *const CUser,
    pub status: u32,
    pub bag: [u32; 12],
    pub slot: [u32; 12],
    pub money: [u32; 12],
    pub name_len: u32,
    pub name: FixedLengthArray<121>,
    pub name_use_char: u32,
    pub use_char_list: [u32; 16],
    pub my_use_shop: u32,
}