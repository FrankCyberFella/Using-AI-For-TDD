package workshop.exercise1;

import java.math.BigDecimal;

public interface DiscountCalculator {
    BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode);
}
