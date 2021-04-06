/// Represents a C-style array that is often used as a string.
#[derive(Debug, Clone)]
pub struct FixedLengthArray<const N: usize> {
    data: [u8; N],
}

impl<const N: usize> FixedLengthArray<N> {
    pub fn new(bytes: &[u8]) -> Self {
        let mut data: [u8; N] = [0; N];

        // Copy the bytes from the string into the data slice
        data.iter_mut().enumerate().for_each(|(idx, val)| {
            if idx >= bytes.len() {
                return;
            }
            *val = bytes[idx]
        });
        FixedLengthArray { data }
    }

    pub fn from_str(text: &str) -> Self {
        Self::new(text.as_bytes())
    }
}

impl<const N: usize> Default for FixedLengthArray<N> {
    /// Provide a default constructor for the FixedLengthArray.
    fn default() -> Self {
        let data: [u8; N] = [0; N];
        Self { data }
    }
}
