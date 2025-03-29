use chrono::{DateTime, Utc};
use tokio_postgres::Row;

pub struct Post {
    pub id: i32,
    pub feed_id: i32,
    pub body: String,
    pub date: DateTime<Utc>,
}

impl TryFrom<Row> for Post {
    type Error = anyhow::Error;

    fn try_from(value: Row) -> std::result::Result<Self, Self::Error> {
        Ok(Self {
            id: value.try_get("id")?,
            feed_id: value.try_get("feed_id")?,
            body: value.try_get("body")?,
            date: value.try_get("date")?,
        })
    }
}

pub struct Feed {
    pub id: i32,
    pub url: String,
}

impl TryFrom<Row> for Feed {
    type Error = anyhow::Error;

    fn try_from(value: Row) -> std::result::Result<Self, Self::Error> {
        Ok(Self {
            id: value.try_get("id")?,
            url: value.try_get("url")?,
        })
    }
}
