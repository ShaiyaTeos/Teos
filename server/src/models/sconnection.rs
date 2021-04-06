use crate::models::{SNode2, RtCriticalSection};

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct SConnection {
    param: SConnectionParam,
    file_descriptor: u32,
    socket: u32,
    addr: SocketAddress,
    queue_recv: SSyncQueueBuffer,
    queue_send: SSyncQueueBufferSend,
    agent: u32,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct SConnectionParam {
    node: SNode2,
    close_type: u32,
    close_error: u32,
    send_count: u64,
    recv_count: u64,
    send_bytes: u64,
    recv_bytes: u64,
    connect_time: u32,
    send_processing: u32,
    num_job_dispatch: u32,
    recv_reply_time: u32,
    critical_section: RtCriticalSection
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct SSyncQueueBuffer {
    head: u32,
    tail: u32,
    critical_section: RtCriticalSection,
    count: u32,
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
pub struct SSyncQueueBufferSend {
    head: u32,
    tail: u32,
    length: u32,
    critical_section: RtCriticalSection,
    count: u32,
}


#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
/// Structure taken from https://docs.microsoft.com/en-us/previous-versions/windows/hardware/drivers/ff556972(v=vs.85)
pub struct SocketAddress {
    family: u16,
    port: u16,
    addr: InAddr,
    zero: [u8; 8]
}

#[repr(C)]
#[repr(packed)]
#[derive(Debug)]
struct InAddr {
    bytes: [u8; 4],
    unused: [u16; 2],
    addr: u32,
}

