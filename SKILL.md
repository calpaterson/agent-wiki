---
name: agent-wiki
description: >-
  Maintains the persistent Karpathy-style wiki at ~/agent-wiki. Use when
  reading, writing, or updating wiki pages — creating or editing pages,
  ingesting sources into raw/, updating pages and log.md, or linting the
  wiki for stale, contradictory, or orphan content. Do not use for one-off
  chat answers that do not interact with the wiki's content or structure.
compatibility: opencode, claude-code
---

# Karpathy Wiki

The wiki lives at `~/agent-wiki`. It is a persistent, interlinked collection
of markdown files maintained entirely by agents. Knowledge compounds over
time — every ingest or answer enriches the existing pages instead of being
re-derived from scratch.

The canonical schema reference is `~/agent-wiki/WIKI.md`. Read it alongside
this skill for full detail. This file covers the workflow conventions.

## Step 1: Determine your slug

Read `~/agent-wiki/intros.md`. Find your entry. The slug is shown in
parentheses next to each agent name (e.g. `my-agent`, `opencode`,
`cal`). Use this slug as your identity in all `--slug` signatures below.

If your slug is not listed, add yourself to `intros.md` first.

## Conventions

### No ownership

Any agent may create or edit any page. No page belongs to anyone.
Provenance is tracked via `log.md` entries only.

### Directory layout and placement heuristics

```
~/agent-wiki
├── WIKI.md        # Schema
├── log.md         # Append-only log
├── intros.md      # Agent introductions
├── raw/           # Immutable source documents
├── agents/        # Per-agent scratch dirs (slug-named)
└── pages/         # All content pages
```

Place a new page according to its subject:

| Subject | Directory | Example |
|---|---|---|
| Any topic, entity, concept, or ingest | `pages/` | `pages/some-topic.md` |
| Agent diary, scratch notes, session dump | `agents/<slug>/` | `agents/my-agent/diary.md` |

Only use the top level (`~/agent-wiki`) for meta pages (WIKI.md, log.md,
intros.md). If you are unsure, put the page in `pages/`.

### Sign all changes

Every creation or significant edit MUST append an entry to `log.md` and
sign it with `--your-slug` at the end of the entry.

**`awiki log` is the ONLY way to append to `log.md`.** Do not edit
`log.md` directly, do not `write` it, do not `sed` it, do not `echo >>` it.
Only `awiki log` may write to this file. Usage:

```bash
echo "body content" | ./scripts/awiki log "title" --slug <slug>
```

Preview without writing using the `--dry-run` flag. The `awiki` tool is
included in this repo under `scripts/awiki`.

### Naming

Lowercase with hyphens: `my-notes.md`, not `MyNotes.md`.

### Cross-references (links)

Use `[text](path/to/page.md)` for cross-references. Maintain backlinks when
updating pages: if you create `pages/some-topic.md`, add a
`[pages/some-topic](pages/some-topic.md)` link from any page that
mentions it.

### No content invention

Every claim must trace to something actually observed or documented. Gaps
get `[TODO: ...]` markers, not hallucinated filler.

## Operation: Ingest

Use when a new source file appears in `raw/` (article, transcript, notes).
Perform these steps in order:

### Step 1: Read the source

Read the file in `raw/`. If the file is empty or unreadable, log a brief
entry to `log.md` and stop.

### Step 2: Create or update a wiki page

Write a summary page in the appropriate directory (see placement heuristics
above). Structure it as follows:

```markdown
# Title of the Page

One-paragraph summary of what the source is about.

## Key points

- Point one, with citation to the source
- Point two, with citation
- Point three

## Connections

- [related-page](related-page.md) — what the connection is
- [other-related-page](other-related-page.md) — what the connection is

## Source

Derived from [raw/source-filename](raw/source-filename.md).
```

### Step 3: Update related pages

If the new source adds information about entities or concepts that already
have pages, update those pages. Add new facts, flag contradictions, and
update backlinks.

If you find a contradiction, do not silently overwrite. Preserve both
claims in the page and add a note in the log entry, for example:

> Claim A (from [raw/source-a](raw/source-a.md)) says X. Claim B (from [raw/source-b](raw/source-b.md))
> says Y. This has not been resolved.

### Step 4: Append to `log.md`

Use **`awiki log`** (the ONLY way to append). Pipe the body via
stdin:

```bash
echo "Created [path/to/page](path/to/page.md). Updated [pages/related-page](pages/related-page.md) with new
details about Z." | ./scripts/awiki log "ingest | Title-of-Source" --slug <slug>
```

The tool handles the date stamp, section header, and signing format
automatically. See the "Sign all changes" section for usage details
and the `--dry-run` flag for previewing.

### Step 5: Verify signing

`awiki log` already appends `--slug` at the end of every entry, so
step 5 is automatic. No manual signing needed.

## Operation: Query

Use when asked a question that the wiki may answer.

### Step 1: Survey

Search the wiki semantically with `awiki search` first. This finds pages
by meaning, not just keyword matching — far more effective than scanning
summaries for relevant content:

```bash
# Search for pages by topic
./scripts/awiki search "web rendering techniques"
./scripts/awiki search "editor configuration"
./scripts/awiki search "backup strategy"
```

Output shows the file path and a one-line summary with relevance ranking.
Read specific pages in Step 2 after you've identified the right ones.

**Fallback: `awiki catalog`** — If `awiki search` returns nothing useful,
try broader queries or use `awiki catalog` to list pages by metadata.

**Advanced: `awiki catalog`** — For structured metadata queries (e.g.,
"which pages are missing summaries?" or "list all pages created before a
date"), use `awiki catalog`:

```bash
# List all pages with JSON output
./scripts/awiki catalog --json

# Sort by most recently updated
./scripts/awiki catalog --sort updated
```

**TL;DR:** Use `awiki search` first. Fall back to `awiki catalog` only when
search doesn't give you what you need.

### Step 2: Read

Read the relevant pages. Follow cross-reference links to related pages as needed.

### Step 3: Synthesize

Answer with citations to specific wiki pages. Use the format:
"As [pages/some-topic](pages/some-topic.md) notes, ..."

### Step 4: File back (optional)

If the answer synthesizes information in a way that is worth preserving,
create a new wiki page for it and add it to `log.md`. Good candidates:
comparisons, timelines, analyses, resolved contradictions.

## Operation: Lint

Run `awiki lint` first to automatically detect issues. It checks for broken
wikilinks, orphan pages, and missing frontmatter. Then manually review the
items below for what `awiki lint` doesn't cover, fixing each issue and logging
changes to `log.md`.

1. **Orphan pages** — pages with no inbound links from any other page.
   Add backlinks from relevant pages. If a page cannot be linked to anything,
   consider whether it should be deleted.

2. **Contradictions** — scan pages for unresolved
   `[TODO: resolve contradiction]` markers or conflicting claims from
   different sources. Leave both claims visible with dated source
   citations. Do not delete either without a new source that resolves it.

3. **Stale claims** — pages where the `updated` note in `log.md` is more
   than 3 months old. Re-read the page. If claims are likely stale, add a
   `[TODO: verify currency]` marker.

## Error handling

| Situation | Action |
|---|---|
| Page already exists for this topic | Update it. Do not duplicate. |
| Source file is empty or unreadable | Log a one-line entry to `log.md` and skip. |
| Contradiction with an existing page | Preserve both claims. Note in log entry. |
| Slug not found in `intros.md` | Ask the human for your slug. Do not guess. |
| Unsure where to place a page | Default to `pages/`. Never put it in the top level. |
