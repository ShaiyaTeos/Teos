#[repr(C, packed)]
#[derive(Debug)]
pub struct CUserCrypto {
    aes_dec: SAes,
    aes_enc: SAes,
    init_dec: bool,
    init_enc: bool,
    init_game: bool,
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct SAes {
    key: AesKey,
    iv: [u8; 16],
    iv_pos: u32,
    enc_ctr: [u8; 16]
}

#[repr(C, packed)]
#[derive(Debug)]
pub struct AesKey {
    pub key: [u32; 60],
    pub round: u32
}