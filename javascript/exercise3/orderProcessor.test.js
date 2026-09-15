const OrderProcessor = require('./orderProcessor');

describe('OrderProcessor', () => {
  let processor;

  beforeEach(() => {
    processor = new OrderProcessor();
  });

  test.each([
    [0, 'OH', 'Invalid Amount'],
    [-10, 'AZ', 'Invalid Amount'],
  ])('invalid amount (%p, %p) returns failure', (amount, state, expectedMsg) => {
    const result = processor.processOrder(amount, state, false, 0);
    expect(result.isSuccess).toBe(false);
    expect(result.finalAmount).toBe(0);
    expect(result.message).toBe(expectedMsg);
  });

  test('unsupported state returns failure', () => {
    const result = processor.processOrder(100.0, 'NY', false, 0);
    expect(result.isSuccess).toBe(false);
    expect(result.message).toBe('Unsupported State');
  });

  test.each([
    [100.0, 'OH', false, 0, 105.75],
    [100.0, 'AZ', false, 0, 105.60],
    [100.0, 'TX', false, 0, 106.25],
  ])('valid non-member order calculates tax correctly', (amount, state, isMember, loyaltyYears, expectedFinal) => {
    const result = processor.processOrder(amount, state, isMember, loyaltyYears);
    expect(result.isSuccess).toBe(true);
    expect(result.finalAmount).toBe(expectedFinal);
    expect(result.message).toBe('Processed');
  });

  test.each([
    [100.0, 'OH', true, 1, 103.75],
    [100.0, 'OH', true, 3, 100.75],
    [100.0, 'OH', true, 7, 90.75],
  ])('member discounts apply correct tiers', (amount, state, isMember, loyaltyYears, expectedFinal) => {
    const result = processor.processOrder(amount, state, isMember, loyaltyYears);
    expect(result.isSuccess).toBe(true);
    expect(result.finalAmount).toBe(expectedFinal);
  });
});
