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
