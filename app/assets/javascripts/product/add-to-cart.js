const SHOPPING_CART_KEY = "shoppingCart";
const products = document.querySelectorAll('.product');

if (localStorage.getItem(SHOPPING_CART_KEY) === null) {
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify([]));
}

function handleAddClick(id, product) {
    const selected = product.querySelector('.selected');
    const image = product.querySelector('img');
    const name = product.querySelector('.name').id;
    const price = product.querySelector('.price').id;
    let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)) ? JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)) : [];

    const idAlreadyInCart = shoppingCart.some(item => {
        if (selected && item.variation) {
            return item.variation.id === selected.id;
        }

        return item.id === id
    });

    if(!idAlreadyInCart) {
        shoppingCart.push({id: id, amount: 1, variation: selected ? {id:selected.id, name: selected.innerText} : null,  img: image.src, name: name, price: price});
    }

    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify(shoppingCart));
    console.table(JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)));
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