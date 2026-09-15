package workshop.exercise2;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PasswordValidatorTest {
    private PasswordValidator validator;

    @BeforeEach
    void setUp() {
        validator = new DefaultPasswordValidator();
    }

    @ParameterizedTest
    @NullAndEmptySource
    @ValueSource(strings = {"   "})
    void validate_NullOrEmpty_ReturnsFalse(String password) {
        assertFalse(validator.validate(password));
    }

    @Test
    void validate_LessThanEightCharacters_ReturnsFalse() {
        assertFalse(validator.validate("Abc123!"));
    }

    @Test
    void validate_MissingUppercase_ReturnsFalse() {
        assertFalse(validator.validate("password123!"));
    }

    @Test
    void validate_MissingDigit_ReturnsFalse() {
        assertFalse(validator.validate("PasswordDef!"));
    }

    @Test
    void validate_ContainsSequentialDigits_ReturnsFalse() {
        assertFalse(validator.validate("PassWord123!"));
    }

    @Test
    void validate_ValidComplexPassword_ReturnsTrue() {
        assertTrue(validator.validate("Str0ng!Pass9"));
    }
}
