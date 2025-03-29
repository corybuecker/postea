FROM rust:bullseye AS builder
COPY . /app
WORKDIR /app
RUN cargo build --release

FROM debian:bullseye-slim
COPY --from=builder /app/target/release/postea /usr/local/bin/postea
ENTRYPOINT ["/usr/local/bin/postea"]
