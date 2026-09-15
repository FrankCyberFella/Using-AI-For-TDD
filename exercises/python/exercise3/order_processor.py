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
