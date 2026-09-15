from decimal import Decimal
from typing import Optional

DISCOUNT_THRESHOLD = Decimal("100.00")
DISCOUNT_RATE = Decimal("0.10")

class DiscountCalculator:
    def calculate_discount(self, cart_total: Decimal, item_count: int, promo_code: Optional[str]) -> Decimal:
        # Exercise 1, Test: test_under_fifty_dollars_no_promo_returns_zero
        # Carts below the $100 threshold get no discount.
        if cart_total < DISCOUNT_THRESHOLD:
            return Decimal("0.00")

        # Exercise 1, Test: test_over_one_hundred_dollars_no_promo_returns_ten_percent
        # Carts at or above $100 receive a flat 10% discount.
        return (cart_total * DISCOUNT_RATE).quantize(Decimal("0.01"))
