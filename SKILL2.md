---
name: agent-wiki
description: Use when researching, searching the web, or answering questions beyond general knowledge. Do not use when the answer is already known without research. Saves findings to a persistent wiki so knowledge compounds.
compatibility: opencode, claude-code
---

# The Agent Wiki

## Introduction

The Agent Wiki is a persistent, shared, interlinked collection of markdown
documents maintained by AI agents.

The aim is for agent knowledge to compound over time.  Research continually
enriches the shared wiki rather than each session re-deriving from scratch.

## Indicative structure

- `WIKI.md` - local convention document
- `log.md` - changelog
- `intros.md` - agent introductions
- `pages/` - directory holding the pages themslves
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

## Conventions

### No ownership

Any agents may create or edit any page.  Pages are not owned by specific
agents.

Provenance is tracked via `log.md`.

### Sign all changes

Each page creation or significant edit MUST have an accompanying log entry.

`awiki log` MUST be used to do this - do not edit the log file directly.

Example usage:

```bash
echo "<log entry text>" | ./scripts/awiki log "title" --slug <agent_slug>
```

Each agent will be identified by a agent slug such as `code-planner`,
`researcher`, `copyeditor`, etc.

Check `intros.md` to discover your slug.  If it is missing select a slug and
add it to that file.

### YAML frontmatter

Each page in the wiki should have the following YAML frontmatter keys:

- `title`
- `summary`
  - A short summary of the contents of the page.  160 characters max.
- `created`
  - an iso date
- `updated`
  - an iso date

For example

```yaml
---
title: Michael Crichton
summary: American author (1942–2008), master of the techno-thriller — reading guide and book rankings
created: 2026-07-01
updated: 2026-07-01
---

# Michael Crichton

[...]

```

### File naming

Lowercase with hyphens: `my-notes.md`, not `MyNotes.md`.

### Cross-references (hyperlinks)

Use internal markdown links (`[text](pages/some-page.md)`) for
cross-references.  Maintain backlinks when updating pages.  If you create
`pages/some-topic.md`, add a `[pages/some-topic](pages/some-topic.md)` link
from any page that mentions it.

### No content invention

Every claim must trace to something actually observed or documented.  Cite that
source directly (via external hyperlink, ideally).

Knowledge gaps should have `[TODO: ...]` markers attached, not hallucinated
filler.

### Local overrides

Commit local alterations (or additions) to these rules into `WIKI.md` and
accord that file a higher precendence over this skill file when working with
the wiki.

## Operations

### Ingestion

Used for ingesting documents, for example from `./raw`.

#### Step 1: Read the source

Read the file directly.  If it is empty or unreadable, do not continue further
but noisily exit.

#### Step 2: Create or update a wiki page

Write a summary page.  Include frontmatter and the the page itself in markdown
format.

#### Step 3: Update related pages

If the source provided information about entities or concepts that already have
pages, update those pages. Add new facts, flag contradictions, and update
backlinks.

If you find a contradiction, do not silently overwrite. Preserve both
claims in the page and add a note in the log entry, for example:

> Claim A (from [raw/source-a](raw/source-a.md)) says X. Claim B (from
> [raw/source-b](raw/source-b.md)) says Y. This has not been resolved.

### Step 4: Append to the log

Use `awiki log` as described above`

### Querying

#### Step 1: Survey the wiki

Search the wiki semantically via `awiki search` first.  This finds pages by
meaning, not just by keyword match, and is far more effective than scanning
summaries for relevant content or just grepping the wiki.

```bash
# Search for pages by topic
./scripts/awiki search "science fiction"
./scripts/awiki search "editor configuration"
./scripts/awiki search "backup strategy"
```

There is also `awiki catalog` if neccessary, but it's a blunter tool.

#### Step 2: Read

Read all relevant pages.  Follow cross references and continue reading further
as needed, until all relevant material has been read.

#### Step 3: Read further if necessary

Follow any sources found in the wiki.  But also use general web searches and
any other data that is available to you (private documents, databases, etc) to
investigate further.

#### Step 3: Synthesise

Answer with citations to specific sources:

For example, with the format:

> As [some person](http://some-person.com/about-thing.html) describes, ...

#### Step 4: File back as ncessary

Unless the sythesis was trivially produced from existing wiki pages: record the
synthesised material, including the source citations, back into the wiki.

Record to the log with `awiki log` as described above.

### Linting

#### Step 1: Run the linter

Run `awiki lint` to detect issues.

#### Step 2: Correct the issues

Fix whatever issues are resolved.  Confer with the user if there is any ambiguity.
