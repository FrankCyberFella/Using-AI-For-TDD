# Using AI For TDD — Workshop

Run `setup-workshop.sh` to scaffold the exercise workspaces for each language:

- **C#**: `cd csharp && dotnet test`
- **Java**: `cd java && mvn test`
- **Python**: `cd python && pytest`
- **JavaScript**: `cd javascript && npm install && npm test`

All exercises start in a failing ("red") state — implementing the stubs to make the tests pass is the point of the workshop.

## C# requires the .NET 8 runtime

The C# workspace targets `net8.0`. If your machine's default `dotnet` on `PATH` doesn't include the .NET 8 runtime (check with `dotnet --list-runtimes`), install it separately:

```
brew install dotnet@8
```

Then run tests with that SDK explicitly instead of the default `dotnet`:

```
/opt/homebrew/opt/dotnet@8/libexec/dotnet test Workshop.Tests/Workshop.Tests.csproj
```
