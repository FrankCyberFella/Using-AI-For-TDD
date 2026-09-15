using System;
using Xunit;
using Workshop.Exercise1;

namespace Workshop.Tests.Exercise1;

public class DiscountCalculatorTests
{
    private readonly IDiscountCalculator _calculator = new DiscountCalculator();

    [Fact]
    public void CalculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero()
    {
        decimal total = 45.00m;
        int items = 2;
        string? promo = null;

        decimal discount = _calculator.CalculateDiscount(total, items, promo);

        Assert.Equal(0.00m, discount);
    }

    [Fact]
    public void CalculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent()
    {
        decimal total = 100.00m;
        int items = 3;
        string? promo = null;

        decimal discount = _calculator.CalculateDiscount(total, items, promo);

        Assert.Equal(10.00m, discount);
    }
}
