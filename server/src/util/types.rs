/// Represents a C-style array that is often used as a string.
#[derive(Debug, Clone)]
pub struct FixedLengthArray<const N: usize> {
    data: [u8; N],
}

impl<const N: usize> FixedLengthArray<N> {
    /// Populates a `FixedLengthArray` with the data from a slice of bytes.
    ///
    /// # Arguments
    /// * `bytes`   - The input bytes.
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

    /// Gets the capacity of this array.
    pub fn capacity(&self) -> usize {
        N
    }

    /// Sets a value in the array.
    ///
    /// # Arguments
    /// * `index`   - The index to mutate.
    /// * `value`   - The new value.
    pub fn set(&mut self, index: usize, value: u8) {
        self.data[index] = value
    }

    /// Populates a `FixedLengthArray` with the data from a string.
    ///
    /// # Arguments
    /// * `text`    - The input string.
    pub fn from_str(text: &str) -> Self {
        Self::new(text.as_bytes())
    }

    /// Gets this `FixedLengthArray` as a string.
    pub fn as_string(&self) -> String {
        String::from_utf8_lossy(self.data.as_slice()).to_string()
    }
}

impl<const N: usize> Default for FixedLengthArray<N> {
    /// Provide a default constructor for the FixedLengthArray.
    fn default() -> Self {
        let data: [u8; N] = [0; N];
        Self { data }
    }
}
