---
name: obsidian-cli
description: Use the Obsidian CLI to interact with the vault natively—search, read, create, manage tasks, properties, daily notes, and more. Prefer CLI over raw file I/O for vault-aware operations.
---

# Obsidian CLI

The Obsidian CLI lets you interact with the vault through Obsidian itself, meaning operations respect plugins, templates, properties, wikilinks, and vault settings.

> [!IMPORTANT]
> **Obsidian must be running** for the CLI to work. If it isn't, the first command will launch it (which takes a few seconds).

## When to Use CLI vs Raw File I/O

| Use CLI when… | Use raw file I/O when… |
|---|---|
| Creating files that should use Obsidian templates | Bulk-editing file content with precise line targeting |
| Reading/writing daily notes (respects daily note settings) | Viewing file outlines or code structure |
| Searching vault content (respects excludes, understands links) | Programmatic multi-file transformations |
| Managing properties/frontmatter | Reading files you'll immediately edit with replace tools |
| Listing/querying tasks across the vault | Operations on non-markdown files |
| Appending/prepending to files (respects frontmatter) | When Obsidian isn't running and you don't want to launch it |
| Getting file metadata (size, dates, links) | |

**Rule of thumb:** If the operation is *about the vault* (search, tasks, properties, daily notes), use CLI. If it's *about the file content* (editing specific lines), use file tools.

## Agent Guidelines / Best Practices

- **Prefer `obsidian search`** over `find` or `grep` for locating files within the vault. It is context-aware and handles strict pathing better.
  - *Example*: "Find GEMINI.md" -> `obsidian search query="file:GEMINI.md"`
- **Fallback Behavior**: Only use standard shell tools (`ls`, `find`) if `obsidian-cli` fails (e.g., Obsidian is not running).

## Syntax

```
obsidian [vault=<name>] <command> [parameter=value] [flags]
```

- **Parameters**: `key=value` — quote values with spaces: `name="My Note"`
- **Flags**: Boolean switches, no value needed (e.g., `silent`, `overwrite`, `newtab`)
- **Vault targeting**: If the terminal's working directory is inside a vault, it's used automatically. Otherwise specify `vault=<name>`.
- **File targeting**:
  - `file=<name>` — matches by filename (like a wikilink, no extension needed)
  - `path=<path>` — exact path from vault root (e.g., `01. Projects/Work/README.md`)
- **Output**: Add `--copy` to any command to copy output to clipboard.

## Command Reference

### Files and Folders

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `open` | Open a file in Obsidian | `file`, `path`, `newtab` |
| `create` | Create or overwrite a file | `name`, `path`, `content`, `template`, `overwrite`, `silent`, `newtab` |
| `read` | Read file contents | `file`, `path` |
| `append` | Append content to a file | `file`, `path`, `content`, `inline` |
| `prepend` | Prepend content after frontmatter | `file`, `path`, `content`, `inline` |
| `move` | Move or rename a file | `file`, `path`, `to` |
| `delete` | Delete a file (trash by default) | `file`, `path`, `permanent` |
| `file` | Show file info (size, dates, links) | `file`, `path` |
| `files` | List files in vault | `folder`, `ext`, `total` |
| `folders` | List folders | `folder`, `total` |

### Daily Notes

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `daily` | Open today's daily note | `silent` |
| `daily:read` | Read today's daily note | — |
| `daily:append` | Append to today's daily note | `content`, `inline` |
| `daily:prepend` | Prepend to today's daily note | `content`, `inline` |

### Search

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `search` | Search vault content | `query`, `path`, `limit`, `format=text\|json`, `matches`, `case` |

### Tasks

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `tasks` | List tasks (use `all` for vault-wide) | `all`, `daily`, `done`, `todo`, `verbose`, `status="char"` |
| `task` | Show or update a specific task | `ref=path:line`, `toggle`, `done`, `todo` |

### Properties and Metadata

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `properties` | List properties for a file or vault | `file`, `path` |
| `property:read` | Read a specific property value | `file`, `path`, `name` |
| `property:set` | Set a property value | `file`, `path`, `name`, `value`, `type` |
| `property:remove` | Remove a property | `file`, `path`, `name` |
| `tags` | List tags | `all`, `counts`, `sort=count` |
| `aliases` | List aliases | — |

### Plugins and Themes

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `plugins` | List installed/enabled plugins | — |
| `plugin:install` | Install a community plugin | `id`, `enable` |
| `plugin:enable` | Enable a plugin | `id` |
| `plugin:disable` | Disable a plugin | `id` |

### Links and Graph

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `links` | List outgoing links from a file | `file`, `path`, `total` |
| `backlinks` | List backlinks to a file | `file`, `path`, `counts`, `total` |
| `orphans` | List files with no incoming links | `total`, `all` |
| `deadends` | List files with no outgoing links | `total`, `all` |
| `unresolved` | List unresolved (broken) links | `total`, `counts`, `verbose` |

### History and Versions

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `history` | List file history versions | `file`, `path` |
| `history:read` | Read a specific history version | `file`, `path`, `version=<n>` |
| `history:restore` | Restore a previous version | `file`, `path`, `version=<n>` |
| `diff` | Compare file versions | `file`, `path`, `from=<n>`, `to=<n>` |

### Vault Utilities

| Command | Purpose | Key Parameters |
|---------|---------|----------------|
| `vault` | Show vault info | `info=name\|path\|files\|folders\|size` |
| `wordcount` | Count words and characters | `file`, `path`, `words`, `characters` |
| `bookmarks` | List bookmarks | `total`, `verbose` |
| `recents` | List recently opened files | `total` |
| `random:read` | Read a random note | `folder` |

## Practical Examples

### Daily workflow

```bash
# Read today's daily note
obsidian daily:read

# Add a task to today's note
obsidian daily:append content="- [ ] Review PRD for Obsidian CLI agent skill"

# Check open tasks across the vault
obsidian tasks todo all

# Check tasks in today's daily note only
obsidian tasks todo daily
```

### File operations

```bash
# Create a new discovery doc
obsidian create path="01. Projects/Work/New Initiative/Discovery.md" content="# Discovery\n\n## Problem Statement\n\n## Hypotheses\n"

# Create from a template
obsidian create name="Sprint Retro" template="Meeting Notes"

# Read a specific file
obsidian read file="PRD-Obsidian-CLI-skill"

# Append a decision to a file
obsidian append path="01. Projects/Work/Project/decisions/log.md" content="\n## 2026-02-11: Skill Approach\n- **Decision**: Use Obsidian CLI...\n- **Rationale**: Better results than native command line tools"
```

### Search and discovery

```bash
# Find all mentions of a topic
obsidian search query="obsidian cli" limit=10

# Search within a specific folder
obsidian search query="parameters" path="01. Projects/Work"

# Get JSON results for structured processing
obsidian search query="parameters" format=json
```

### Properties and metadata

```bash
# Set status on a document
obsidian property:set path="01. Projects/Work/Initiative/README.md" name=status value=active

# Add tags
obsidian property:set file="Discovery Doc" name=tags value="[discovery, h2]" type=list

# List all tags in the vault with counts
obsidian tags counts sort=count
```

### Project scaffolding

```bash
# Create project files
obsidian create path="01. Projects/Work/new-initiative/README.md" content="---\ntags: [project, active]\nstatus: discovery\ncreated: 2026-02-11\n---\n\n# New Initiative\n\n## Status\n🟡 Discovery\n\n## Problem Statement\n\n## Success Criteria\n\n## Open Questions\n"

obsidian create path="01. Projects/Work/new-initiative/.gemini/GEMINI.md" content="# New Initiative\n\n## Overview\n\n## Key Documents\n\n## Stakeholders\n"
```

> [!NOTE]
> The CLI is in **early access** (Obsidian 1.12+). Commands and syntax may change. Run `obsidian help` to check the latest available commands.
