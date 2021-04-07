#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct ActionBarItem {
    bar: u8,
    slot: u8,
    bag: u8,
    number: u16
}