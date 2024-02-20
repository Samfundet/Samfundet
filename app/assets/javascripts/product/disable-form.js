let has_variations = document.getElementById("product_has_variations");
let amount = document.getElementById("product_amount")

if (!has_variations.checked) {
    amount.disabled = false;
} else {
    amount.value = 0;
}
has_variations.addEventListener("change", (e) =>{
    if (e.target.checked) {
        amount.disabled = true;
        amount.value = 0;
    } else {
        amount.disabled = false;
    }
})