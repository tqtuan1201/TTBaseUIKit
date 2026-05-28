# TTBaseUIKit Skill Templates

> Templates for creating new skill sets, prompt files, and rules.
> Follow these templates to maintain consistency and token efficiency.

---

## Directory Structure

```
templates/
  README.md              ← This file
  SKILL.md.template       ← Template for new skill SKILL.md
  prompt.md.template      ← Template for new prompt files
  ttb-clarification-survey.md ← Standard survey patterns for preflight gating
  rule.md.template       ← Template for new rule files
  phase.md.template      ← Template for phase definition files
  fragment.md.template    ← Template for reusable fragments
  skill-index-entry.md   ← YAML entry for skill-registry
```

---

## Guidelines

### When to Create a New Skill

- Only when the task domain is **fundamentally different** from existing skills
- Reuse existing skills and extend with new prompts if possible
- Always check `ttb-skill-registry.md` before creating new skills

### Token Efficiency Rules

1. **Extract shared content** into `fragments/` instead of copying inline
2. **Use shell scripts** for verification/compliance instead of inline bash blocks
3. **Reference phases** from `phases/` instead of duplicating phase definitions
4. **Use fragments** for Iron Laws, markers, and other reusable content
5. **Use preflight gate** — every new skill/prompt must reference `fragments/ttb-preflight-execution-gate.frag.md`
6. **Progressive loading** — set `loadLevel` correctly: `always` / `domain` / `on-demand`

### Naming Conventions

- Skill directory: `ttb-skill-{name}` (kebab-case)
- Skill file: `SKILL.md`
- Prompt files: `ttb-skill-{name}.prompt.md`
- Fragments: `{name}.frag.md`
- Scripts: `ttb-{purpose}.sh`
- Rules: `ttb-rule-{name}.md`
- Phases: `ttb-phase-{name}.md`

### Required Sections in SKILL.md

```markdown
---
name: "ttb-skill-{name}"
description: "Brief description"
version: "1.0.0"
loadLevel: "always|domain|on-demand"
---

# Skill Title

## When
Commands that activate this skill.

## How to Use
Brief usage instructions.

## Commands
| Command | Description |
|---------|-------------|
| /ttb-{name} | Primary command |

## Shared Resources
List of required shared resources from `ttb-skill-shared/`.

## Mandatory Preflight Execution Gate
Run requirement analysis, context validation, ambiguity detection, missing information detection, clarification/survey, confidence scoring, and execution approval before any file modification.

## Token Budget
Session limit and budget notes.
```
