CREATE TABLE posts (
    id serial PRIMARY KEY,
    feed_id integer NOT NULL REFERENCES feeds (id),
    body text NOT NULL,
    date timestamp with time zone
);

