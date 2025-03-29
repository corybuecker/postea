mod models;
mod parsers;
mod utils;

use anyhow::{Result, anyhow};
use deadpool_postgres::Pool;
use models::Feed;
use parsers::sync_feed;
use tokio::signal::unix::SignalKind;
use tokio_postgres::NoTls;
use tower_http::trace::TraceLayer;
use utils::initialize_logging;

#[derive(Clone)]
struct ApplicationState {
    #[allow(dead_code)]
    pool: Pool,
}

#[tokio::main]
async fn main() -> Result<()> {
    initialize_logging();

    let database_url = std::env::var("DATABASE_URL")
        .unwrap_or_else(|_| "postgres://postea@localhost:5432/postea".to_string());
    let pg_config = deadpool_postgres::Config {
        url: Some(database_url),
        ..Default::default()
    };
    let pool = pg_config
        .builder(NoTls)
        .unwrap()
        .max_size(16)
        .build()
        .unwrap();

    let state = ApplicationState { pool: pool.clone() };
    let app = axum::Router::new().with_state(state);
    let app = app.layer(TraceLayer::new_for_http());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    let connection = pool.get().await?;
    let feed: Feed = connection
        .query_one("SELECT * FROM feeds LIMIT 1", &[])
        .await?
        .try_into()?;
    sync_feed(&feed).await;

    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown())
        .await
        .unwrap();

    Ok(())
}

async fn shutdown() {
    let mut signal = tokio::signal::unix::signal(SignalKind::interrupt()).unwrap();
    signal.recv().await.unwrap()
}
