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
enriches the shared wiki rather than each session needlessly re-deriving things
from scratch.

## Indicative structure

- `WIKI.md` - local convention document
- `log.md` - changelog
- `intros.md` - agent introductions
- `pages/` - directory holding the pages themselves
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

### Quality standards

*Cite every claim*.  Every factual claim in a wiki page must trace to an observable source.  No unattributed assertions.

*Label unsupported content*.  Use confidence markers when a claim falls short of the cite-everything bar:

- `[INFERRED: <reasoning>]` - a deduction or interpretation, not a retrieved fact
- `[UNCONFIRMED: <source>]` - a single source claims something but this could not be corroborated
- `[UNKNOWN: <topic>]` - genuinely unknown, no source was found

*Verify before citing*.  Before citing a source, check that it actually says what you are claiming it does.  A citation that looks relevant but which does not support the claim is worse than no citation as it creates false confidence.

*Distinguish the relative strength of claims*.  When presenting your findings, separate:

- Established fact (multiple different sources, no serious dispute)
- Common practice/knowledge (widely thought or done but not formally documented)
- Rank speculation (plausible but without evidence)

*Flag weak sources*.  Note well in the wiki if the evidence is:

- A single source - just one someone claiming something
-  Stale - older than current (for whatever current is within that specific field)
- Low-authority - a personal blog, social media, unknown origin

Weak sources are useful and should not be discarded.  They just need to be appropriately marked.

*Surface all disagreement*.  When sources conflict, present both arguments and log the contention.  Do not silently select one or tother.

*Say when it is unknown, or when you don't know*.  If a solid answer cannot be found, simply say so and explain why that might be.  An honest gap is to be **strongly** preferred to a confident but wrong answer.  Mark as `[UNKNOWN: ...]` and move forward.

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

### Output template

Beyond the frontmatter, follow this output template:

[...TBD...]

### File naming

Lowercase with hyphens: `my-notes.md`, not `MyNotes.md`.

### Cross-references (hyperlinks)

Use internal markdown links (`[text](pages/some-page.md)`) for
cross-references.  Maintain back-links when updating pages.  If you create
`pages/some-topic.md`, add a `[pages/some-topic](pages/some-topic.md)` link
from any page that mentions it.

### Local overrides

Commit local alterations (or additions) to these rules into `WIKI.md` and
accord that file a higher precedence over this skill file when working with
the wiki.

## Operations

### Ingestion

Used for ingesting documents, for example from `./raw`.

#### Step 1: Read the source

Read the file directly.  If it is empty or unreadable, do not continue further
but noisily exit.

#### Step 2: Create or update a wiki page

Write a summary page.  Include front-matter and the page itself in markdown
format.

#### Step 3: Update related pages

If the source provided information about entities or concepts that already have
pages, update those pages. Add new facts, flag contradictions, and update
back-links.

If you find a contradiction, do not silently overwrite. Preserve both
claims in the page and add a note in the log entry, for example:

> Claim A (from [raw/source-a](raw/source-a.md)) says X. Claim B (from
> [raw/source-b](raw/source-b.md)) says Y. This has not been resolved.

### Step 4: Append to the log

Use `awiki log` as described above

### Research

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

There is also `awiki catalog` if necessary, but it's a blunter tool.

#### Step 2: Read

Read all collected material.

#### Step 3: Assess - and widen the survey if needed

Check what you have against these criteria:

1. Can you cite a good source for each claim
2. Have you checked at least two independent sources for the core topic?
3. If sources disagree, have you noted the dispute rather than silently picked one?

Consider the general Quality Standards above.

If not, widen the survey:

- Follow sources referred to in the wiki
- Perform general web searches
- Consult any specifically relevant resources you know of
- Use any other information sources available to you
- Re-search the wiki with any new terminology you've discovered

Then go back to step 2.

If after a few rounds of widening you still can't pass the checklist, mark the
remaining gaps (eg with `[UNKNOWN]` or `[UNCONFIRMED]`) and move on.  It's
better to answer partially than loop forever.

#### Step 4: Synthesise

Answer with citations to specific sources:

For example, with the format:

> As [some person](http://some-person.com/about-thing.html) describes, ...

#### Step 5: File back

If the synthesis adds something new to the wiki, file it back.

Record to the log with `awiki log` as described above.

### Linting

#### Step 1: Run the linter

Run `awiki lint` to detect issues.

#### Step 2: Correct the issues

Fix whatever issues are resolved.  Confer with the user if there is any ambiguity.
