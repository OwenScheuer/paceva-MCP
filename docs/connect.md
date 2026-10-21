# Connecting an AI app

Paceva is a remote MCP server at:

```
https://paceva.app/api/mcp
```

It speaks **Streamable HTTP** and asks the app to sign in with **OAuth 2.1**.
You need a Paceva account with your watch connected first (see
[intervals-icu.md](intervals-icu.md)); until data arrives, tools answer from a
clearly labelled sample athlete.

## Claude (claude.ai, desktop, mobile)

1. Open **Settings → Connectors** and choose **Add custom connector**.
2. Name it `Paceva` and paste `https://paceva.app/api/mcp`.
3. Claude opens Paceva. Sign in and press **Approve**.
4. In a chat, enable the Paceva connector and ask a question.

## ChatGPT

1. **Settings → Apps & Connectors**, add a custom connector.
2. Paste the URL and sign in to Paceva when asked.
3. Some plans need *developer mode* switched on for custom connectors.

## Claude Code

```bash
claude mcp add --transport http paceva https://paceva.app/api/mcp
```

Then run `/mcp` inside Claude Code and pick Paceva to sign in.

## Cursor and VS Code

Use the one-click buttons on **paceva.app → Use with AI**, or add the server
yourself:

```json
{
  "mcpServers": {
    "paceva": { "url": "https://paceva.app/api/mcp" }
  }
}
```

VS Code's `mcp.json` uses `"servers"` with `"type": "http"`; see
[examples/client-config.md](../examples/client-config.md).

## What the sign-in screen asks

Paceva shows the app's name and where it will send you back, and asks for one
permission: **read your Paceva training data**. Approving creates a grant you
can see and remove at any time under **Use with AI → Connected apps**.

## Good first questions

- "Should I go hard today?" → `get_today`
- "Is my HRV trending down this month?" → `get_trend`
- "What could I run a 10K in right now?" → `get_predictions`
- "How should I pace my 70.3?" → `get_race_plan`
- "Which of my last few rides moved my FTP?" → `list_workouts`, `get_workout`

## Troubleshooting

| Symptom | Fix |
|---|---|
| The app says the server needs authentication | Remove the connector and add it again; approve on the Paceva screen. |
| Answers mention SAMPLE DATA | Your watch isn't connected yet, or its first sync is still running. |
| 401 after it worked before | The app was disconnected in Paceva, or its refresh token expired after 60 days unused. Reconnect. |
