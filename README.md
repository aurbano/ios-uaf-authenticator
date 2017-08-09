# Violet
> iOS TouchID research project

# Building

# Test Server Docs
This project uses the test server available at https://github.com/eBay/UAF

The server exposes a REST API with JSON formatted messages for communication. Cryptographic information is sent as a base 64 encoded byte array. 

## Endpoints



## Registration

### 1. `GET /v1/public/regRequest/{username}`

#### Response

```json
{}
```

### 2. `POST /v1/public/regResponse`

#### Request

```json
{}
```

#### Response

```json
{}
```

## Authentication

### 1. `GET /v1/public/authRequest`

#### Response

```json
{}
```

### 2. `POST /v1/public/authResponse`

#### Request

```json
{}
```

#### Response

```json
{}
```

## Deregistration

### 1. `GET /v1/public/deregRequest`

#### Response

```json
{}
```

