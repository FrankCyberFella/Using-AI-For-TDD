package workshop.exercise1;

import java.math.BigDecimal;

// Unchanged supporting interface from exercises/java — not part of the exercise itself.
public interface DiscountCalculator {
    BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode);
}
