from decimal import Decimal
import pytest
from exercise3.order_processor import OrderProcessor

@pytest.fixture
def processor():
    return OrderProcessor()

@pytest.mark.parametrize("amount,state,expected_msg", [
    (Decimal("0.00"), "OH", "Invalid Amount"),
    (Decimal("-10.00"), "AZ", "Invalid Amount"),
])
def test_invalid_amount_returns_failure(processor, amount, state, expected_msg):
    result = processor.process_order(amount, state, False, 0)
    assert result.is_success is False
    assert result.final_amount == Decimal("0.00")
    assert result.message == expected_msg

def test_unsupported_state_returns_failure(processor):
    result = processor.process_order(Decimal("100.00"), "NY", False, 0)
    assert result.is_success is False
    assert result.message == "Unsupported State"

@pytest.mark.parametrize("amount,state,is_member,loyalty_years,expected_final", [
    (Decimal("100.00"), "OH", False, 0, Decimal("105.75")),
    (Decimal("100.00"), "AZ", False, 0, Decimal("105.60")),
    (Decimal("100.00"), "TX", False, 0, Decimal("106.25")),
])
def test_valid_non_member_order_calculates_tax(processor, amount, state, is_member, loyalty_years, expected_final):
    result = processor.process_order(amount, state, is_member, loyalty_years)
    assert result.is_success is True
    assert result.final_amount == expected_final
    assert result.message == "Processed"

@pytest.mark.parametrize("amount,state,is_member,loyalty_years,expected_final", [
    (Decimal("100.00"), "OH", True, 1, Decimal("103.75")),
    (Decimal("100.00"), "OH", True, 3, Decimal("100.75")),
    (Decimal("100.00"), "OH", True, 7, Decimal("90.75")),
])
def test_member_discounts_apply_correct_tiers(processor, amount, state, is_member, loyalty_years, expected_final):
    result = processor.process_order(amount, state, is_member, loyalty_years)
    assert result.is_success is True
    assert result.final_amount == expected_final
