using System;
using System.Collections.Generic;

namespace Workshop.Exercise3;

public class OrderResult
{
    public bool IsSuccess { get; set; }
    public decimal FinalAmount { get; set; }
    public string Message { get; set; } = string.Empty;
}

public class OrderProcessor
{
    private static readonly HashSet<string> SupportedStates = new() { "OH", "AZ", "TX" };

    private static readonly Dictionary<string, decimal> TaxRatesByState = new()
    {
        ["OH"] = 0.0575m,
        ["AZ"] = 0.056m,
        ["TX"] = 0.0625m,
    };

    // This exercise starts from a working-but-messy implementation; the tests already
    // pass before any changes. The refactor below preserves that behavior while
    // extracting named constants/helpers for each step the tests exercise.
    public OrderResult ProcessOrder(decimal amount, string state, bool isMember, int loyaltyYears)
    {
        // Exercise 3, Test: ProcessOrder_InvalidAmount_ReturnsFailure
        // Orders with a non-positive amount are rejected before anything else.
        if (amount <= 0)
        {
            return Failure("Invalid Amount");
        }

        // Exercise 3, Test: ProcessOrder_UnsupportedState_ReturnsFailure
        // Only orders shipping to a supported state can be processed.
        if (!SupportedStates.Contains(state))
        {
            return Failure("Unsupported State");
        }

        // Exercise 3, Test: ProcessOrder_ValidNonMember_CalculatesCorrectTax
        // Apply the state-specific tax rate to the order amount.
        decimal tax = amount * TaxRatesByState[state];

        // Exercise 3, Test: ProcessOrder_MemberDiscounts_AppliesCorrectTiers
        // Members earn a loyalty discount that scales with tenure.
        decimal discount = isMember ? amount * MemberDiscountRate(loyaltyYears) : 0m;

        decimal finalAmount = Math.Max(amount + tax - discount, 0m);

        return new OrderResult
        {
            IsSuccess = true,
            FinalAmount = Math.Round(finalAmount, 2),
            Message = "Processed",
        };
    }

    private static decimal MemberDiscountRate(int loyaltyYears)
    {
        if (loyaltyYears >= 5) return 0.15m;
        if (loyaltyYears >= 2) return 0.05m;
        return 0.02m;
    }

    private static OrderResult Failure(string message) => new()
    {
        IsSuccess = false,
        FinalAmount = 0m,
        Message = message,
    };
}
