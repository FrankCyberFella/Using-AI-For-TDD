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
