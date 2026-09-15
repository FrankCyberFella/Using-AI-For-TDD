package workshop.exercise1;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class DefaultDiscountCalculator implements DiscountCalculator {

    private static final BigDecimal DISCOUNT_THRESHOLD = new BigDecimal("100.00");
    private static final BigDecimal DISCOUNT_RATE = new BigDecimal("0.10");

    @Override
    public BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode) {
        // Exercise 1, Test: calculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero
        // Carts below the $100 threshold get no discount.
        if (cartTotal.compareTo(DISCOUNT_THRESHOLD) < 0) {
            return new BigDecimal("0.00");
        }

        // Exercise 1, Test: calculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent
        // Carts at or above $100 receive a flat 10% discount.
        return cartTotal.multiply(DISCOUNT_RATE).setScale(2, RoundingMode.HALF_UP);
    }
}
