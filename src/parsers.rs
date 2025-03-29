use crate::models::Feed;
use anyhow::Result;
use rss::Item;

pub async fn sync_feed(feed: &Feed) -> Result<usize> {
    let items = download_feed(&feed.url).await?;

    Ok(items.len())
}

async fn download_feed(url: &str) -> Result<Vec<Item>> {
    let response = reqwest::get(url).await?;
    let body = response.bytes().await?;
    let channel = rss::Channel::read_from(&body[..])?;

    Ok(channel.items().to_vec())
}
