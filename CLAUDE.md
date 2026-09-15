# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Workshop materials for teaching TDD with AI assistance. It's not an application — it's four parallel, self-contained exercise workspaces (one per language), each with the same three exercises, plus a slide deck (`TDD_with_AI_Workshop.pptx`) and a scaffolding script.

## Repo layout

- `exercises/<language>/` — the workspace attendees work in. Contains failing/stub code to implement.
- `solutions/<language>/` — reference implementations, not wired into any build. Each file has comments tagging which test in the corresponding `exercises/` test file it satisfies. Never runnable in place; solution files are meant to be copied over their `exercises/` counterpart to check work or unblock someone stuck.
- `setup-workshop.sh` — regenerates the entire `exercises/` tree from scratch at `$HOME/TrainingMaterial/Using-AI-For-TDD/exercises` (a fixed path under `$HOME`, independent of where this repo is cloned). Running it does not touch this repo; it's how the workshop is freshly scaffolded for a new attendee/session. If `exercises/` structure changes, `BASE_DIR` and the per-language heredocs in this script must be kept in sync manually — nothing generates the script from the checked-in `exercises/` tree or vice versa.

## The exercise pattern (same across all four languages)

- **Exercise 1 & 2**: empty stubs (`return false`, `throw NotImplementedError`, etc.) — implement from scratch using TDD to make the failing tests pass.
- **Exercise 3**: a fully working but deliberately messy `OrderProcessor` (nested conditionals, terse variable names like `disc`/`calc`, magic numbers for state tax rates and loyalty-discount tiers) — tests already pass; the exercise is to add coverage and refactor safely under it.

The four language implementations of Exercise 3 are intentionally kept in lockstep: same state tax rates (OH 5.75%, AZ 5.6%, TX 6.25%), same loyalty-discount tiers (≥5yr 15%, ≥2yr 5%, member-but-<2yr 2%), same test cases/expected values. When changing one language's Exercise 3, mirror the change in the other three.

## Commands

```
- **C#**: `cd exercises/csharp && dotnet test`
- **Java**: `cd exercises/java && mvn test`
- **Python**: `cd exercises/python && pytest`
- **JavaScript**: `cd exercises/javascript && npm install && npm test`
```

Run a single test:
- C#: `dotnet test --filter FullyQualifiedName~DiscountCalculatorTests`
- Java: `mvn test -Dtest=DiscountCalculatorTest`
- Python: `pytest exercise1/test_discount_calculator.py`
- JavaScript: `npx jest discountCalculator.test.js`

### C# requires the .NET 8 runtime

The C# workspace targets `net8.0`. If the machine's default `dotnet` on `PATH` doesn't include the .NET 8 runtime (check with `dotnet --list-runtimes`), install it separately (`brew install dotnet@8`) and invoke that SDK explicitly instead of the default `dotnet`:

```
/opt/homebrew/opt/dotnet@8/libexec/dotnet test exercises/csharp/Workshop.Tests/Workshop.Tests.csproj
```

## Verifying a solution against its exercise's tests

`solutions/` files aren't part of any build, so there's no single command to check them. To verify, copy the solution file over its `exercises/` counterpart (in a scratch copy of the tree, not in place) and run that language's test command above.
