namespace Workshop.Exercise2;

public interface IPasswordValidator
{
    bool Validate(string? password);
}

public class PasswordValidator : IPasswordValidator
{
    public bool Validate(string? password)
    {
        return false;
    }
}
