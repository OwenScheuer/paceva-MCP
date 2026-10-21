# OAuth 2.1

Paceva runs its own small authorization server in front of the MCP endpoint.
Most MCP clients do all of this for you; this page is for people building
their own client or debugging one.

## At a glance

| | |
|---|---|
| Grant | Authorization code + **PKCE (S256 only)** |
| Clients | Public only (`token_endpoint_auth_method: none`) |
| Scope | `paceva:read` (the only one) |
| Client identity | Client ID Metadata Document **or** Dynamic Client Registration (RFC 7591) |
| Authorization code | Single use, 10 minutes. A replayed code revokes the whole grant. |
| Access token | Bearer, 1 hour |
| Refresh token | 60 days, **rotated on every use** |
| Resource indicator | `https://paceva.app/api/mcp` (RFC 8707) |

## Discovery

An unauthenticated call to the MCP endpoint returns `401` with:

```
WWW-Authenticate: Bearer error="invalid_token", scope="paceva:read",
  resource_metadata="https://paceva.app/.well-known/oauth-protected-resource/api/mcp"
```

| Document | URL |
|---|---|
| Protected resource metadata (RFC 9728) | `https://paceva.app/.well-known/oauth-protected-resource/api/mcp` |
| Authorization server metadata (RFC 8414) | `https://paceva.app/.well-known/oauth-authorization-server` |

| Endpoint | URL |
|---|---|
| Authorize | `https://paceva.app/oauth/authorize` |
| Token | `https://paceva.app/api/oauth/token` |
| Register | `https://paceva.app/api/oauth/register` |

## Identifying your client

**Client ID Metadata Document (preferred).** Use an `https://` URL you control
as the `client_id`. Paceva fetches it (public addresses only, size- and
time-limited) and reads `client_name` and `redirect_uris` from it.

**Dynamic registration.** `POST /api/oauth/register` with JSON:

```json
{ "client_name": "My app", "redirect_uris": ["https://example.com/callback"] }
```

Redirect URIs must be `https://`, a loopback address
(`http://127.0.0.1:<port>/…`, `http://localhost:<port>/…`) for desktop and CLI
clients, or a native app's private scheme (e.g. `cursor://…`). Registration
and the token endpoint are rate limited per IP.

## The flow

1. Make a `code_verifier` (43–128 chars) and `code_challenge = BASE64URL(SHA256(verifier))`.
2. Send the user to:

   ```
   https://paceva.app/oauth/authorize
     ?response_type=code
     &client_id=…
     &redirect_uri=…
     &code_challenge=…
     &code_challenge_method=S256
     &scope=paceva:read
     &state=…
     &resource=https://paceva.app/api/mcp
   ```

3. They sign in to Paceva and approve. You get `?code=…&state=…` on your redirect URI.
4. Exchange it:

   ```bash
   curl -X POST https://paceva.app/api/oauth/token \
     -d grant_type=authorization_code \
     -d code=… -d code_verifier=… \
     -d client_id=… -d redirect_uri=…
   ```

   ```json
   { "access_token": "…", "token_type": "Bearer", "expires_in": 3600,
     "refresh_token": "…", "scope": "paceva:read" }
   ```

5. Call the MCP endpoint with `Authorization: Bearer <access_token>`.
6. Refresh with `grant_type=refresh_token&refresh_token=…&client_id=…`.
   The response carries a **new** refresh token; the old one stops working.

## Revocation

The athlete can disconnect any app in **Use with AI → Connected apps**, which
revokes its grant immediately: the next call gets `401`. Deleting the Paceva
account revokes everything.

## Errors

Token errors follow RFC 6749 (`invalid_grant`, `invalid_request`,
`invalid_client`, `unsupported_grant_type`) with an `error_description`.
