package workshop.exercise3;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;
import java.util.Set;

// This exercise starts from a working-but-messy implementation; the tests already
// pass before any changes. The refactor below preserves that behavior while
// extracting named constants/helpers for each step the tests exercise.
public class OrderProcessor {

    private static final Set<String> SUPPORTED_STATES = Set.of("OH", "AZ", "TX");

    private static final Map<String, BigDecimal> TAX_RATES_BY_STATE = Map.of(
        "OH", new BigDecimal("0.0575"),
        "AZ", new BigDecimal("0.056"),
        "TX", new BigDecimal("0.0625")
    );

    public OrderResult processOrder(BigDecimal amount, String state, boolean isMember, int loyaltyYears) {
        // Exercise 3, Test: processOrder_InvalidAmount_ReturnsFailure
        // Orders with a non-positive (or missing) amount are rejected before anything else.
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return failure("Invalid Amount");
        }

        // Exercise 3, Test: processOrder_UnsupportedState_ReturnsFailure
        // Only orders shipping to a supported state can be processed.
        if (!SUPPORTED_STATES.contains(state)) {
            return failure("Unsupported State");
        }

        // Exercise 3, Test: processOrder_ValidNonMember_CalculatesTax
        // Apply the state-specific tax rate to the order amount.
        BigDecimal tax = amount.multiply(TAX_RATES_BY_STATE.get(state));

        // Exercise 3, Test: processOrder_MemberDiscounts_AppliesCorrectTiers
        // Members earn a loyalty discount that scales with tenure.
        BigDecimal discount = isMember ? amount.multiply(memberDiscountRate(loyaltyYears)) : BigDecimal.ZERO;

        BigDecimal finalAmount = amount.add(tax).subtract(discount).max(BigDecimal.ZERO);

        return new OrderResult(true, finalAmount.setScale(2, RoundingMode.HALF_UP), "Processed");
    }

    private static BigDecimal memberDiscountRate(int loyaltyYears) {
        if (loyaltyYears >= 5) return new BigDecimal("0.15");
        if (loyaltyYears >= 2) return new BigDecimal("0.05");
        return new BigDecimal("0.02");
    }

    private static OrderResult failure(String message) {
        return new OrderResult(false, BigDecimal.ZERO, message);
    }
}
