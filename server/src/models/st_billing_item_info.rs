#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct StBillingItemInfo {
    item_type: u8,
    type_id: u8,
    qty: u8
}