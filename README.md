# Homebrew Tap for Evo

Homebrew formulae for the [Evo self-evolution agent system](https://github.com/ai-evo-agents).

## Installation

```bash
brew tap ai-evo-agents/evo
brew install evo-king evo-gateway
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `evo-king` | Central orchestrator (Socket.IO server, pipeline coordinator, agent manager) |
| `evo-gateway` | Multi-provider LLM proxy (OpenAI, Anthropic, Ollama, CLI-based) |

## Upgrading

```bash
brew update
brew upgrade evo-king evo-gateway
```

## License

MIT
