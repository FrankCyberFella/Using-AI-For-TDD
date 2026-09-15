namespace Workshop.Exercise2;

public interface IPasswordValidator
{
    bool Validate(string? password);
}

public class PasswordValidator : IPasswordValidator
{
    private const int MinLength = 8;

    public bool Validate(string? password)
    {
        // Exercise 2, Test: Validate_NullOrEmpty_ReturnsFalse
        // Reject null, empty, or whitespace-only input up front.
        if (string.IsNullOrWhiteSpace(password))
        {
            return false;
        }

        // Exercise 2, Test: Validate_LessThanEightCharacters_ReturnsFalse
        // Enforce a minimum length.
        if (password.Length < MinLength)
        {
            return false;
        }

        bool hasUpper = false, hasLower = false, hasDigit = false, hasSpecial = false;
        foreach (char c in password)
        {
            if (char.IsUpper(c)) hasUpper = true;
            else if (char.IsLower(c)) hasLower = true;
            else if (char.IsDigit(c)) hasDigit = true;
            else if (!char.IsWhiteSpace(c)) hasSpecial = true;
        }

        // Exercise 2, Test: Validate_MissingUppercase_ReturnsFalse
        // Require an uppercase letter, a lowercase letter, and a special character
        // as part of the same "complex password" rule.
        if (!hasUpper || !hasLower || !hasSpecial)
        {
            return false;
        }

        // Exercise 2, Test: Validate_MissingDigit_ReturnsFalse
        // Require at least one digit.
        if (!hasDigit)
        {
            return false;
        }

        // Exercise 2, Test: Validate_ContainsSequentialDigits_ReturnsFalse
        // Reject any run of three ascending sequential digits (e.g. "123").
        if (HasSequentialDigits(password))
        {
            return false;
        }

        // Exercise 2, Test: Validate_ValidComplexPassword_ReturnsTrue
        // Anything that clears all the checks above is a valid password.
        return true;
    }

    private static bool HasSequentialDigits(string password)
    {
        for (int i = 0; i < password.Length - 2; i++)
        {
            if (char.IsDigit(password[i]) && char.IsDigit(password[i + 1]) && char.IsDigit(password[i + 2]))
            {
                int a = password[i] - '0';
                int b = password[i + 1] - '0';
                int c = password[i + 2] - '0';
                if (b == a + 1 && c == b + 1)
                {
                    return true;
                }
            }
        }
        return false;
    }
}
