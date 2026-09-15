const MIN_LENGTH = 8;

class PasswordValidator {
  validate(password) {
    // Exercise 2, Test: 'null or empty strings return false'
    // Reject null, empty, or whitespace-only input up front.
    if (password == null || password.trim() === '') {
      return false;
    }

    // Exercise 2, Test: 'less than eight characters returns false'
    // Enforce a minimum length.
    if (password.length < MIN_LENGTH) {
      return false;
    }

    let hasUpper = false;
    let hasLower = false;
    let hasDigit = false;
    let hasSpecial = false;
    for (const c of password) {
      if (/[A-Z]/.test(c)) hasUpper = true;
      else if (/[a-z]/.test(c)) hasLower = true;
      else if (/[0-9]/.test(c)) hasDigit = true;
      else if (!/\s/.test(c)) hasSpecial = true;
    }

    // Exercise 2, Test: 'missing uppercase character returns false'
    // Require an uppercase letter, a lowercase letter, and a special character
    // as part of the same "complex password" rule.
    if (!hasUpper || !hasLower || !hasSpecial) {
      return false;
    }

    // Exercise 2, Test: 'missing digit returns false'
    // Require at least one digit.
    if (!hasDigit) {
      return false;
    }

    // Exercise 2, Test: 'contains sequential digits returns false'
    // Reject any run of three ascending sequential digits (e.g. "123").
    if (hasSequentialDigits(password)) {
      return false;
    }

    // Exercise 2, Test: 'valid complex password returns true'
    // Anything that clears all the checks above is a valid password.
    return true;
  }
}

function hasSequentialDigits(password) {
  for (let i = 0; i < password.length - 2; i++) {
    const window = password.slice(i, i + 3);
    if (/^\d{3}$/.test(window)) {
      const [a, b, c] = [...window].map(Number);
      if (b === a + 1 && c === b + 1) {
        return true;
      }
    }
  }
  return false;
}

module.exports = PasswordValidator;
