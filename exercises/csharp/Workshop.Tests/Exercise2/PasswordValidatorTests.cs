using Xunit;
using Workshop.Exercise2;

namespace Workshop.Tests.Exercise2;

public class PasswordValidatorTests
{
    private readonly IPasswordValidator _validator = new PasswordValidator();

    [Fact]
    public void Validate_NullOrEmpty_ReturnsFalse()
    {
        Assert.False(_validator.Validate(null));
        Assert.False(_validator.Validate(""));
        Assert.False(_validator.Validate("   "));
    }

    [Fact]
    public void Validate_LessThanEightCharacters_ReturnsFalse()
    {
        Assert.False(_validator.Validate("Abc123!"));
    }

    [Fact]
    public void Validate_MissingUppercase_ReturnsFalse()
    {
        Assert.False(_validator.Validate("password123!"));
    }

    [Fact]
    public void Validate_MissingDigit_ReturnsFalse()
    {
        Assert.False(_validator.Validate("PasswordDef!"));
    }

    [Fact]
    public void Validate_ContainsSequentialDigits_ReturnsFalse()
    {
        Assert.False(_validator.Validate("PassWord123!"));
    }

    [Fact]
    public void Validate_ValidComplexPassword_ReturnsTrue()
    {
        Assert.True(_validator.Validate("Str0ng!Pass9"));
    }
}
