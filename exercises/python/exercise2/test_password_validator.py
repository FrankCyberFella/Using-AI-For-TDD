import pytest
from exercise2.password_validator import PasswordValidator

@pytest.fixture
def validator():
    return PasswordValidator()

def test_null_or_empty_returns_false(validator):
    assert validator.validate(None) is False
    assert validator.validate("") is False
    assert validator.validate("   ") is False

def test_less_than_eight_characters_returns_false(validator):
    assert validator.validate("Abc123!") is False

def test_missing_uppercase_returns_false(validator):
    assert validator.validate("password123!") is False

def test_missing_digit_returns_false(validator):
    assert validator.validate("PasswordDef!") is False

def test_contains_sequential_digits_returns_false(validator):
    assert validator.validate("PassWord123!") is False

def test_valid_complex_password_returns_true(validator):
    assert validator.validate("Str0ng!Pass9") is True
