use tracing::info;

/// The entry point for the Teos library. This should initialise relevant connections to the database,
/// and initialise custom heap allocated structs.
#[no_mangle]
pub extern "C" fn startup() {
    // Initialise tracing
    let appender = tracing_appender::rolling::daily("Log", "Teos.log");
    let (non_blocking, _guard) = tracing_appender::non_blocking(appender);
    tracing_subscriber::fmt()
        .with_writer(non_blocking)
        .init();

    info!("Hello world!");
}