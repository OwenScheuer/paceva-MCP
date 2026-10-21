# Getting Paceva listed

Where people look for MCP servers, and how Paceva gets there.

## Official MCP Registry

`server.json` at the root of this repo describes Paceva for the
[MCP Registry](https://registry.modelcontextprotocol.io). Directories and
clients that read the registry pick it up from there.

```bash
# install mcp-publisher: see the registry's quickstart
mcp-publisher login github        # proves you own io.github.owenscheuer/*
mcp-publisher publish             # from this repo's root
```

Bump `version` before each re-publish. To use a `app.paceva/…` name instead
of the GitHub one, the registry supports DNS verification of the domain.

## Directories to submit to

Each has its own submission form; give them the server URL
`https://paceva.app/api/mcp`, this repo, and the one-line description from
`server.json`.

- Claude's connector directory (Anthropic's submission form for remote MCP servers)
- ChatGPT's apps directory (OpenAI's developer submission)
- Community directories such as PulseMCP, Glama, Smithery and mcp.so

Before submitting anywhere, make sure the production smoke test in the main
repo's `docs/GO_LIVE.md` passes.
