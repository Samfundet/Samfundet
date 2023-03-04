const SHOPPING_CART_KEY = "shoppingCart";
const products = document.querySelectorAll('.product');

if (localStorage.getItem(SHOPPING_CART_KEY) === null) {
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify([]));
}

function handleClick(id) {
    let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
    let added = false;

    for (let i = 0; i < shoppingCart.length; i++){
        if (shoppingCart[i].id === id) {
            shoppingCart[i] = {id: id, amount: shoppingCart[i].amount + 1}
            added = true;
        }
    }
    if (shoppingCart.length === 0 || !added) {
        shoppingCart.push({id: id, amount: 1})
    }
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify(shoppingCart));
}


for (let product of products) {
    const button =  product.querySelector('.add-to-cart');
    if (button) {
        button.addEventListener("click", () => handleClick(product.id))
    }
}