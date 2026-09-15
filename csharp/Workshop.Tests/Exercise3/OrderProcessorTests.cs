using Xunit;
using Workshop.Exercise3;

namespace Workshop.Tests.Exercise3;

public class OrderProcessorTests
{
    private readonly OrderProcessor _processor = new OrderProcessor();

    [Theory]
    [InlineData(0, "OH", "Invalid Amount")]
    [InlineData(-10, "AZ", "Invalid Amount")]
    public void ProcessOrder_InvalidAmount_ReturnsFailure(decimal amount, string state, string expectedMsg)
    {
        var result = _processor.ProcessOrder(amount, state, false, 0);

        Assert.False(result.IsSuccess);
        Assert.Equal(0, result.FinalAmount);
        Assert.Equal(expectedMsg, result.Message);
    }

    [Fact]
    public void ProcessOrder_UnsupportedState_ReturnsFailure()
    {
        var result = _processor.ProcessOrder(100.00m, "NY", false, 0);

        Assert.False(result.IsSuccess);
        Assert.Equal("Unsupported State", result.Message);
    }

    [Theory]
    [InlineData(100.00, "OH", false, 0, 105.75)]
    [InlineData(100.00, "AZ", false, 0, 105.60)]
    [InlineData(100.00, "TX", false, 0, 106.25)]
    public void ProcessOrder_ValidNonMember_CalculatesCorrectTax(
        decimal amount, string state, bool isMember, int loyaltyYears, decimal expectedFinal)
    {
        var result = _processor.ProcessOrder(amount, state, isMember, loyaltyYears);

        Assert.True(result.IsSuccess);
        Assert.Equal(expectedFinal, result.FinalAmount);
        Assert.Equal("Processed", result.Message);
    }

    [Theory]
    [InlineData(100.00, "OH", true, 1, 103.75)]
    [InlineData(100.00, "OH", true, 3, 100.75)]
    [InlineData(100.00, "OH", true, 7, 90.75)]
    public void ProcessOrder_MemberDiscounts_AppliesCorrectTiers(
        decimal amount, string state, bool isMember, int loyaltyYears, decimal expectedFinal)
    {
        var result = _processor.ProcessOrder(amount, state, isMember, loyaltyYears);

        Assert.True(result.IsSuccess);
        Assert.Equal(expectedFinal, result.FinalAmount);
    }
}
