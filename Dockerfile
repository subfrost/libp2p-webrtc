FROM rust:latest

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /opt

# Copy current directory contents
COPY . .

# Build the signal binary in release mode
RUN cd signal && cargo build --release

# Create entrypoint that detects interface and runs the program
CMD IFACE=$(ip route | grep default | awk '{print $5}') && \
    ./signal/target/release/signal --interface $IFACE
