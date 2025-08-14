FROM rust:1.70 as builder
WORKDIR /usr/src/conduit
COPY . .
RUN apt-get update && apt-get install -y pkg-config libssl-dev
RUN cargo build --release

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y libssl1.1 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/conduit/target/release/conduit /usr/local/bin/conduit
COPY config /etc/conduit
VOLUME /var/lib/matrix-conduit
EXPOSE 6167
CMD ["conduit", "--config", "/etc/conduit/conduit.toml"]
