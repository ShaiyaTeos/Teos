use crate::models::RtCriticalSection;

#[repr(C, packed)]
#[derive(Debug)]
pub struct SSyncList<T> {
    head: *const T,
    cursor: *const T,
    critical_section: RtCriticalSection,
    count: u32,
    mem_head: SNode
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct SNode {
    prev: *const SNode,
    next: *const SNode
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct SNode2 {
    inner: SNode,
    prev: *const SNode2,
    next: *const SNode2
}