from decimal import Decimal
from typing import Optional

class DiscountCalculator:
    def calculate_discount(self, cart_total: Decimal, item_count: int, promo_code: Optional[str]) -> Decimal:
        raise NotImplementedError("Method not implemented")
