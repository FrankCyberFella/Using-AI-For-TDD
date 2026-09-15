const DISCOUNT_THRESHOLD = 100.0;
const DISCOUNT_RATE = 0.1;

class DiscountCalculator {
  calculateDiscount(cartTotal, itemCount, promoCode) {
    // Exercise 1, Test: 'under fifty dollars with no promo returns zero'
    // Carts below the $100 threshold get no discount.
    if (cartTotal < DISCOUNT_THRESHOLD) {
      return 0.0;
    }

    // Exercise 1, Test: 'over one hundred dollars with no promo returns ten percent'
    // Carts at or above $100 receive a flat 10% discount.
    return cartTotal * DISCOUNT_RATE;
  }
}

module.exports = DiscountCalculator;
