from decimal import Decimal
import pytest
from exercise1.discount_calculator import DiscountCalculator

@pytest.fixture
def calculator():
    return DiscountCalculator()

def test_under_fifty_dollars_no_promo_returns_zero(calculator):
    discount = calculator.calculate_discount(Decimal("45.00"), 2, None)
    assert discount == Decimal("0.00")

def test_over_one_hundred_dollars_no_promo_returns_ten_percent(calculator):
    discount = calculator.calculate_discount(Decimal("100.00"), 3, None)
    assert discount == Decimal("10.00")
