use crate::util::types::FixedLengthArray;

#[repr(C, packed)]
#[derive(Default)]
pub struct CharacterListPacket {
    pub opcode: u16,
    pub slot: u8,
    pub char_id: i32,
    pub create_time: i32,
    pub level: i16,
    pub race: u8,
    pub mode: u8,
    pub hair: u8,
    pub face: u8,
    pub height: u8,
    pub class: u8,
    pub gender: u8,
    pub map: i16,
    pub strength: i16,
    pub dexterity: i16,
    pub reaction: i16,
    pub intelligence: i16,
    pub wisdom: i16,
    pub luck: i16,
    pub hitpoints: i16,
    pub mana: i16,
    pub stamina: i16,
    pub equipment_types: FixedLengthArray<8>,
    pub equipment_type_ids: FixedLengthArray<8>,
    pub name: FixedLengthArray<21>,
    pub cloak_info: FixedLengthArray<6>,
}

impl CharacterListPacket {
    pub fn new() -> Self {
        Self {
            opcode: 0x0101,
            ..Default::default()
        }
    }
}
