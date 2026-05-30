---
name: "ttb-cross-functional-analysis-gate"
description: "Mandatory cross-functional analysis and question gate for feature updates, new feature development, and bug fixes."
version: "1.0.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
tags: ["product-analysis", "requirements", "ux", "architecture", "qa", "clarification"]
---

# Cross-Functional Analysis Gate

Apply this gate whenever the user asks to update an existing feature, develop a new feature, fix a bug, debug a regression, change business logic, change UX flow, or alter architecture.

## Required Lenses

Before proposing design or implementation, analyze the request through all roles below:

| Lens | Required evaluation |
|------|---------------------|
| Product Owner | Business goal, user value, priority, scope boundaries, measurable success criteria |
| Business Analyst | Current flow, target flow, business rules, data requirements, acceptance criteria |
| UX/UI Designer | User journey, interaction model, accessibility, empty/loading/error states, design-system fit |
| Solution Architect | Architecture fit, module boundaries, data/API contracts, security, scalability, operational impact |
| Senior Developer | Reuse-first plan, implementation complexity, maintainability, performance, technical debt |
| QA | Test strategy, regression surface, edge cases, real production scenarios, release readiness |

## Option Exploration

For non-trivial work, compare at least two viable implementation directions before recommending one. Evaluate each option across:

- Business correctness and user value
- Architecture and integration impact
- UI/UX consistency and interaction quality
- Performance and resource usage
- Scalability and future extensibility
- Maintainability, testability, security, and operational risk

Recommend the option that best fits the existing codebase, product constraints, and long-term maintainability. Include key pros, cons, and the reason for rejection of alternatives.

## Value-Expansion Questions

After initial analysis, ask at least 5 questions that may improve the outcome beyond the original request. Focus on:

- Better user flow or fewer steps
- Adjacent interactions or related features that add value
- Feedback states, confirmations, notifications, and recovery paths
- Personalization, automation, analytics, observability, or accessibility
- QA coverage, release safety, and operational monitoring

These questions identify potential value; they do not expand scope unless the user explicitly confirms.

## Ambiguity Clarification Questions

If the request is unclear, incomplete, contradictory, or unsafe to design/build from current context, stop before design or development and ask at least 6 clarification questions. Cover:

- Business expectation, priority, and acceptance criteria
- Target users, UX flow, navigation, and interaction states
- Data model, storage, lifecycle, migration, and ownership
- API contracts, integrations, error handling, and offline/failure modes
- Security, permissions, privacy, abuse cases, and compliance constraints
- Performance, scalability, concurrency, device/version support, and resource limits
- Edge cases and realistic production scenarios

Do not treat value-expansion questions as blockers. Treat ambiguity clarification questions as blockers when the answer can change architecture, business behavior, data persistence, API shape, security, navigation, or user-visible outcomes.

## Best-Practice Review

Before finalizing any solution, review applicable best practices from active TTBaseUIKit/TTBaseSUI rules, product workflow, UX/UI design system, architecture constraints, coding standards, QA strategy, release process, observability, and operations.
