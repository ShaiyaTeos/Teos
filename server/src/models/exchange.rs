use crate::models::{SNode, RtCriticalSection, CUser, CItem};

#[repr(C, packed)]
#[derive(Debug)]
pub struct CExchange {
    pub state: u32,
    pub user: *const CUser,
    pub money: u32,
    pub item: [ExchangeItem; 8],
    pub ready: bool,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct CExchangePvp {
    pub exchange: CExchange,
    pub money_pvp: u32,
    pub item_pvp: [*const CItem; 8],
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct ExchangeItem {
    pub bag: u8,
    pub slot: u8,
    pub quantity: u8,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct CSyncExchange {
    pub node: SNode,
    pub critical_section: RtCriticalSection,
}