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

Assertions are one of the main components of FIDO UAF, so its important to understand them well. From the [FIDO UAF Spec][1] p48:

> Authenticator Attestation is the process of validating Authenticator model identity during registration. It allows Relying Parties to cryptographically verify that the Authenticator reported by FIDO Client is really what it claims to be. Using Authenticator attestation, a relying party “example-rp.com” will be able to verify that the Authenticator model of the “example-Authenticator”, reported with AAID “1234#5678”, is not malware running on the FIDO User Device but is really a Authenticator of model “1234#5678”.

In this case the `assertionScheme` is a string identifying the type of assertion being sent. The server expects "".

The assertion is a Base 64 encoded String generated from an array of bytes.

The bytes always follow the same format: 1 byte identifier, 1 byte for the length, X bytes for the content of this tag.

* TAG_UAFV1_REG_ASSERTION
* _length of `reg assertion`_
* `reg assertion`

`reg assertion`

* TAG_UAFV1_KRD
* _length of `signed data`_
* `signed data`
* TAG_ATTESTATION_BASIC_FULL
* _length of `attestation basic full`_
* `attestation basic full`

`signed data`
* TAG_AAID
* _length of `aaid`_
* `aaid`
* TAG_ASSERTION_INFO
* _length: 7_
* `2 bytes - vendor; 1 byte Authentication Mode; 2 bytes Sig Alg; 2 bytes Pub Key Alg`
* TAG_FINAL_CHALLENGE
* _length of `final challenge`_
* `final challenge`
* TAG_KEYID
* _length of `keyId`_
* `keyId`
* TAG_COUNTERS
* _length of `counters`_
* `counters`
* TAG_PUB_KEY
* _length of `pubKey`_
* `pubKey`

`attestation basic full`
* TAG_SIGNATURE
* _length of `signature`_
* `signature`
* TAG_ATTESTATION_CERT
* _length of `DER certificate`_
* `DER certificate`

`signature`
This uses the byte array from `reg assertion`, until after the `signed data` block, which we'll call `dataForSigning`.

This byte array is hashed using SHA256 to get `hashToSign`.

The `hashToSign` is then signed using [`ECDSASigner.generateSignature`](https://people.eecs.berkeley.edu/~jonah/bc/org/bouncycastle/crypto/signers/ECDSASigner.html#generateSignature(byte[])) which generates a pair of big ints [r,s] (Which is a DER encoded SEQUENCE `{ r INTEGER, s INTEGER }`)

`[r, s]` is then encoded into an array of bytes using the following code with the [ASN1](http://grepcode.com/file/repo1.maven.org/maven2/com.madgag/scprov-jdk15on/1.47.0.1/org/spongycastle/asn1/ASN1Primitive.java) library from SpongyCastle.

```java
public static byte[] getEncoded(BigInteger[] sigs) throws IOException {
		ByteArrayOutputStream bos = new ByteArrayOutputStream(72);
		DERSequenceGenerator seq = new DERSequenceGenerator(bos); // from the asn1 library
		seq.addObject(new ASN1Integer(sigs[0])); // from the asn1 library
		seq.addObject(new ASN1Integer(sigs[1])); // from the asn1 library
		seq.close();
		return bos.toByteArray();
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
