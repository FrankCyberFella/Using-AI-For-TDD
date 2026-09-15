package workshop.exercise1;

import java.math.BigDecimal;

public class DefaultDiscountCalculator implements DiscountCalculator {
    @Override
    public BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode) {
        throw new UnsupportedOperationException("Method not implemented");
    }
}
