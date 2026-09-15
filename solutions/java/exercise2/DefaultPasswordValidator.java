package workshop.exercise2;

public class DefaultPasswordValidator implements PasswordValidator {

    private static final int MIN_LENGTH = 8;

    @Override
    public boolean validate(String password) {
        // Exercise 2, Test: validate_NullOrEmpty_ReturnsFalse
        // Reject null, empty, or whitespace-only input up front.
        if (password == null || password.trim().isEmpty()) {
            return false;
        }

        // Exercise 2, Test: validate_LessThanEightCharacters_ReturnsFalse
        // Enforce a minimum length.
        if (password.length() < MIN_LENGTH) {
            return false;
        }

        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isWhitespace(c)) {
                hasSpecial = true;
            }
        }

        // Exercise 2, Test: validate_MissingUppercase_ReturnsFalse
        // Require an uppercase letter, a lowercase letter, and a special character
        // as part of the same "complex password" rule.
        if (!hasUpper || !hasLower || !hasSpecial) {
            return false;
        }

        // Exercise 2, Test: validate_MissingDigit_ReturnsFalse
        // Require at least one digit.
        if (!hasDigit) {
            return false;
        }

        // Exercise 2, Test: validate_ContainsSequentialDigits_ReturnsFalse
        // Reject any run of three ascending sequential digits (e.g. "123").
        if (hasSequentialDigits(password)) {
            return false;
        }

        // Exercise 2, Test: validate_ValidComplexPassword_ReturnsTrue
        // Anything that clears all the checks above is a valid password.
        return true;
    }

    private static boolean hasSequentialDigits(String password) {
        for (int i = 0; i < password.length() - 2; i++) {
            char c1 = password.charAt(i);
            char c2 = password.charAt(i + 1);
            char c3 = password.charAt(i + 2);
            if (Character.isDigit(c1) && Character.isDigit(c2) && Character.isDigit(c3)) {
                int a = c1 - '0';
                int b = c2 - '0';
                int c = c3 - '0';
                if (b == a + 1 && c == b + 1) {
                    return true;
                }
            }
        }
        return false;
    }
}
