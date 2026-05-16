FROM ghcr.io/berriai/litellm:v1.83.3-stable

# Cloud Run expects the app to listen on $PORT (defaults to 8080)
ENV PORT=8080

# Expose the port
EXPOSE ${PORT}

# Run the proxy — config comes from Secret Manager volume mount
CMD ["--config", "/secrets/litellm-config/config.yaml", "--port", "8080", "--host", "0.0.0.0", "--detailed_debug"]
