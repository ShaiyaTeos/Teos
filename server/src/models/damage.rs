use crate::models::SNode;

#[repr(C, packed)]
#[derive(Debug)]
pub struct StDamage {
    pub node: SNode,
    pub id: u32,
    pub damage: u32,
}