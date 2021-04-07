#[repr(C, packed)]
#[derive(Default)]
pub struct CharacterAdditionalStats {
    opcode: u16,
    pub yellow_strength: u32,
    pub yellow_reaction: u32,
    pub yellow_intelligence: u32,
    pub yellow_wisdom: u32,
    pub yellow_dexterity: u32,
    pub yellow_luck: u32,
    pub min_physical_attack: u32,
    pub max_physical_attack: u32,
    pub min_magic_attack: u32,
    pub max_magic_attack: u32,
    pub defense: u32,
    pub resistance: u32,
}

impl CharacterAdditionalStats {
    /// Default initialises the packet.
    pub fn new() -> Self {
        Self {
            opcode: 0x0526,
            ..Default::default()
        }
    }
}
