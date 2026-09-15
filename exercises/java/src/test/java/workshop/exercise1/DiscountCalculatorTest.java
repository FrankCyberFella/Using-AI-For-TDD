package workshop.exercise1;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class DiscountCalculatorTest {
    private DiscountCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new DefaultDiscountCalculator();
    }

    @Test
    void calculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero() {
        BigDecimal total = new BigDecimal("45.00");
        int items = 2;
        String promo = null;

        BigDecimal discount = calculator.calculateDiscount(total, items, promo);

        assertEquals(new BigDecimal("0.00"), discount);
    }

    @Test
    void calculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent() {
        BigDecimal total = new BigDecimal("100.00");
        int items = 3;
        String promo = null;

        BigDecimal discount = calculator.calculateDiscount(total, items, promo);

        assertEquals(new BigDecimal("10.00"), discount);
    }
}
