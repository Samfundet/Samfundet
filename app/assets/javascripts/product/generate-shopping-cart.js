const SHOPPING_CART_KEY = "shoppingCart";
let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
const createButton = document.getElementById("create-order");
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
createButton.addEventListener("click", () => {
    console.log("clicked")
    fetch('/orders', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(shoppingCart)
    }).then(async response => {
        console.log(response.text())
    }).catch(error => {
        console.error(error.value())
    });
})

function renderShoppingCart() {
    if (shoppingCart === null) {
        return;
    }
}
renderShoppingCart();