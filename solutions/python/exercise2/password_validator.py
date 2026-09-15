from typing import Optional

MIN_LENGTH = 8

class PasswordValidator:
    def validate(self, password: Optional[str]) -> bool:
        # Exercise 2, Test: test_null_or_empty_returns_false
        # Reject None, empty, or whitespace-only input up front.
        if password is None or password.strip() == "":
            return False

        # Exercise 2, Test: test_less_than_eight_characters_returns_false
        # Enforce a minimum length.
        if len(password) < MIN_LENGTH:
            return False

        has_upper = any(c.isupper() for c in password)
        has_lower = any(c.islower() for c in password)
        has_digit = any(c.isdigit() for c in password)
        has_special = any(not c.isalnum() and not c.isspace() for c in password)

        # Exercise 2, Test: test_missing_uppercase_returns_false
        # Require an uppercase letter, a lowercase letter, and a special character
        # as part of the same "complex password" rule.
        if not (has_upper and has_lower and has_special):
            return False

        # Exercise 2, Test: test_missing_digit_returns_false
        # Require at least one digit.
        if not has_digit:
            return False

        # Exercise 2, Test: test_contains_sequential_digits_returns_false
        # Reject any run of three ascending sequential digits (e.g. "123").
        if _has_sequential_digits(password):
            return False

        # Exercise 2, Test: test_valid_complex_password_returns_true
        # Anything that clears all the checks above is a valid password.
        return True


def _has_sequential_digits(password: str) -> bool:
    for i in range(len(password) - 2):
        window = password[i:i + 3]
        if window.isdigit():
            a, b, c = (int(ch) for ch in window)
            if b == a + 1 and c == b + 1:
                return True
    return False
