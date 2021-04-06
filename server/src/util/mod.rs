use crate::TEOS;
pub mod types;

/// A trait designed to add support for logging various types to the error file.
pub trait TeosLogger {
    /// Logs a type as an error.
    fn log_error(&self);
}

impl<T> TeosLogger for anyhow::Result<T> {
    /// Logs a failed result as an error.
    fn log_error(&self) {
        if let Err(e) = &self {
            let mut teos = TEOS.lock().unwrap();
            teos.log(format!("ERROR! {}", e.to_string()));
        }
    }
}
