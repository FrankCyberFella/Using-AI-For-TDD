const DiscountCalculator = require('./discountCalculator');

describe('DiscountCalculator', () => {
  let calculator;

  beforeEach(() => {
    calculator = new DiscountCalculator();
  });

  test('under fifty dollars with no promo returns zero', () => {
    const discount = calculator.calculateDiscount(45.0, 2, null);
    expect(discount).toBe(0.0);
  });

  test('over one hundred dollars with no promo returns ten percent', () => {
    const discount = calculator.calculateDiscount(100.0, 3, null);
    expect(discount).toBe(10.0);
  });
});
