#!/usr/bin/env bash
set -e

BASE_DIR="$HOME/TrainingMaterial/Using-AI-For-TDD/exercises"
echo "Creating workshop workspaces in: $BASE_DIR"

mkdir -p "$BASE_DIR"

# ==============================================================================
# 1. C# Workspace (.NET 8 / xUnit)
# ==============================================================================
echo "Scaffolding C# workspace..."
CS_DIR="$BASE_DIR/csharp"
mkdir -p "$CS_DIR/Workshop/Exercise1"
mkdir -p "$CS_DIR/Workshop/Exercise2"
mkdir -p "$CS_DIR/Workshop/Exercise3"
mkdir -p "$CS_DIR/Workshop.Tests/Exercise1"
mkdir -p "$CS_DIR/Workshop.Tests/Exercise2"
mkdir -p "$CS_DIR/Workshop.Tests/Exercise3"

cat << 'EOF' > "$CS_DIR/Workshop/Workshop.csproj"
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

</Project>
EOF

cat << 'EOF' > "$CS_DIR/Workshop.Tests/Workshop.Tests.csproj"
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <IsPackable>false</IsPackable>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.9.0" />
    <PackageReference Include="xunit" Version="2.7.0" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.7">
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
      <PrivateAssets>all</PrivateAssets>
    </PackageReference>
    <PackageReference Include="coverlet.collector" Version="6.0.2" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\Workshop\Workshop.csproj" />
  </ItemGroup>

</Project>
EOF

cat << 'EOF' > "$CS_DIR/Workshop/Exercise1/IDiscountCalculator.cs"
namespace Workshop.Exercise1;

public interface IDiscountCalculator
{
    decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode);
}

public class DiscountCalculator : IDiscountCalculator
{
    public decimal CalculateDiscount(decimal cartTotal, int itemCount, string? promoCode)
    {
        throw new NotImplementedException();
    }
}
EOF

cat << 'EOF' > "$CS_DIR/Workshop.Tests/Exercise1/DiscountCalculatorTests.cs"
using System;
using Xunit;
using Workshop.Exercise1;

namespace Workshop.Tests.Exercise1;

public class DiscountCalculatorTests
{
    private readonly IDiscountCalculator _calculator = new DiscountCalculator();

    [Fact]
    public void CalculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero()
    {
        decimal total = 45.00m;
        int items = 2;
        string? promo = null;

        decimal discount = _calculator.CalculateDiscount(total, items, promo);

        Assert.Equal(0.00m, discount);
    }

    [Fact]
    public void CalculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent()
    {
        decimal total = 100.00m;
        int items = 3;
        string? promo = null;

        decimal discount = _calculator.CalculateDiscount(total, items, promo);

        Assert.Equal(10.00m, discount);
    }
}
EOF

cat << 'EOF' > "$CS_DIR/Workshop/Exercise2/PasswordValidator.cs"
namespace Workshop.Exercise2;

public interface IPasswordValidator
{
    bool Validate(string? password);
}

public class PasswordValidator : IPasswordValidator
{
    public bool Validate(string? password)
    {
        return false;
    }
}
EOF

cat << 'EOF' > "$CS_DIR/Workshop.Tests/Exercise2/PasswordValidatorTests.cs"
using Xunit;
using Workshop.Exercise2;

namespace Workshop.Tests.Exercise2;

public class PasswordValidatorTests
{
    private readonly IPasswordValidator _validator = new PasswordValidator();

    [Fact]
    public void Validate_NullOrEmpty_ReturnsFalse()
    {
        Assert.False(_validator.Validate(null));
        Assert.False(_validator.Validate(""));
        Assert.False(_validator.Validate("   "));
    }

    [Fact]
    public void Validate_LessThanEightCharacters_ReturnsFalse()
    {
        Assert.False(_validator.Validate("Abc123!"));
    }

    [Fact]
    public void Validate_MissingUppercase_ReturnsFalse()
    {
        Assert.False(_validator.Validate("password123!"));
    }

    [Fact]
    public void Validate_MissingDigit_ReturnsFalse()
    {
        Assert.False(_validator.Validate("PasswordDef!"));
    }

    [Fact]
    public void Validate_ContainsSequentialDigits_ReturnsFalse()
    {
        Assert.False(_validator.Validate("PassWord123!"));
    }

    [Fact]
    public void Validate_ValidComplexPassword_ReturnsTrue()
    {
        Assert.True(_validator.Validate("Str0ng!Pass9"));
    }
}
EOF

cat << 'EOF' > "$CS_DIR/Workshop/Exercise3/OrderProcessor.cs"
using System;

namespace Workshop.Exercise3;

public class OrderResult
{
    public bool IsSuccess { get; set; }
    public decimal FinalAmount { get; set; }
    public string Message { get; set; } = string.Empty;
}

public class OrderProcessor
{
    public OrderResult ProcessOrder(decimal amount, string state, bool isMember, int loyaltyYears)
    {
        var res = new OrderResult();

        if (amount > 0)
        {
            if (state == "OH" || state == "AZ" || state == "TX")
            {
                decimal tax = 0;
                if (state == "OH")
                {
                    tax = amount * 0.0575m;
                }
                else if (state == "AZ")
                {
                    tax = amount * 0.056m;
                }
                else
                {
                    tax = amount * 0.0625m;
                }

                decimal disc = 0;
                if (isMember)
                {
                    if (loyaltyYears >= 5)
                    {
                        disc = amount * 0.15m;
                    }
                    else if (loyaltyYears >= 2)
                    {
                        disc = amount * 0.05m;
                    }
                    else
                    {
                        disc = amount * 0.02m;
                    }
                }

                decimal calc = amount + tax - disc;
                if (calc < 0)
                {
                    calc = 0;
                }

                res.IsSuccess = true;
                res.FinalAmount = Math.Round(calc, 2);
                res.Message = "Processed";
            }
            else
            {
                res.IsSuccess = false;
                res.FinalAmount = 0;
                res.Message = "Unsupported State";
            }
        }
        else
        {
            res.IsSuccess = false;
            res.FinalAmount = 0;
            res.Message = "Invalid Amount";
        }

        return res;
    }
}
EOF

cat << 'EOF' > "$CS_DIR/Workshop.Tests/Exercise3/OrderProcessorTests.cs"
using Xunit;
using Workshop.Exercise3;

namespace Workshop.Tests.Exercise3;

public class OrderProcessorTests
{
    private readonly OrderProcessor _processor = new OrderProcessor();

    [Theory]
    [InlineData(0, "OH", "Invalid Amount")]
    [InlineData(-10, "AZ", "Invalid Amount")]
    public void ProcessOrder_InvalidAmount_ReturnsFailure(decimal amount, string state, string expectedMsg)
    {
        var result = _processor.ProcessOrder(amount, state, false, 0);

        Assert.False(result.IsSuccess);
        Assert.Equal(0, result.FinalAmount);
        Assert.Equal(expectedMsg, result.Message);
    }

    [Fact]
    public void ProcessOrder_UnsupportedState_ReturnsFailure()
    {
        var result = _processor.ProcessOrder(100.00m, "NY", false, 0);

        Assert.False(result.IsSuccess);
        Assert.Equal("Unsupported State", result.Message);
    }

    [Theory]
    [InlineData(100.00, "OH", false, 0, 105.75)]
    [InlineData(100.00, "AZ", false, 0, 105.60)]
    [InlineData(100.00, "TX", false, 0, 106.25)]
    public void ProcessOrder_ValidNonMember_CalculatesCorrectTax(
        decimal amount, string state, bool isMember, int loyaltyYears, decimal expectedFinal)
    {
        var result = _processor.ProcessOrder(amount, state, isMember, loyaltyYears);

        Assert.True(result.IsSuccess);
        Assert.Equal(expectedFinal, result.FinalAmount);
        Assert.Equal("Processed", result.Message);
    }

    [Theory]
    [InlineData(100.00, "OH", true, 1, 103.75)]
    [InlineData(100.00, "OH", true, 3, 100.75)]
    [InlineData(100.00, "OH", true, 7, 90.75)]
    public void ProcessOrder_MemberDiscounts_AppliesCorrectTiers(
        decimal amount, string state, bool isMember, int loyaltyYears, decimal expectedFinal)
    {
        var result = _processor.ProcessOrder(amount, state, isMember, loyaltyYears);

        Assert.True(result.IsSuccess);
        Assert.Equal(expectedFinal, result.FinalAmount);
    }
}
EOF

# ==============================================================================
# 2. Java Workspace (Maven / JUnit 5)
# ==============================================================================
echo "Scaffolding Java workspace..."
JAVA_DIR="$BASE_DIR/java"
mkdir -p "$JAVA_DIR/src/main/java/workshop/exercise1" "$JAVA_DIR/src/test/java/workshop/exercise1"
mkdir -p "$JAVA_DIR/src/main/java/workshop/exercise2" "$JAVA_DIR/src/test/java/workshop/exercise2"
mkdir -p "$JAVA_DIR/src/main/java/workshop/exercise3" "$JAVA_DIR/src/test/java/workshop/exercise3"

cat << 'EOF' > "$JAVA_DIR/pom.xml"
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>workshop</groupId>
    <artifactId>ai-tdd-workshop</artifactId>
    <version>1.0.0</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.version>5.10.2</junit.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
            </plugin>
        </plugins>
    </build>
</project>
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise1/DiscountCalculator.java"
package workshop.exercise1;

import java.math.BigDecimal;

public interface DiscountCalculator {
    BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode);
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise1/DefaultDiscountCalculator.java"
package workshop.exercise1;

import java.math.BigDecimal;

public class DefaultDiscountCalculator implements DiscountCalculator {
    @Override
    public BigDecimal calculateDiscount(BigDecimal cartTotal, int itemCount, String promoCode) {
        throw new UnsupportedOperationException("Method not implemented");
    }
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/test/java/workshop/exercise1/DiscountCalculatorTest.java"
package workshop.exercise1;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class DiscountCalculatorTest {
    private DiscountCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new DefaultDiscountCalculator();
    }

    @Test
    void calculateDiscount_UnderFiftyDollarsNoPromo_ReturnsZero() {
        BigDecimal total = new BigDecimal("45.00");
        int items = 2;
        String promo = null;

        BigDecimal discount = calculator.calculateDiscount(total, items, promo);

        assertEquals(new BigDecimal("0.00"), discount);
    }

    @Test
    void calculateDiscount_OverOneHundredDollarsNoPromo_ReturnsTenPercent() {
        BigDecimal total = new BigDecimal("100.00");
        int items = 3;
        String promo = null;

        BigDecimal discount = calculator.calculateDiscount(total, items, promo);

        assertEquals(new BigDecimal("10.00"), discount);
    }
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise2/PasswordValidator.java"
package workshop.exercise2;

public interface PasswordValidator {
    boolean validate(String password);
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise2/DefaultPasswordValidator.java"
package workshop.exercise2;

public class DefaultPasswordValidator implements PasswordValidator {
    @Override
    public boolean validate(String password) {
        return false;
    }
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/test/java/workshop/exercise2/PasswordValidatorTest.java"
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
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise3/OrderResult.java"
package workshop.exercise3;

import java.math.BigDecimal;

public class OrderResult {
    private final boolean isSuccess;
    private final BigDecimal finalAmount;
    private final String message;

    public OrderResult(boolean isSuccess, BigDecimal finalAmount, String message) {
        this.isSuccess = isSuccess;
        this.finalAmount = finalAmount;
        this.message = message;
    }

    public boolean isSuccess() { return isSuccess; }
    public BigDecimal getFinalAmount() { return finalAmount; }
    public String getMessage() { return message; }
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/main/java/workshop/exercise3/OrderProcessor.java"
package workshop.exercise3;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class OrderProcessor {
    public OrderResult processOrder(BigDecimal amount, String state, boolean isMember, int loyaltyYears) {
        if (amount != null && amount.compareTo(BigDecimal.ZERO) > 0) {
            if ("OH".equals(state) || "AZ".equals(state) || "TX".equals(state)) {
                BigDecimal tax;
                if ("OH".equals(state)) {
                    tax = amount.multiply(new BigDecimal("0.0575"));
                } else if ("AZ".equals(state)) {
                    tax = amount.multiply(new BigDecimal("0.056"));
                } else {
                    tax = amount.multiply(new BigDecimal("0.0625"));
                }

                BigDecimal disc = BigDecimal.ZERO;
                if (isMember) {
                    if (loyaltyYears >= 5) {
                        disc = amount.multiply(new BigDecimal("0.15"));
                    } else if (loyaltyYears >= 2) {
                        disc = amount.multiply(new BigDecimal("0.05"));
                    } else {
                        disc = amount.multiply(new BigDecimal("0.02"));
                    }
                }

                BigDecimal calc = amount.add(tax).subtract(disc);
                if (calc.compareTo(BigDecimal.ZERO) < 0) {
                    calc = BigDecimal.ZERO;
                }

                BigDecimal finalAmount = calc.setScale(2, RoundingMode.HALF_UP);
                return new OrderResult(true, finalAmount, "Processed");
            } else {
                return new OrderResult(false, BigDecimal.ZERO, "Unsupported State");
            }
        } else {
            return new OrderResult(false, BigDecimal.ZERO, "Invalid Amount");
        }
    }
}
EOF

cat << 'EOF' > "$JAVA_DIR/src/test/java/workshop/exercise3/OrderProcessorTest.java"
package workshop.exercise3;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.*;

public class OrderProcessorTest {
    private OrderProcessor processor;

    @BeforeEach
    void setUp() {
        processor = new OrderProcessor();
    }

    @ParameterizedTest
    @CsvSource({
        "0.00, OH, Invalid Amount",
        "-10.00, AZ, Invalid Amount"
    })
    void processOrder_InvalidAmount_ReturnsFailure(String amountStr, String state, String expectedMsg) {
        BigDecimal amount = new BigDecimal(amountStr);
        OrderResult result = processor.processOrder(amount, state, false, 0);

        assertFalse(result.isSuccess());
        assertEquals(BigDecimal.ZERO, result.getFinalAmount());
        assertEquals(expectedMsg, result.getMessage());
    }

    @Test
    void processOrder_UnsupportedState_ReturnsFailure() {
        OrderResult result = processor.processOrder(new BigDecimal("100.00"), "NY", false, 0);

        assertFalse(result.isSuccess());
        assertEquals("Unsupported State", result.getMessage());
    }

    @ParameterizedTest
    @CsvSource({
        "100.00, OH, 105.75",
        "100.00, AZ, 105.60",
        "100.00, TX, 106.25"
    })
    void processOrder_ValidNonMember_CalculatesTax(String amountStr, String state, String expectedFinalStr) {
        BigDecimal amount = new BigDecimal(amountStr);
        BigDecimal expectedFinal = new BigDecimal(expectedFinalStr);

        OrderResult result = processor.processOrder(amount, state, false, 0);

        assertTrue(result.isSuccess());
        assertEquals(expectedFinal, result.getFinalAmount());
        assertEquals("Processed", result.getMessage());
    }

    @ParameterizedTest
    @CsvSource({
        "100.00, OH, 1, 103.75",
        "100.00, OH, 3, 100.75",
        "100.00, OH, 7, 90.75"
    })
    void processOrder_MemberDiscounts_AppliesCorrectTiers(
            String amountStr, String state, int loyaltyYears, String expectedFinalStr) {
        BigDecimal amount = new BigDecimal(amountStr);
        BigDecimal expectedFinal = new BigDecimal(expectedFinalStr);

        OrderResult result = processor.processOrder(amount, state, true, loyaltyYears);

        assertTrue(result.isSuccess());
        assertEquals(expectedFinal, result.getFinalAmount());
    }
}
EOF

# ==============================================================================
# 3. Python Workspace (pytest)
# ==============================================================================
echo "Scaffolding Python workspace..."
PY_DIR="$BASE_DIR/python"
mkdir -p "$PY_DIR/exercise1" "$PY_DIR/exercise2" "$PY_DIR/exercise3"

cat << 'EOF' > "$PY_DIR/pyproject.toml"
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "ai-tdd-workshop"
version = "0.1.0"
dependencies = []

[tool.pytest.ini_options]
testpaths = ["exercise1", "exercise2", "exercise3"]
pythonpath = ["."]
EOF

cat << 'EOF' > "$PY_DIR/exercise1/discount_calculator.py"
from decimal import Decimal
from typing import Optional

class DiscountCalculator:
    def calculate_discount(self, cart_total: Decimal, item_count: int, promo_code: Optional[str]) -> Decimal:
        raise NotImplementedError("Method not implemented")
EOF

cat << 'EOF' > "$PY_DIR/exercise1/test_discount_calculator.py"
from decimal import Decimal
import pytest
from exercise1.discount_calculator import DiscountCalculator

@pytest.fixture
def calculator():
    return DiscountCalculator()

def test_under_fifty_dollars_no_promo_returns_zero(calculator):
    discount = calculator.calculate_discount(Decimal("45.00"), 2, None)
    assert discount == Decimal("0.00")

def test_over_one_hundred_dollars_no_promo_returns_ten_percent(calculator):
    discount = calculator.calculate_discount(Decimal("100.00"), 3, None)
    assert discount == Decimal("10.00")
EOF

cat << 'EOF' > "$PY_DIR/exercise2/password_validator.py"
from typing import Optional

class PasswordValidator:
    def validate(self, password: Optional[str]) -> bool:
        return False
EOF

cat << 'EOF' > "$PY_DIR/exercise2/test_password_validator.py"
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
EOF

cat << 'EOF' > "$PY_DIR/exercise3/order_processor.py"
from decimal import Decimal, ROUND_HALF_UP
from dataclasses import dataclass

@dataclass
class OrderResult:
    is_success: bool
    final_amount: Decimal
    message: str

class OrderProcessor:
    def process_order(self, amount: Decimal, state: str, is_member: bool, loyalty_years: int) -> OrderResult:
        res = OrderResult(is_success=False, final_amount=Decimal("0.00"), message="")

        if amount > Decimal("0.00"):
            if state in ("OH", "AZ", "TX"):
                tax = Decimal("0.00")
                if state == "OH":
                    tax = amount * Decimal("0.0575")
                elif state == "AZ":
                    tax = amount * Decimal("0.056")
                else:
                    tax = amount * Decimal("0.0625")

                disc = Decimal("0.00")
                if is_member:
                    if loyalty_years >= 5:
                        disc = amount * Decimal("0.15")
                    elif loyalty_years >= 2:
                        disc = amount * Decimal("0.05")
                    else:
                        disc = amount * Decimal("0.02")

                calc = amount + tax - disc
                if calc < Decimal("0.00"):
                    calc = Decimal("0.00")

                res.is_success = True
                res.final_amount = calc.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
                res.message = "Processed"
            else:
                res.is_success = False
                res.final_amount = Decimal("0.00")
                res.message = "Unsupported State"
        else:
            res.is_success = False
            res.final_amount = Decimal("0.00")
            res.message = "Invalid Amount"

        return res
EOF

cat << 'EOF' > "$PY_DIR/exercise3/test_order_processor.py"
from decimal import Decimal
import pytest
from exercise3.order_processor import OrderProcessor

@pytest.fixture
def processor():
    return OrderProcessor()

@pytest.mark.parametrize("amount,state,expected_msg", [
    (Decimal("0.00"), "OH", "Invalid Amount"),
    (Decimal("-10.00"), "AZ", "Invalid Amount"),
])
def test_invalid_amount_returns_failure(processor, amount, state, expected_msg):
    result = processor.process_order(amount, state, False, 0)
    assert result.is_success is False
    assert result.final_amount == Decimal("0.00")
    assert result.message == expected_msg

def test_unsupported_state_returns_failure(processor):
    result = processor.process_order(Decimal("100.00"), "NY", False, 0)
    assert result.is_success is False
    assert result.message == "Unsupported State"

@pytest.mark.parametrize("amount,state,is_member,loyalty_years,expected_final", [
    (Decimal("100.00"), "OH", False, 0, Decimal("105.75")),
    (Decimal("100.00"), "AZ", False, 0, Decimal("105.60")),
    (Decimal("100.00"), "TX", False, 0, Decimal("106.25")),
])
def test_valid_non_member_order_calculates_tax(processor, amount, state, is_member, loyalty_years, expected_final):
    result = processor.process_order(amount, state, is_member, loyalty_years)
    assert result.is_success is True
    assert result.final_amount == expected_final
    assert result.message == "Processed"

@pytest.mark.parametrize("amount,state,is_member,loyalty_years,expected_final", [
    (Decimal("100.00"), "OH", True, 1, Decimal("103.75")),
    (Decimal("100.00"), "OH", True, 3, Decimal("100.75")),
    (Decimal("100.00"), "OH", True, 7, Decimal("90.75")),
])
def test_member_discounts_apply_correct_tiers(processor, amount, state, is_member, loyalty_years, expected_final):
    result = processor.process_order(amount, state, is_member, loyalty_years)
    assert result.is_success is True
    assert result.final_amount == expected_final
EOF

# ==============================================================================
# 4. JavaScript Workspace (Jest)
# ==============================================================================
echo "Scaffolding JavaScript workspace..."
JS_DIR="$BASE_DIR/javascript"
mkdir -p "$JS_DIR/exercise1" "$JS_DIR/exercise2" "$JS_DIR/exercise3"

cat << 'EOF' > "$JS_DIR/package.json"
{
  "name": "ai-tdd-workshop",
  "version": "1.0.0",
  "description": "Pragmatic TDD with AI workshop exercises",
  "scripts": {
    "test": "jest"
  },
  "devDependencies": {
    "jest": "^29.7.0"
  }
}
EOF

cat << 'EOF' > "$JS_DIR/exercise1/discountCalculator.js"
class DiscountCalculator {
  calculateDiscount(cartTotal, itemCount, promoCode) {
    throw new Error('Not implemented');
  }
}

module.exports = DiscountCalculator;
EOF

cat << 'EOF' > "$JS_DIR/exercise1/discountCalculator.test.js"
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
EOF

cat << 'EOF' > "$JS_DIR/exercise2/passwordValidator.js"
class PasswordValidator {
  validate(password) {
    return false;
  }
}

module.exports = PasswordValidator;
EOF

cat << 'EOF' > "$JS_DIR/exercise2/passwordValidator.test.js"
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
EOF

cat << 'EOF' > "$JS_DIR/exercise3/orderProcessor.js"
class OrderProcessor {
  processOrder(amount, state, isMember, loyaltyYears) {
    const res = { isSuccess: false, finalAmount: 0, message: '' };

    if (amount > 0) {
      if (state === 'OH' || state === 'AZ' || state === 'TX') {
        let tax = 0;
        if (state === 'OH') {
          tax = amount * 0.0575;
        } else if (state === 'AZ') {
          tax = amount * 0.056;
        } else {
          tax = amount * 0.0625;
        }

        let disc = 0;
        if (isMember) {
          if (loyaltyYears >= 5) {
            disc = amount * 0.15;
          } else if (loyaltyYears >= 2) {
            disc = amount * 0.05;
          } else {
            disc = amount * 0.02;
          }
        }

        let calc = amount + tax - disc;
        if (calc < 0) {
          calc = 0;
        }

        res.isSuccess = true;
        res.finalAmount = Math.round(calc * 100) / 100;
        res.message = 'Processed';
      } else {
        res.isSuccess = false;
        res.finalAmount = 0;
        res.message = 'Unsupported State';
      }
    } else {
      res.isSuccess = false;
      res.finalAmount = 0;
      res.message = 'Invalid Amount';
    }

    return res;
  }
}

module.exports = OrderProcessor;
EOF

cat << 'EOF' > "$JS_DIR/exercise3/orderProcessor.test.js"
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
EOF

echo ""
echo "Setup complete. Workspace created at: $BASE_DIR"
echo "Available language suites:"
echo "  - C#:         $CS_DIR (Run: dotnet test)"
echo "  - Java:       $JAVA_DIR (Run: mvn test)"
echo "  - Python:     $PY_DIR (Run: pytest)"
echo "  - JavaScript: $JS_DIR (Run: npm install && npm test)"