import { calculateEffectiveRate } from './calculateEffectiveRate.js';

const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

// When click button
$("#btnCalculate").click(function (e) {
    e.preventDefault();
    resetPage();
    if (validateInput()) {
        let caArray = calcCapitalAllowance();
        if(caArray.length > 0){
            $('#caSummaryTable').show();
            createSummaryTable(caArray);
            createDetailTable(caArray);
        } 

        $(".printButtons").removeClass("d-none");

        // Container Anchor to scroll the webpage to the table 
        let containerAnchor = document.getElementById('result');

        if (containerAnchor) {
            containerAnchor.scrollIntoView({
                behavior: 'smooth'
            });
        }
    }
});

// Reset Webpage
function resetPage(){
    $("#disposalContainer").css("display", "none");
    $('#caTable').hide();
    $('#caSummaryTable').hide();
    $('#tableBody').empty();
    $('#summaryTableBody').empty();
    $(".printButtons").addClass("d-none");
    $("#disposalAmount").html('-');
    $("#residualExpenditure").html('-');
    $("#balancingAllowance").html('-');
    $("#balancingCharge").html('-');
    console.log('hi')
    console.log($("#disposalAmount").html());
    console.log($("#residualExpenditure").html());
    console.log($("#balancingAllowance").html());
    console.log($("#balancingCharge").html());
}

// Validation for input
function validateInput(){
    $("#assetCat").removeClass("is-invalid");
    $("#assetTypeDropdown").removeClass("is-invalid");
    $("#iaRate").removeClass("is-invalid");
    $("#aaRate").removeClass("is-invalid");
    $("#assetCost").removeClass("is-invalid");
    $("#acquireDate").removeClass("is-invalid");
    $("#downPayment").removeClass("is-invalid");
    $("#numInstallment").removeClass("is-invalid");
    $("#interest").removeClass("is-invalid");
    $("#disposalValue").removeClass("is-invalid");
    $("#diposalDate").removeClass("is-invalid");
    $("#fyMonth").removeClass("is-invalid");
    let validate = true;
    console.log($("#assetCat").val());
    // Check if the "Asset Category" dropdown is empty
    if($("#fyChkBx").prop("checked")) {
        if ($("#fyMonth").val() == "") {
            $("#fyMonth").focus();
            $("#fyMonth").addClass("is-invalid");
            validate = false;
        } 
    }
    if($("#disposalChkBx").prop("checked")) {
       if ($("#disposalDate").val() == "") {
            $("#disposalDate").focus();
            $("#disposalDate").addClass("is-invalid");
            validate = false;
        } 
        if ($("#disposalValue").val() == "" || $("#disposalValue").val() < 0) {
            $("#disposalValue").focus();
            $("#disposalValue").addClass("is-invalid");
            validate = false;
        } 
    } 
    if ($("#hirePurchaseChkBx").prop("checked")) {
        if ($("#numInstallment").val() == "" || $("#numInstallment").val() == 0 || $("#numInstallment").val() < 0) {
            $("#numInstallment").focus();
            $("#numInstallment").addClass("is-invalid");
            validate = false;
        }

        if ($("#interest").val() == "" || $("#interest").val() < 0) {
            $("#interest").focus();
            $("#interest").addClass("is-invalid");
            validate = false;
        } 

        if ($("#downPayment").val() == "" || $("#downPayment").val() < 0 ||  parseFloat($("#downPayment").val()) > parseFloat($("#assetCost").val())) {
            console.log( $("#assetCost").val())
            $("#downPayment").focus();
            $("#downPayment").addClass("is-invalid");
            if (parseFloat($("#downPayment").val()) > parseFloat($("#assetCost").val())){
                $("#downPaymentInvalid").text("Down Payment exceeded Cost of Asset");
            }
            validate = false;
        } 

    } 
    if ($("#acquireDate").val() == "") {
        $("#acquireDate").focus();
        $("#acquireDate").addClass("is-invalid");
        validate = false;
    } 
    if ($("#assetCost").val() == "" || $("#assetCost").val() == 0 || $("#assetCost").val() < 0) {
        $("#assetCost").focus();
        $("#assetCost").addClass("is-invalid");
        validate = false;
    } 
    if ($("#aaRate").val() == "" || $("#aaRate").val() < 0) {
        $("#aaRate").focus();
        $("#aaRate").addClass("is-invalid");
        validate = false;
    } 
    if ($("#iaRate").val() == "" || $("#iaRate").val() < 0) {
        $("#iaRate").focus();
        $("#iaRate").addClass("is-invalid");
        validate = false;
    } 
    if ($("#assetCat").val() == "" || $("#assetCat").val() == undefined) {
        // If empty, set focus, add 'is-invalid' class, and set validate flag to false
        $("#assetCat").focus().addClass("is-invalid");
        validate = false;
    } 
    if (!($("#assetCat").hasClass('is-invalid')) && $("#assetTypeDropdown").val() === ""){
        // If "Asset Type" is empty, set focus, add 'is-invalid' class, and set validate flag to false
        $("#assetTypeDropdown").focus().addClass("is-invalid");
        validate = false;
    } 

    return validate;
}

function calcCapitalAllowance() {
    let FinancialMonth = {
        January: 0,
        February: 1,
        March: 2,
        April: 3,
        May: 4,
        June: 5,
        July: 6,
        August: 7,
        September: 8,
        October: 9,
        November: 10,
        December: 11
    }
    // Retrieve values from fields
    let initialAllowanceRate = $("#iaRate").val();
    let annualAllowanceRate = $("#aaRate").val();
    let allowanceCap = $("#allowanceCap").val();
    let acquireDate = $("#acquireDate").val(); 
    console.log(acquireDate);
    let assetCost = $("#assetCost").val();
    let downPayment = $("#downPayment").val();
    let tenure = $("#numInstallment").val();
    let interest = $("#interest").val();
    let costSite = $("#costSite").val();


    const MaxAllowancePercent = 100;

    let caArray = [];

    assetCost = parseFloat(assetCost);
    costSite = parseFloat(costSite);

    // Validate if the cost site is less than the sum of asset cost and the cost site
    if (costSite < (assetCost + costSite) * 0.1) {
        assetCost += costSite;
    }

    let allowanceEligible = allowanceCap ? (assetCost < allowanceCap ? assetCost : allowanceCap) : assetCost;

    // Split the string by "/"
    let [acquireMonth, acquireYear] = acquireDate.split("/");

    // Convert month and year to integers
    acquireMonth = parseInt(acquireMonth) - 1;
    acquireYear = parseInt(acquireYear);

    if ($("#fyChkBx").prop("checked")){
        let [fyMonth, fyYear] = acquireDate.split("/");
        const selectedMonthName = new Date(fyMonth + '-01').toLocaleString('en-us', { month: 'long' });

        let monthCounter = FinancialMonth[selectedMonthName];
        // Reassign the financial month dictionary
        for (let i = 0; i < 12; i++){
            if(monthCounter > 11){
                monthCounter = 0;
            }
            FinancialMonth[months[monthCounter]] = i;
            monthCounter ++;
    
        }
    }

    if(FinancialMonth[months[acquireMonth]] < acquireMonth) {
        acquireYear += 1;
        console.log(acquireYear)
    };

    if ($("#hirePurchaseChkBx").prop("checked")) {
        caArray = withInstallment(FinancialMonth, initialAllowanceRate, annualAllowanceRate, acquireYear, acquireMonth, assetCost, allowanceEligible, MaxAllowancePercent, downPayment, tenure, interest)
    } else {
        caArray = withoutInstallment(initialAllowanceRate, annualAllowanceRate, acquireYear, allowanceEligible, MaxAllowancePercent)
    }

    // Display the JSON object in the console (you can modify this part based on your needs)
    if ($("#disposalChkBx").prop("checked")) {
        let disposalDate = $("#disposalDate").val();
        let disposalValue = $("#disposalValue").val();
        let [disposalMonth, disposalYear] = disposalDate.split("/");
        disposalMonth = new Date(disposalMonth + '-01').toLocaleString('en-us', { month: 'long' });
        disposalYear = parseInt(disposalYear);

        if(FinancialMonth[months[disposalMonth]] < disposalMonth) {
            disposalYear += 1;
            console.log(disposalYear)
        };

        disposalValue = parseFloat(disposalValue);

        // Fitler caArray
        let disposedArray = caArray.filter(d => d.year >= disposalYear);
        caArray = caArray.filter(d => d.year < disposalYear);

        displayDisposal(disposedArray, disposalValue);
    }
    return caArray;
}

function displayDisposal(disposedArray, disposalValue){
    let sumIA = disposedArray.reduce((sum, item) => sum + (item.IA ? item.IA : 0), 0);
    let sumAA = disposedArray.reduce((sum, item) => sum + item.AA, 0);

    // Calculate the remaining value
    let residual_expenditure = Math.round(sumIA + sumAA);
    let balancing = Math.round(residual_expenditure - disposalValue);

    $("#disposalContainer").css("display", "block");
    $("#disposalAmount").html(disposalValue);
    $("#residualExpenditure").html(residual_expenditure);
    if (balancing >= 0) {
        $("#balancingAllowance").html(balancing);
    } else {
        $("#balancingCharge").html(balancing);
    }
}

function withoutInstallment(initialAllowanceRate, annualAllowanceRate, acquireYear, allowanceEligible, MaxAllowancePercent) {

    let caArray = [];
    let year = acquireYear;
    let twdvBFWD = allowanceEligible;
    let firstInitialAllowance = allowanceEligible * initialAllowanceRate / MaxAllowancePercent;
    let firstAnnualAllowance = allowanceEligible * annualAllowanceRate / MaxAllowancePercent;
    let twdvCFWD = twdvBFWD - firstInitialAllowance - firstAnnualAllowance;
    let qeBfwd = 0;
    let leftPercent = (MaxAllowancePercent - initialAllowanceRate - annualAllowanceRate) / MaxAllowancePercent;
    let annualAllowanceRateDec = annualAllowanceRate / MaxAllowancePercent;
    let caRec = { year: year, qeBfwd: qeBfwd, IARate: initialAllowanceRate, AARate: annualAllowanceRate, qeCfwd: allowanceEligible, totalqe: allowanceEligible, taxBfwd: twdvBFWD, taxTotal: twdvBFWD, IA: firstInitialAllowance, AA: firstAnnualAllowance, taxCfwd: twdvCFWD };
    caArray.push(caRec);
    qeBfwd = allowanceEligible;
    twdvBFWD = twdvCFWD;
    while (leftPercent > 0) {
        let annualAllowance;
        if (leftPercent < annualAllowanceRateDec) {
            annualAllowance = allowanceEligible * leftPercent;
        } else {
            annualAllowance = allowanceEligible * annualAllowanceRateDec;
        }
        twdvCFWD = twdvBFWD - annualAllowance;
        year += 1;
        caRec = { year: year, qeBfwd: qeBfwd, IARate: initialAllowanceRate, AARate: annualAllowanceRate, qeCfwd: allowanceEligible, totalqe: allowanceEligible, taxBfwd: twdvBFWD, taxTotal: twdvBFWD, AA: annualAllowance, taxCfwd: twdvCFWD };
        twdvBFWD = twdvCFWD;
        caArray.push(caRec);
        leftPercent -= (annualAllowanceRate / MaxAllowancePercent);
    }
    return caArray;
}

// Function to be invoked when the asset is purchased with hire purchase
function withInstallment(FinancialMonth, initialAllowanceRate, annualAllowanceRate, acquireYear, acquireMonth, assetCost, allowanceEligible, MaxAllowancePercent, downPayment, tenure, interest) {
    const loan_amount = assetCost - downPayment;
    const numInstallment = tenure * 12;
    const effective_rate_desc = calculateEffectiveRate(loan_amount, interest, tenure) / 100;
    const interest_rate_desc = parseFloat(interest / 100);
    const monthly_repayment_original = parseFloat(loan_amount * interest_rate_desc * tenure + loan_amount) / (tenure * 12);
    const total_interest_original = parseFloat(loan_amount * interest_rate_desc * tenure);
    const total_amount = Math.round(total_interest_original + loan_amount);
    const open_balance = allowanceEligible - downPayment;
    const repayment = Math.round(monthly_repayment_original);
    const last_installment = total_amount - repayment * (numInstallment - 1);
    acquireYear = parseInt(acquireYear);
    let qeYearly = {};

    qeYearly = calculateQualifyingExpenditure(FinancialMonth, acquireYear, acquireMonth, downPayment, open_balance, allowanceEligible, numInstallment, repayment, last_installment, effective_rate_desc)


    let caArray = [];
    for (let key in qeYearly) {
        let firstInitialAllowance = Math.round((qeYearly[key] * initialAllowanceRate / MaxAllowancePercent) * 100) / 100;
        let firstAnnualAllowance = Math.round((qeYearly[key] * annualAllowanceRate / MaxAllowancePercent) * 100) / 100;
        let leftPercent = (MaxAllowancePercent - initialAllowanceRate - annualAllowanceRate) / MaxAllowancePercent;
        key = parseInt(key)
        let year = key;
        let yearExist = false;
        let caRec;

        for (let caObject of caArray) {
            if (caObject.year == key) {
                yearExist = true;
                caObject.IA = firstInitialAllowance;
                caObject.AA = Math.round((caObject.AA + firstAnnualAllowance) * 100) / 100;
                caRec = caObject;
                break;
            }
        }
        if (!yearExist) {
            caRec = { year: key, IARate: initialAllowanceRate, AARate: annualAllowanceRate, IA: firstInitialAllowance, AA: firstAnnualAllowance };
            caArray.push(caRec);
        }

        caRec.qeAddition = qeYearly[key];
        caRec.taxAddition = qeYearly[key];

        while (leftPercent > 0) {

            let yearExist = false;
            let annualAllowance = 0;

            if (leftPercent < (annualAllowanceRate / MaxAllowancePercent)) {
                annualAllowance = Math.round((qeYearly[key] * leftPercent) * 100) / 100;;
            } else {
                annualAllowance = Math.round((qeYearly[key] * annualAllowanceRate / MaxAllowancePercent) * 100) / 100;
            }

            year++; 
            for (let caObject of caArray) {
                if (caObject.year == year) {
                    yearExist = true;
                    caObject.AA = Math.round((caObject.AA + annualAllowance) * 100) / 100;
                    caObject.qeCfwd = Math.round((caObject.qeCfwd + qeYearly[key]) * 100) / 100;
                    break;
                }
            }
            if (!yearExist) {
                let caRec = { year: year, qeCfwd: qeYearly[key], IARate: initialAllowanceRate, AARate: annualAllowanceRate, AA: annualAllowance };
                caArray.push(caRec);
            }
            leftPercent = Math.round((leftPercent - (annualAllowanceRate / MaxAllowancePercent)) * 100) / 100;
        }
    }


    let previousQE = 0;
    let taxCfwd = 0;
    let qeAddition = 'qeAddition';
    let qeBfwd = 0;
    for (let caObject of caArray) {
        let allowance = 0;
        if (caObject.hasOwnProperty(qeAddition)) {
            caObject.totalqe = previousQE + caObject[qeAddition];
            caObject.taxTotal = taxCfwd + caObject[qeAddition];
            allowance = caObject.IA + caObject.AA;
        } else {
            caObject.totalqe = previousQE;
            caObject.taxTotal = taxCfwd;
            allowance = caObject.AA;
        }
        caObject.qeBfwd = qeBfwd;
        qeBfwd = caObject.totalqe;
        previousQE = caObject.totalqe;
        caObject.taxBfwd = taxCfwd;
        taxCfwd = caObject.taxTotal - allowance;
        caObject.taxCfwd = taxCfwd;
    }
    console.log(caArray);
    return caArray;

}

// Function to calculate qualifying expenditure incurred every year if got installment
function calculateQualifyingExpenditure(FinancialMonth, acquireYear, acquireMonth, downPayment, open_balance, allowanceEligible, numInstallment, repayment, last_installment, effective_rate_desc) {
    let remaining_open_balance = open_balance;
    let numInstallmentLeft = numInstallment;
    let qeYearly = {};

    console.log(months[acquireMonth])
    console.log(FinancialMonth[months[acquireMonth]])
    console.log(acquireMonth)
    
    let year = acquireYear;

    if (FinancialMonth[months[acquireMonth]] != 0 && remaining_open_balance > 0) {
        console.log("Not first month of financial year")
        let qualifying_expenditure = 0;
        let firstYearMonths = 0 ;

        console.log(typeof(FinancialMonth[months[acquireMonth]]))
        firstYearMonths = 12 - FinancialMonth[months[acquireMonth]];
        console.log(firstYearMonths);
        for (let i = 0; i < firstYearMonths; i++) {
            const capital_repayment = repayment - (remaining_open_balance * effective_rate_desc) / 12;
            qualifying_expenditure += capital_repayment;
            remaining_open_balance -= capital_repayment;
            numInstallmentLeft--;
        }

        if (remaining_open_balance < 0) {
            qeYearly[acquireYear] = open_balance;
        } 
        else {
            qeYearly[acquireYear] = qualifying_expenditure;
        }
        console.log(open_balance);
        year++;
    }

    let previous_open_balance = remaining_open_balance
    while (numInstallmentLeft > 0 && remaining_open_balance > 0) {
        var qualifying_expenditure = 0;
        for (let numMonth = 0; numMonth < 12 && numInstallmentLeft > 1; numMonth++) {
            let capital_repayment = repayment - (remaining_open_balance * effective_rate_desc) / 12;
            qualifying_expenditure += capital_repayment;
            remaining_open_balance -= capital_repayment;
            numInstallmentLeft--;
        }
        if (numInstallmentLeft == 1) {
            let capital_repayment = last_installment - (remaining_open_balance * effective_rate_desc) / 12;
            qualifying_expenditure += capital_repayment;
            remaining_open_balance -= capital_repayment;
            numInstallmentLeft--;
        }

        if (remaining_open_balance < 0) {
            qeYearly[year] = Math.round(previous_open_balance * 100) / 100;

        } else {
            qeYearly[year] = Math.round(qualifying_expenditure * 100) / 100;
        }

        previous_open_balance = remaining_open_balance;
        year++;
    }
    console.log(qeYearly)

    if (open_balance > 0) {
        console.log(parseFloat(qeYearly[acquireYear]))
        qeYearly[acquireYear] = parseFloat(qeYearly[acquireYear]) + parseFloat(downPayment);
    } else {
        qeYearly[acquireYear] = allowanceEligible;
    }
    console.log(qeYearly)
    return qeYearly;
}

// Function to create a table row with keys and values from an object
function createDetailTableRow(table, dataObject) {
    let columnOrder = ['year', 'qeBfwd', 'qeAddition', 'totalqe', 'taxBfwd', 'taxAddition', 'taxTotal', 'IARate', 'IA', 'AARate', 'AA', 'taxCfwd'];
    let row = table.insertRow(); // Create a table row

    for (let column of columnOrder) {
        let cellValue = row.insertCell(); // Create a cell for the value
        if (dataObject.hasOwnProperty(column)) {
            cellValue.textContent = Math.round(dataObject[column]);
        } else {
            cellValue.textContent = '-';
        }
    }
}

function createDetailTable(caArray) {
    let myTable = document.getElementById("tableBody");
    document.getElementById("tableBody").innerHTML = '';
    for (let i = 0; i < caArray.length; i++) {
        createDetailTableRow(myTable, caArray[i]);
    }
}

// Function to create a table row with keys and values from an object
function createSummaryTableRow(table, dataObject) {
    let columnOrder = ['year', 'qeCfwd', 'taxBfwd', 'qeAddition', 'IA', 'AA', 'taxCfwd'];
    let row = table.insertRow(); // Create a table row

    for (let column of columnOrder) {
        let cellValue = row.insertCell(); // Create a cell for the value
        if (dataObject.hasOwnProperty(column)) {
            cellValue.textContent = Math.round(dataObject[column]);
        } else {
            cellValue.textContent = '-';
        }
        cellValue.classList.add(column);
    }
}

function createSummaryTable(caArray) {
    let myTable = document.getElementById("summaryTableBody");
    myTable.innerHTML = '';
    for (let i = 0; i < caArray.length; i++) {
        createSummaryTableRow(myTable, caArray[i]);
    }
}
