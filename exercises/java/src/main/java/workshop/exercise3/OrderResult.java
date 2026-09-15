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
