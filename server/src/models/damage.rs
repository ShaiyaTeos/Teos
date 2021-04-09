use crate::models::SNode;

#[repr(C, packed)]
pub struct StDamage {
    pub node: SNode,
    pub id: u32,
    pub damage: u32,
}