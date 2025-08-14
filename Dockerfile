FROM matrixconduit/matrix-conduit:latest

# Copy your config into the container
COPY config /etc/conduit

EXPOSE 6167
CMD ["conduit", "--config", "/etc/conduit/conduit.toml"]
