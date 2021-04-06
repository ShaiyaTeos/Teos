use crate::models::{RtCriticalSection, SConnection, SNode, SVector};

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CObject {
    pos: SVector,
    pub id: u32,
    zone: u32,
    cell_x: u32,
    cell_z: u32,
    link: CObjectLink,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CObjectConnection {
    pub connection: SConnection,
    pub object: CObject,
    pub unknown: [u8; 48], // Part of CObjectConnection but who rly cares
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CObjectMoveable {
    object: CObject,
    move_count: u32,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct CObjectLink {
    node: SNode,
    object: *const CObject,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
struct SSyncQueueBufferPriority {
    head: u32,
    tail: u32,
    length: u32,
    critical_section: RtCriticalSection,
    count: u32,
}
