const SHOPPING_CART_KEY = "samfShoppingCart";
const products = document.querySelectorAll('.product');

/** If the shopping-cart doesn't exist add as empty list */
if (localStorage.getItem(SHOPPING_CART_KEY) === null) {
    localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify([]));
}
/**
 * Function for handling click add to shopping-cart button
 */
function handleAddClick(id, product) {
    /**Find the selected product variation*/
    const selected = product.querySelector('.selected');
    const image = product.querySelector('img');
    const name = product.querySelector('.name').id;
    const price = product.querySelector('.price').id;
    let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)) ? JSON.parse(localStorage.getItem(SHOPPING_CART_KEY)) : [];

    /**Check if ID already exist in shopping-cart*/
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
    emptyShoppingCart()
}

/**Add handleClick to each product and logic for selected variation */
for (let product of products) {
    handleSelectVariation(product);
    const button =  product.querySelector('.add-to-cart');
    if (button) {
        button.addEventListener("click", () => handleAddClick(product.id, product))
    }
}

/**
 * Function for displaying selected variation
 */
function handleSelectVariation(product) {
    const variations = product.querySelector('.variations').children;
    if (variations.length > 0) {
        /** Set first element as selected */
        variations[0].classList.add('selected')
        /** Add select and remove functionality to all variations */
        for (let variation of variations){
            variation.addEventListener("click", () => {
                for (let removeVariation of variations) {
                    if (removeVariation.id !== variation.id){
                        removeVariation.classList.remove('selected')
                    }
                }
                variation.classList.add('selected');
            })
        }
    }
}

function emptyShoppingCart() {
    const shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
    const shoppingCartButton = document.getElementById("shopping-cart-button");

    if (shoppingCart.length === 0) {
        shoppingCartButton.classList.add("gray")
        shoppingCartButton.classList.remove("red")
        shoppingCartButton.disabled = true;
        shoppingCartButton.href = null;
        return;
    }
    shoppingCartButton.classList.remove("gray")
    shoppingCartButton.classList.add("red")
    shoppingCartButton.disabled = false;
}

emptyShoppingCart()