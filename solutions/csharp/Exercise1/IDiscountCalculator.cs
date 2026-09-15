namespace Workshop.Exercise1;

public interface IDiscountCalculator
{
    decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode);
}

public class DiscountCalculator : IDiscountCalculator
{
    private const decimal DiscountThreshold = 100.00m;
    private const decimal DiscountRate = 0.10m;

    public decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode)
    {
        // Exercise 1, Test: CalculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero
        // Carts below the $100 threshold get no discount.
        if (cartTotal < DiscountThreshold)
        {
            return 0.00m;
        }

        // Exercise 1, Test: CalculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent
        // Carts at or above $100 receive a flat 10% discount.
        return cartTotal * DiscountRate;
    }
}
