# Client config snippets

**Claude Code**

```bash
claude mcp add --transport http paceva https://paceva.app/api/mcp
```

**Cursor** (`~/.cursor/mcp.json`)

```json
{ "mcpServers": { "paceva": { "url": "https://paceva.app/api/mcp" } } }
```

**VS Code** (`.vscode/mcp.json`)

```json
{ "servers": { "paceva": { "type": "http", "url": "https://paceva.app/api/mcp" } } }
```

**MCP Inspector** (for poking at the tools)

```bash
npx @modelcontextprotocol/inspector
# Transport: Streamable HTTP · URL: https://paceva.app/api/mcp
```
