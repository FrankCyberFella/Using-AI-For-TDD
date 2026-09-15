const SUPPORTED_STATES = new Set(['OH', 'AZ', 'TX']);

const TAX_RATES_BY_STATE = {
  OH: 0.0575,
  AZ: 0.056,
  TX: 0.0625,
};

class OrderProcessor {
  // This exercise starts from a working-but-messy implementation; the tests already
  // pass before any changes. The refactor below preserves that behavior while
  // extracting named constants/helpers for each step the tests exercise.
  processOrder(amount, state, isMember, loyaltyYears) {
    // Exercise 3, Test: 'invalid amount (...) returns failure'
    // Orders with a non-positive amount are rejected before anything else.
    if (amount <= 0) {
      return this._failure('Invalid Amount');
    }

    // Exercise 3, Test: 'unsupported state returns failure'
    // Only orders shipping to a supported state can be processed.
    if (!SUPPORTED_STATES.has(state)) {
      return this._failure('Unsupported State');
    }

    // Exercise 3, Test: 'valid non-member order calculates tax correctly'
    // Apply the state-specific tax rate to the order amount.
    const tax = amount * TAX_RATES_BY_STATE[state];

    // Exercise 3, Test: 'member discounts apply correct tiers'
    // Members earn a loyalty discount that scales with tenure.
    const discount = isMember ? amount * this._memberDiscountRate(loyaltyYears) : 0;

    const finalAmount = Math.max(amount + tax - discount, 0);

    return {
      isSuccess: true,
      finalAmount: Math.round(finalAmount * 100) / 100,
      message: 'Processed',
    };
  }

  _memberDiscountRate(loyaltyYears) {
    if (loyaltyYears >= 5) return 0.15;
    if (loyaltyYears >= 2) return 0.05;
    return 0.02;
  }

  _failure(message) {
    return { isSuccess: false, finalAmount: 0, message };
  }
}

module.exports = OrderProcessor;
