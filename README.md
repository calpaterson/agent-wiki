# agent-wiki

Bolt a Karpathy style agent-wiki onto your existing AI agent.

Your agent will ingest sources, create interlinked pages and query knowledge.
You are the human in the loop to keep things sane.

**Compatible with pretty much every AI agent (Claude Code, OpenCode, etc) via
the Agent Skills standard**.

## What is this?

A skill that turns AI agents into maintainers of a local, curated wiki.

The wiki looks like this on disk:

- `WIKI.md` - local convention document
- `log.md` - changelog
- `intros.md` - agent self-introductions
- `pages/` - directory holding the wiki pages themselves
    - `epicurean-philosophy.md` - page about ancient guys who liked to eat
    - `helmet-library-system.md` - page on how to search for library books in Helsinki
    - `motorsport-news-feeds.md` - preferred news sources about motorsport
    - `survival-horror-canon.md` - resident evil type games
    - `woks.md` - investigation into getting carbon steel wok
    - `[...]
- `raw/` - raw data, your imports, never edited by the agents
    - `claude-export.zip` - historical claude conversations
    - `hetzner.csv` - some import from a cloud provider
    - `dmesg-2026-06-03-output.txt` - some log output you copied in one time


Based on [Andrej Karpathy's LLM
wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
pattern.

## Compatibility

Any agent that supports the [Agent Skills](https://agentskills.io/home)
standard:

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

    Via git:

   ```bash
   mkdir -p ~/.agent/skills
   cd ~/.agent/skills
   git clone https://github.com/calpaterson/agent-wiki.git
   ```

   **Don't** use tools like Vercel's `skills.sh` - they don't support the whole
   skill spec and will leave you with a broken installation.

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

The skill specifcies few operations agents can perform.  Among them:

### Ingest

1. Read sources
   - from web searches or fetches
   - or from `./raw`
2. Creates page(s)
3. Updates related pages with new facts and backlinks
4. Appends a signed entry to `log.md`

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
~/agent-wiki/
├── WIKI.md           # Schema and conventions (the constitution)
├── log.md            # Append-only chronological log
├── intros.md         # Agent introductions and slugs
├── raw/              # Immutable source documents
├── agents/           # Per-agent scratch dirs (slug-named)
└── pages/            # The pages themselves
```

## Dependencies

`uv` is the only mandatory dependency.

But, if you have [Ollama](https://ollama.com/) you gain semantic search (as
opposed to the default full text search) - which matters above a 100+ pages.

## Key Design Decisions

- Just markdown
  - With good old YAML frontmatter
- Comes with a cli tool (`awiki`) for agents to use for logging, linting, searching
  - Helps give them a framing to use
  - Humans can use it too
- Includes a webserver so you can browse the wiki in a web browsers
- Prompts insist that information is sourced
  - cuts down on hallucinations/chinese whispers-style issues

## License

AGPLv3 or later
