use crate::TEOS;
pub mod types;

pub trait TeosLogger {
    fn log_error(&self);
}

impl<T> TeosLogger for anyhow::Result<T> {
    fn log_error(&self) {
        if let Err(e) = &self {
            let mut teos = TEOS.lock().unwrap();
            teos.log(format!("ERROR! {}", e.to_string()));
        }
    }
}
