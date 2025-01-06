export function calculateEffectiveRate(loan_amount, interest_rate, tenure){

  var interest_rate_desc = parseFloat(interest_rate / 100);

  var monthly_repayment_original =
    parseFloat(loan_amount * interest_rate_desc * tenure + loan_amount) / (tenure * 12);
  //(45000 * 0.04 * 7) +  4500 ... = 685.71

  var total_interest_original = parseFloat(
    loan_amount * interest_rate_desc * tenure
  ); //12600

  // Effective interest rate
  var est_interest_rate = interest_rate * 1.8;
  var tmpdone = 0;
  var tmpdtwo = 0;

  for (let step = est_interest_rate; step < 100; step += 0.001) {
    var stepInc = parseFloat(step.toFixed(4));
    var stepIncPerc = parseFloat(stepInc / 100);
    //685.71 * (1-(1/(1.003333^(84)))) = 167.2056916
    var leftSide =
      monthly_repayment_original *
      (1 - Math.pow(1 + stepIncPerc / 12, -tenure * 12));
    //0.3333*45000 = 149.985
    var rightSide = (stepIncPerc / 12) * loan_amount;

    var objCal = Math.pow(leftSide - rightSide, 2).toFixed(4);

    if (objCal === 0.0) {
      var effective_interest_rate = parseFloat(step.toFixed(4));
      break;
    }

    if (tmpdtwo !== 0 && parseFloat(objCal) > parseFloat(tmpdtwo)) {
      var effective_interest_rate = parseFloat(step.toFixed(4));
      break;
    }

    tmpdtwo = objCal;
  }
  console.log("First EIR", effective_interest_rate);

  var total_amount = Math.round(total_interest_original + loan_amount);

  //----------------------------------------------------------------------

  var calculate_lastcf = (effective_interest_rate) => {
      let cf = loan_amount;
      let bf = 0;
      let repayment = Math.round(monthly_repayment_original);
      let last_installment = total_amount - repayment * (tenure * 12 - 1);
    for (let counter = 1; counter < tenure * 12; counter++) {
      bf = cf;
      var interest = (bf * (effective_interest_rate / 100)) / 12;
      cf = bf - repayment + interest;
    }
    
    interest = (cf * (effective_interest_rate / 100)) / 12;
    
    cf = parseFloat(cf.toFixed(2));
    interest = parseFloat(interest.toFixed(2));
    last_installment = parseFloat(last_installment.toFixed(2));
    var last_cf = cf + interest - last_installment;
    return last_cf;
  }

  var last_cf = calculate_lastcf(effective_interest_rate);
  console.log("Last CF:" , last_cf);
  var stopper = effective_interest_rate;

  if (last_cf === 0) {
    effective_interest_rate = parseFloat(effective_interest_rate.toFixed(4));
  } else if (last_cf < 0) {
    for (let step = effective_interest_rate; step < stopper + 0.5; step += 0.000001) {
      step = parseFloat(step.toFixed(6));
      last_cf = calculate_lastcf(step);
      last_cf = parseFloat(last_cf.toFixed(2));
      if (last_cf >= 0.00) {
        effective_interest_rate = parseFloat(step.toFixed(6));
        break;
      }
    }
  } else {
    for (let step = effective_interest_rate; step > stopper - 0.5; step -= 0.000001) {
      step = parseFloat(step.toFixed(6));
      last_cf = calculate_lastcf(step);
      last_cf = parseFloat(last_cf.toFixed(2));
      if (last_cf <= 0.00) {
        effective_interest_rate = parseFloat(step.toFixed(6));
        break;
      }
    }
  }
  console.log(effective_interest_rate);
  return effective_interest_rate;
}