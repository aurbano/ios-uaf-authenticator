# Violet
> iOS TouchID research project

# Building

# Test Server Docs
This project uses the test server available at https://github.com/eBay/UAF

The server exposes a REST API with JSON formatted messages for communication. Cryptographic information is sent as a base 64 encoded byte array. 

## Registration

### 1. `GET /v1/public/regRequest/{username}`

#### Response

```ts
{
  "header": {},
  "challenge": string, // Random base64 encoded string created with BCrypt.gensalt()
  "username": string, // Same as the one provided in the URL
  "policy": [] // Array of policy objects.
}
```
Each policy object can contain the following elements (See the [FIDO spec][1], p20):

```java
String[] aaid;
String[] vendorID;
String[] keyIDs;
long userVerification;
int keyProtection;
int matcherProtection;
long attachmentHint;
int tcDisplay;
int[] authenticationAlgorithms;
String[] assertionSchemes;
int[] attestationTypes;
int authenticatorVersion;
Extension[] exts;
```

`AAID` (Authenticator Attestation ID):  Each Authenticator MUST have an AAID to identify UAF enabled Authenticator models globally. Only Authenticators from the same vendor, of the same Model, and with identical security characteristics may share the same AAID.

The AAID is in the format V#M, where V is the vendor ID, and M is the model number, both in Hex.

### 2. `POST /v1/public/regResponse`

#### Request

```ts
{
  "header": {
    // Version
    "upv": {
      "major": number,
      "minor": number,
    },
    // Operation
    "op": "Reg" | "Auth" | "Dereg",
    "appId": string,
    "serverData": string // base64 contents below
  },
  "fcParams": string, // base64 contents below
  "assertions": []
}
```

##### `fcParams`

Base 64 encoded String of the following object:

```ts
{
  "appId": string,
  "challenge": string,
  "facetId": string,
  "channelBinding": {
    "serverEndPoint": string,
    "tlsServerCertificate": string,
    "tlsUnique": string,
    "cid_pubkey": string
  }
}
```

##### `serverData`

Base 64 encoded String of the following dot-separated string:

1. signature
1. timestamp
1. username
1. challenge

Example:
`serverData = base64Encode('{signature}.{timestamp}.{username}.{challenge}')`

The signature is generated with `HMAC.sign(dataToSign, hmacSecret)`

* `dataToSign` is `{timestamp}.{username}.{challenge}`
* `hmacSecret` is hardcoded in the server and is `HMAC-is-just-one-way`

##### `assertions`

Array of Assertion objects, where each assertion is an object containing the following:

```ts
{
  "assertionScheme": string,
  "assertion": string
}
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

[1]: https://fidoalliance.org/specs/fido-uaf-v1.0-rd-20140209/fido-uaf-protocol-v1.0-rd-20140209.pdf
