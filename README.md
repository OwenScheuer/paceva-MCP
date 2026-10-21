<p align="center"><img src="assets/header.jpg" alt="Paceva: now live for Claude and ChatGPT" width="100%"></p>

# Paceva for developers

Paceva turns an endurance athlete's watch data into honest race predictions:
ranges, checked against their own history. This repository documents the
public surface: the **Paceva MCP server**, the **OAuth 2.1** sign-in in front
of it, and how Paceva connects to **Intervals.icu**.

> The Paceva app itself is closed source. This repo is documentation and
> examples only.

## Connect in one minute

**Server URL:** `https://paceva.app/api/mcp`

| App | How |
|---|---|
| Claude (claude.ai, desktop, mobile) | Settings → Connectors → *Add custom connector*, paste the URL, sign in to Paceva, approve. |
| ChatGPT | Settings → Apps & Connectors → add a custom connector with the URL (some plans need developer mode). |
| Claude Code | `claude mcp add --transport http paceva https://paceva.app/api/mcp`, then `/mcp` to sign in. |
| Cursor / VS Code | One-click buttons on [paceva.app/dashboard/ai](https://paceva.app/dashboard/ai), or add it as a Streamable HTTP server. |
| Anything else | Any MCP client that supports Streamable HTTP and OAuth 2.1 with PKCE. |

Then ask things like *"Should I go hard today?"*, *"What could I swim a
1500 in right now?"* or *"How did my last block of riding go?"*.

Full walkthrough: [docs/connect.md](docs/connect.md).

## What's here

| Doc | For |
|---|---|
| [docs/connect.md](docs/connect.md) | Connecting each AI app, and what to expect |
| [docs/tools.md](docs/tools.md) | Every MCP tool, its arguments and what it returns |
| [docs/oauth.md](docs/oauth.md) | The OAuth 2.1 server: discovery, PKCE, client registration, tokens |
| [docs/intervals-icu.md](docs/intervals-icu.md) | How watch data gets in: the Intervals.icu sign-in, step by step |
| [docs/data-and-privacy.md](docs/data-and-privacy.md) | What the AI app can and can't see |
| [examples/](examples) | `curl` discovery, a raw JSON-RPC call, client config snippets |

## Ground rules

- **Read-only.** One scope, `paceva:read`. No tool writes anything.
- **Only your own data.** A token is bound to one Paceva account; it can never
  read anyone else's.
- **Every number is labelled.** `device` values are your watch's own
  (e.g. Garmin's HRV); `paceva` values are computed by Paceva.
- **Predictions are ranges.** Tools return a low–high range and how often that
  range holds for you. Quote the range, not a single time.
- **Revocable.** Disconnect any app from Paceva → Use with AI; its tokens stop
  working on the next call.

## Status

| Piece | Status |
|---|---|
| MCP server + OAuth | **Live** |
| Intervals.icu sync (Garmin, Coros, Wahoo, Polar, Suunto) | **Live** |
| Paceva web dashboard | Coming soon, [join the waitlist](https://paceva.app/#soon) |
| iPhone app (Apple Health) | Coming soon |

## Security

Found a problem? Please email **privacy@paceva.app** rather than opening a
public issue. See [SECURITY.md](SECURITY.md).

## License

Docs and examples in this repository are MIT licensed. The Paceva name and
logo are not.
