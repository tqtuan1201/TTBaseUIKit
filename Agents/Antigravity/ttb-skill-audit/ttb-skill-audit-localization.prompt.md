---
description: "Localization audit for TTBaseUIKit apps: hardcoded strings, missing keys, wrong XText usage, naming violations."
---

# ttb-skill-audit-localization -- Localization Audit

Audit code for localization issues in TTBaseUIKit apps.

## When

User says: "audit localization", "audit strings", "hardcoded strings", "missing translations"

## 4 Audit Dimensions

### 1. Hardcoded Strings

| Pattern | Check |
|---------|-------|
| `Text("Hello")` | Use `XText("App.Module.Hello")` |
| `setTitle("Submit")` | Use `XText("App.Module.Submit")` |
| `setText(text: "Loading...")` | Use `XText("App.Module.Loading")` |
| `"OK"`, `"Cancel"`, `"Error"` | Use localization keys |
| `placeholder: "Enter name"` | Use `XText("App.Module.Placeholder.Name")` |
| Error messages | Use `XText("App.Error.{Code}")` |
| Success messages | Use `XText("App.Success.{Action}")` |

### 2. Wrong XText / XTextU Usage

| Pattern | Check |
|---------|-------|
| Nav title with `XText` | Use `XTextU("App.{Name}.Nav.Title")` |
| Button text with `XTextU` | Use `XText("App.{Name}.Button.{Action}")` |
| Mixed case in key | Key names use `PascalCase` |
| Lowercase in key | Use uppercase consistent naming |
| Missing `.Nav.Title` suffix | Nav titles use `.Nav.Title` |
| Missing `.Button.{Action}` suffix | Buttons use `.Button.{Action}` |
| Missing `.Field.{Name}` suffix | Form fields use `.Field.{Name}` |
| Missing `.Error.{Code}` suffix | Errors use `.Error.{Code}` |
| Missing `.Placeholder.{Field}` suffix | Placeholders use `.Placeholder.{Field}` |

### 3. Localizable.strings Issues

| Issue | Check |
|-------|-------|
| Missing keys | All `XText`/`XTextU` keys must exist in `Localizable.strings` |
| Duplicate keys | Same key defined multiple times |
| Unused keys | Keys in file not referenced in code |
| Wrong format | `"key" = "value";` (semicolon required) |
| Missing locale | No `en.lproj/Localizable.strings` |
| Plural missing | Count-dependent strings not using `.stringsdict` |
| Interpolation | Hardcoded values instead of `%@` placeholders |

### 4. Key Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Navigation title | `{Module}.{Screen}.Nav.Title` | `"App.Home.Nav.Title"` |
| Button | `{Module}.{Screen}.Button.{Action}` | `"App.Login.Button.Submit"` |
| Form field placeholder | `{Module}.{Screen}.Placeholder.{Field}` | `"App.Register.Placeholder.Email"` |
| Form field label | `{Module}.{Screen}.Field.{Name}` | `"App.Register.Field.Email"` |
| Error message | `App.Error.{Code}` | `"App.Error.Network"` |
| Success message | `App.Success.{Action}` | `"App.Success.Save"` |
| Alert title | `{Module}.Alert.{Context}` | `"App.Profile.Alert.ConfirmDelete"` |
| Tab label | `App.Tab.{Name}` | `"App.Tab.Home"` |
| Empty state | `{Module}.{Screen}.Empty.{Context}` | `"App.Notifications.Empty.NoItems"` |

## Localization Pattern

```swift
// Correct
XText("App.{Module}.Nav.Title")           // Nav title (uppercase)
XText("App.{Module}.Button.Submit")       // Button text
XText("App.{Module}.Placeholder.Email")   // Form placeholder
XText("App.{Module}.Error.Network")       // Error message
XTextU("App.{Module}.Nav.Title")          // Nav title only

// Wrong
Text("Submit")                            // Hardcoded
XText("submit")                           // Wrong case
XText("App.NavTitle")                     // No module
XTextU("App.Button.Submit")               // Button should not be uppercase
```

## Output Format

```
════════════════════════════════════════════
LOCALIZATION AUDIT REPORT
════════════════════════════════════════════

Files Audited: N
Issues Found: N

──────────────────────────────────────────
HARDCODED STRINGS

  [file:line] "Hardcoded string"
    Fix: XText("App.{Module}.{Context}")

──────────────────────────────────────────
WRONG XTEXT USAGE

  [file:line] XTextU used for button text
    Fix: Use XText() for buttons, XTextU() for nav titles only

──────────────────────────────────────────
MISSING KEYS

  Localizable.strings missing:
    "App.{Module}.{Context}" = "Default Value";

──────────────────────────────────────────
NAMING VIOLATIONS

  [file:line] Key does not follow convention
    Expected: "App.Module.Screen.Element"
    Got: "App.Module.{lowercase}"

──────────────────────────────────────────
SUMMARY

  Compliance Score: X/10
  Hardcoded Strings: N
  Missing Keys: N
  Wrong Usage: N
```

## Verification
1. Search for all `Text("` without `XText` or `XTextU`
2. Search for `setText(text: "` with hardcoded strings
3. Compare `Localizable.strings` keys with all `XText`/`XTextU` calls
4. Run app with non-English language

## Post-Audit Verification (MANDATORY)

After all audit checks complete, **run Phase 6 verification**:

1. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
2. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
3. **Audit is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document findings.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
