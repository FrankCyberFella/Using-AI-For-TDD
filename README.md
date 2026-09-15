# Using AI For TDD — Workshop

Run `setup-workshop.sh` to scaffold the exercise workspaces for each language:

- **C#**: `cd exercises/csharp && dotnet test`
- **Java**: `cd exercises/java && mvn test`
- **Python**: `cd exercises/python && pytest`
- **JavaScript**: `cd exercises/javascript && npm install && npm test`

All exercises start in a failing ("red") state — implementing the stubs to make the tests pass is the point of the workshop.

Each language follows the same exercise pattern:

- **Exercise 1 & 2**: empty stubs (e.g. `return false`, `throw NotImplementedError`) — build the implementation from scratch using TDD.
- **Exercise 3**: a fully working but deliberately messy implementation (nested conditionals, terse variable names, magic numbers) — the behavior is already correct, so the exercise is to add test coverage and refactor safely under it.

Reference solutions for every exercise and language are in `solutions/`, with comments marking which test each part of the implementation satisfies. They aren't wired into the build — copy the relevant file over its stub under `exercises/` to check your own implementation or unblock if you get stuck.

## C# requires the .NET 8 runtime

The C# workspace targets `net8.0`. If your machine's default `dotnet` on `PATH` doesn't include the .NET 8 runtime (check with `dotnet --list-runtimes`), install it separately:

```
brew install dotnet@8
```

Then run tests with that SDK explicitly instead of the default `dotnet`:

```
/opt/homebrew/opt/dotnet@8/libexec/dotnet test exercises/csharp/Workshop.Tests/Workshop.Tests.csproj
```
