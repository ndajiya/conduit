# Stage 1: Build Conduit from source
FROM rust:1.80-bullseye as builder
WORKDIR /usr/src/conduit

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    libsqlite3-dev \
    clang \
    llvm-dev \
    libclang-dev \
    make \
    cmake \
    g++

# Clone Conduit source
RUN git clone https://gitlab.com/famedly/conduit.git .

# Build Conduit in release mode
RUN cargo build --release --locked

# Stage 2: Runtime image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    libsqlite3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled binary from builder
COPY --from=builder /usr/src/conduit/target/release/conduit /usr/local/bin/conduit
COPY config /etc/conduit

VOLUME /var/lib/matrix-conduit
EXPOSE 6167
CMD ["conduit", "--config", "/etc/conduit/conduit.toml"]
