const SHOPPING_CART_KEY = "shoppingCart";
const products = document.querySelectorAll('.product');

if (localStorage.getItem(SHOPPING_CART_KEY) === null) {
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify([]));
}

function handleAddClick(id, product) {

    const selected = product.querySelector('.selected');
    const image = product.querySelector('img');
    let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
    let added = false;

    for (let i = 0; i < shoppingCart.length; i++){
        if (shoppingCart[i].id === id) {
            if (selected) {
                if (selected.id === shoppingCart[i].variation) {
                    shoppingCart[i] = {id: id, amount: shoppingCart[i].amount + 1, variation: selected.id, img: image.src}
                    added = true;
                }
            } else {
                shoppingCart[i] = {id: id, amount: shoppingCart[i].amount + 1, variation: null, img: image.src }
                added = true;
            }
        }
    }
    if (shoppingCart.length === 0 || !added) {
        shoppingCart.push({id: id, amount: 1, variation: selected ? selected.id : null, img: image.src})
    }
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify(shoppingCart));
    console.table(JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)))
}


for (let product of products) {
    const variations = product.querySelector('.variations').children;
    if (variations.length > 0) {
        variations[0].classList.add('selected')
        for (let variation of variations){
            variation.addEventListener("click", () => {
                for (let removeVar of variations) {
                    if (removeVar.id != variation.id){
                        removeVar.classList.remove('selected')
                    }
                }
                variation.classList.add('selected');
            })
        }
    }
    const button =  product.querySelector('.add-to-cart');

    if (button) {
        button.addEventListener("click", () => handleAddClick(product.id, product))
    }

}