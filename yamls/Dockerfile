version: '1.35.0'
services:
  envoy:
    image: envoyproxy/envoy:dev-b0c33ac4a58e65e22fcac0426fe12800dd4a8564
    ports:
      - "10000:10000"
    volumes:
      - ./envoy.yaml:/etc/envoy/envoy.yaml