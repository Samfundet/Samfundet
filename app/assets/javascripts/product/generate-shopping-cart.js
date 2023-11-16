const SHOPPING_CART_KEY = "samfShoppingCart";
let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

const createButton = document.getElementById("create-order");
const nameInputField = document.getElementById("order_name")
const emailInputField = document.getElementById("order_email")

createButton.addEventListener("click", postOrder);
function postOrder() {
    console.log("clicked")
    fetch('/orders', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(processShoppingCart())
    }).then(()=> {
        localStorage.clear();
        //window.location.href = `/orders/confirm`
    }).catch(error => {
        location.reload()
    });
}

async function getProducts(id, variation_id) {
   const data =  await fetch('/merch/products_by_id', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({id: id, variation_id: variation_id})})
    return data.json()
}

/**
 * Function for disabling createButton due to missing fields
 */
function checkInputField(e){
    if (/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emailInputField.value) && nameInputField.value !== "") {
        createButton.classList.remove("gray")
        createButton.classList.add("green")
        createButton.disabled = false;
        return;
    }
    createButton.classList.remove("green")
    createButton.classList.add("gray")
    createButton.disabled = true;
}

emailInputField.addEventListener("input", checkInputField);
nameInputField.addEventListener("input", checkInputField);

/**
 * Function for creating JSON for POST-request.
 *  - Strips unnecessary fields from localstorage: img-path, product name etc...
 *  - Retrieve value from input fields: name and epost
 *  - Retrieve value from amount selector
 */
function processShoppingCart() {
    let newShoppingCart = {
        name: document.getElementById("order_name").value,
        email: document.getElementById("order_email").value,
        products: []
    };
    for (const item of shoppingCart ) {
        /** Remove product_id prefix and convert to Int */
        const productId = parseInt(item["id"].substring(8));
        const id = item.variation ? item.variation: item.id;

        /** Retrieve amount from select */
        const amount = document.getElementById(id +"-amount-select").value;
        /** Remove var_id prefix and convert to Int */
        const productVariationId =  item["variation"] ? parseInt(item["variation"].substring(4)) : null;
        const newItem = {
            product_id: productId,
            amount: parseInt(amount),
            product_variation_id: productVariationId
        }
        newShoppingCart.products.push(newItem)
    }
    console.log(newShoppingCart)
    return JSON.stringify(newShoppingCart);
}

/**
 * Function for rendering shopping-cart
 */
async function renderShoppingCart() {
    const ordersDiv = document.getElementById("orders");
    if (shoppingCart === null || shoppingCart.length === 0) {
        const form = document.getElementsByClassName("order-form")
        form[0].style.display = "none";
        return;
    }
    for (const order of shoppingCart) {
        ordersDiv.appendChild(await renderOrder(order))
    }
}

/**
 * Function for creating individual order div
 */
async function renderOrder(order) {
    /** Add amount */
    let response = await getProducts(order.id.substring(8), order.variation ? order.variation.substring(4) : null);

    const product = response.product
    const variation = response.variation
    const img = response.img

    const orderDiv = document.createElement('div');

    orderDiv.className = "order";
    /** Add image */
    const image = document.createElement("img");
    image.src = img;
    image.className = "order-image"

    orderDiv.appendChild(image);
    /** Add info */
    const info = document.createElement("div");

    info.className = "order-info";
    /** Add name */
    const name = document.createElement("p");
    name.innerText = `${product.name_no} ${variation ? (" - " + variation.name) : ""}`;

    info.appendChild(name)
    /** Add price */
    const price = document.createElement("p");
    price.innerText = `Pris: ${parseInt(product.price)} kr`;


    info.appendChild(price)

    const amount = document.createElement("select");

    amount.className = "amount-select"
    amount.id = (order.variation ? order.variation : order.id) + "-amount-select";

    let amountNumber = variation ? variation.amount : product.amount
    amountNumber = amountNumber > 10 ? 10 : amountNumber

    for (let i = 1; i < amountNumber + 1; i++) {
        const option = document.createElement("option");
        option.value = i.toString();
        option.innerText = i.toString();
        amount.appendChild(option);
    }
    info.appendChild(amount)
    orderDiv.appendChild(info)

    /** Add delete button */
    const deleteButton = document.createElement("button");
    deleteButton.innerText = "Fjern";
    deleteButton.className = "samf-button";

    deleteButton.addEventListener("click", () => {
        let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
        const newShoppingCart = shoppingCart.filter(e => {
            if (e.variation && variation) {
                // substrinng 4 on var_x
                return e.variation.substring(4) !== variation.id + ""
            }
            // substring 8 on product_x
            return e.id.substring(8) !== product.id + ""
        });
        localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify(newShoppingCart));
        orderDiv.remove();
    })
    orderDiv.appendChild(deleteButton)
    return orderDiv;
}
renderShoppingCart();