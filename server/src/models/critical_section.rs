#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct RtCriticalSection {
    debug_info: u32,
    lock_count: u32,
    recursion_count: u32,
    owning_thread: u32,
    lock_semaphore: u32,
    spin_count: u32
}