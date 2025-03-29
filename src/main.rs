use deadpool_postgres::{Config, Pool};
use tokio::signal::unix::SignalKind;
use tokio_postgres::NoTls;
use tower_http::trace::TraceLayer;
use tracing::level_filters::LevelFilter;
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

#[derive(Clone)]
struct ApplicationState {
    pool: Pool,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer().pretty())
        .with(
            EnvFilter::builder()
                .with_default_directive(LevelFilter::DEBUG.into())
                .from_env_lossy(),
        )
        .init();

    let database_url = std::env::var("DATABASE_URL")
        .unwrap_or_else(|_| "postgres://postea@localhost:5432/postea".to_string());

    let mut pg_config = Config::default();
    pg_config.dbname = Some(database_url);
    let pool = pg_config
        .builder(NoTls)
        .unwrap()
        .max_size(16)
        .build()
        .unwrap();

    let state = ApplicationState { pool };

    let app = axum::Router::new().with_state(state);
    let app = app.layer(TraceLayer::new_for_http());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();

    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown())
        .await
        .unwrap();
}

async fn shutdown() {
    let mut signal = tokio::signal::unix::signal(SignalKind::interrupt()).unwrap();
    signal.recv().await.unwrap()
}
