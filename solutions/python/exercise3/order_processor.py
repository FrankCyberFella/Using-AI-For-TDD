from decimal import Decimal, ROUND_HALF_UP
from dataclasses import dataclass

@dataclass
class OrderResult:
    is_success: bool
    final_amount: Decimal
    message: str

SUPPORTED_STATES = {"OH", "AZ", "TX"}

TAX_RATES_BY_STATE = {
    "OH": Decimal("0.0575"),
    "AZ": Decimal("0.056"),
    "TX": Decimal("0.0625"),
}

# This exercise starts from a working-but-messy implementation; the tests already
# pass before any changes. The refactor below preserves that behavior while
# extracting named constants/helpers for each step the tests exercise.
class OrderProcessor:
    def process_order(self, amount: Decimal, state: str, is_member: bool, loyalty_years: int) -> OrderResult:
        # Exercise 3, Test: test_invalid_amount_returns_failure
        # Orders with a non-positive amount are rejected before anything else.
        if amount <= Decimal("0.00"):
            return self._failure("Invalid Amount")

        # Exercise 3, Test: test_unsupported_state_returns_failure
        # Only orders shipping to a supported state can be processed.
        if state not in SUPPORTED_STATES:
            return self._failure("Unsupported State")

        # Exercise 3, Test: test_valid_non_member_order_calculates_tax
        # Apply the state-specific tax rate to the order amount.
        tax = amount * TAX_RATES_BY_STATE[state]

        # Exercise 3, Test: test_member_discounts_apply_correct_tiers
        # Members earn a loyalty discount that scales with tenure.
        discount = amount * self._member_discount_rate(loyalty_years) if is_member else Decimal("0.00")

        final_amount = max(amount + tax - discount, Decimal("0.00"))

        return OrderResult(
            is_success=True,
            final_amount=final_amount.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP),
            message="Processed",
        )

    @staticmethod
    def _member_discount_rate(loyalty_years: int) -> Decimal:
        if loyalty_years >= 5:
            return Decimal("0.15")
        if loyalty_years >= 2:
            return Decimal("0.05")
        return Decimal("0.02")

    @staticmethod
    def _failure(message: str) -> OrderResult:
        return OrderResult(is_success=False, final_amount=Decimal("0.00"), message=message)
