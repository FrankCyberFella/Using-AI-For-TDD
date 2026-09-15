namespace Workshop.Exercise1;

public interface IDiscountCalculator
{
    decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode);
}

public class DiscountCalculator : IDiscountCalculator
{
    public decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode)
    {
        throw new NotImplementedException();
    }
}
