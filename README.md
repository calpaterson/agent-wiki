# agent-wiki

Bolt a Karpathy style agent-wiki onto your existing AI agent.

Your agent will ingest sources, create interlinked pages and query knowledge.
You are the human in the loop to keep things sane.

[![Compatibility](https://img.shields.io/badge/compatibility-opencode%20%7C%20claude--code-blue)](#)

## What is this?

A skill that turns AI agents into maintainers of a local, curated wiki.

Agents follow a formal workflow:

1. Ingest sources
2. Summarise
3. Cross-link
4. Log the change

Based on [Andrej Karpathy's LLM
wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
pattern.

## Compatibility

Any agent that supports the Agent Skills standard:

- **OpenCode** - supports agent skills
- **Claude Code** - also supports agent skills
- **Anything Else** - just so long it it supports agent skills

## Quick Start

0. **Make sure `uv` is installed**

    This is the only mandatory dependency and is necessary to make Python work
    for internal tooling.

    Visit
    [https://docs.astral.sh/uv/#installation](https://docs.astral.sh/uv/#installation)
    to install `uv`.

1. **Install the skill**

    With [skills.sh](https://www.skills.sh/):

    ```bash
    npx skills add calpaterson/agent-skill
    ```

    Just via git:

   ```bash
   mkdir -p ~/.agent/skills
   cd ~/.agent/skills
   git clone https://github.com/calpaterson/agent-wiki.git
   ```

2. **Create your wiki** - the agent loads the skill automatically when you ask
   it to read, write, or maintain the wiki.  Prompt:

    ```
    create the agent wiki
    ```

3. **Start creating pages** - try this prompt:

    ```
    research rice varietals, then add a page to the agent wiki about it
    ```

4. **Query pages** - try this prompt:

    ```
    suggest a good rice varietal for making sake
    ```

## How It Works

The skill a few operations agents can perform.  Among them:

### Ingest

When a new source lands in `raw/`, the agent:
1. Reads the source
2. Creates a summary page in `entities/` or `concepts/`
3. Updates related pages with new facts and backlinks
4. Appends a signed entry to `log.md` via `awiki log`

### Query

When asked a question, the agent:
1. Runs `awiki search "query"` to find relevant pages
2. Follows cross-references to related pages
3. Synthesizes an answer with citations
4. Optionally files the answer back as a new wiki page

### Lint

Periodic health checks:
- `awiki lint` — broken links, orphan pages, missing frontmatter
- Manual review — contradictions, stale claims (>3 months), missing cross-references

## Directory Layout

```
~/sync/chat/
├── WIKI.md           # Schema and conventions (the constitution)
├── log.md            # Append-only chronological log
├── intros.md         # Agent introductions and slugs
├── raw/              # Immutable source documents
├── agents/           # Per-agent scratch dirs (slug-named)
└── pages/            # The pages themselves
```

## Dependencies

`uv` is the only mandatory dependency.

But if you have [Ollama](https://ollama.com/) you gain semantic search which matters above a 100+ pages.

## Key Design Decisions

- Just markdown
  - With good old YAML frontmatter
- Comes with a cli tool (`awiki`) for agents to use for logging, linting, searching
  - Helps give them a framing to use
- Includes a webserver so you can browse the wiki yourself
- Prompts insist that information is sourced
  - cuts down on hallucinations/chinese whispers-style issues

## License

AGPLv3 or later
