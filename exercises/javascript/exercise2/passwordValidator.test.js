const PasswordValidator = require('./passwordValidator');

describe('PasswordValidator', () => {
  let validator;

  beforeEach(() => {
    validator = new PasswordValidator();
  });

  test('null or empty strings return false', () => {
    expect(validator.validate(null)).toBe(false);
    expect(validator.validate('')).toBe(false);
    expect(validator.validate('   ')).toBe(false);
  });

  test('less than eight characters returns false', () => {
    expect(validator.validate('Abc123!')).toBe(false);
  });

  test('missing uppercase character returns false', () => {
    expect(validator.validate('password123!')).toBe(false);
  });

  test('missing digit returns false', () => {
    expect(validator.validate('PasswordDef!')).toBe(false);
  });

  test('contains sequential digits returns false', () => {
    expect(validator.validate('PassWord123!')).toBe(false);
  });

  test('valid complex password returns true', () => {
    expect(validator.validate('Str0ng!Pass9')).toBe(true);
  });
});
