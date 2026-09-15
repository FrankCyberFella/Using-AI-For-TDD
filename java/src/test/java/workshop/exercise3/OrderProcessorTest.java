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
