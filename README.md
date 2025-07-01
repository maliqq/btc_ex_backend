# BTC Exchange Backend

## Getting started

### Prerequisites

1. Set the required environment variables for the Docker container:

```sh
export BTC_WALLET_KEY_FILE=...
```

- `BTC_WALLET_KEY_FILE`: Path to your Bitcoin _private_ key file in WIF format.

1. Checkout submodule for frontend:

`git submodule update --init`

### Starting

`docker compose up`

Once running, access the [frontend](http://localhost:3000/app/) or the [admin panel](http://localhost:3000/admin/).

Use the following default creds for admin: `admin@example.com | password`.
