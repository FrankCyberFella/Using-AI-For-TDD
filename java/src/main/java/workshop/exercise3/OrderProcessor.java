package workshop.exercise3;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class OrderProcessor {
    public OrderResult processOrder(BigDecimal amount, String state, boolean isMember, int loyaltyYears) {
        if (amount != null && amount.compareTo(BigDecimal.ZERO) > 0) {
            if ("OH".equals(state) || "AZ".equals(state) || "TX".equals(state)) {
                BigDecimal tax;
                if ("OH".equals(state)) {
                    tax = amount.multiply(new BigDecimal("0.0575"));
                } else if ("AZ".equals(state)) {
                    tax = amount.multiply(new BigDecimal("0.056"));
                } else {
                    tax = amount.multiply(new BigDecimal("0.0625"));
                }

                BigDecimal disc = BigDecimal.ZERO;
                if (isMember) {
                    if (loyaltyYears >= 5) {
                        disc = amount.multiply(new BigDecimal("0.15"));
                    } else if (loyaltyYears >= 2) {
                        disc = amount.multiply(new BigDecimal("0.05"));
                    } else {
                        disc = amount.multiply(new BigDecimal("0.02"));
                    }
                }

                BigDecimal calc = amount.add(tax).subtract(disc);
                if (calc.compareTo(BigDecimal.ZERO) < 0) {
                    calc = BigDecimal.ZERO;
                }

                BigDecimal finalAmount = calc.setScale(2, RoundingMode.HALF_UP);
                return new OrderResult(true, finalAmount, "Processed");
            } else {
                return new OrderResult(false, BigDecimal.ZERO, "Unsupported State");
            }
        } else {
            return new OrderResult(false, BigDecimal.ZERO, "Invalid Amount");
        }
    }
}
