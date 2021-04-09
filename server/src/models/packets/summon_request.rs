#[repr(C, packed)]
#[derive(Default)]
pub struct SummonRequest {
    opcode: u16,
    pub id: u32,
    pub map: u16
}

impl SummonRequest {
    /// Default initialises the packet.
    pub fn new() -> Self {
        Self {
            opcode: 0x0223,
            ..Default::default()
        }
    }
}
