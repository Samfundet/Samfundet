const SHOPPING_CART_KEY = "samfShoppingCart";
let shoppingCart = JSON.parse(localStorage.getItem(SHOPPING_CART_KEY));
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

const createButton = document.getElementById("create-order");
const nameInputField = document.getElementById("order_name")
const epostInputField = document.getElementById("order_epost")

createButton.addEventListener("click", postOrder);
/**
 * Function for posting order
 * TODO:
 *  - handle error by displaying to end user
 */
function postOrder() {
    console.log("clicked")
    fetch('/orders', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(processShoppingCart())
    }).then(async response => {
        const order = await response.json()
        localStorage.clear();
        window.location.href = `/orders/confirm`
    }).catch(error => {
        console.error(error)
    });
}

/**
 * Function for disabling createButton due to missing fields
 * TODO: add check for email and blankspace
 */
function checkInputField(e){
    if (/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(epostInputField.value) && nameInputField.value !== "") {
        createButton.classList.remove("gray")
        createButton.classList.add("green")
        createButton.disabled = false;
        return;
    }
    createButton.classList.remove("green")
    createButton.classList.add("gray")
    createButton.disabled = true;
}

//epostInputField.addEventListener("input", checkInputField);
//nameInputField.addEventListener("input", checkInputField);

epostInputField.value = "snorrekr@samfundet.no"
nameInputField.value = "Snurre Sprett"
createButton.classList.remove("gray")
createButton.classList.add("green")
createButton.disabled = false;

/**
 * Function for creating JSON for POST-request.
 *  - Strips unnecessary fields from localstorage: img-path, product name etc...
 *  - Retrieve value from input fields: name and epost
 *  - Retrieve value from amount selector
 */
function processShoppingCart() {
    let newShoppingCart = {
        name: document.getElementById("order_name").value,
        epost: document.getElementById("order_epost").value,
        products: []
    };
    for (const item of shoppingCart ) {
        /** Remove product_id prefix and convert to Int */
        const productId = parseInt(item["id"].substring(8));
        /** Retrieve amount from select */
        const amount = document.getElementById(item["id"] +"-amount-select").value;
        /** Remove var_id prefix and convert to Int */
        const productVariationId =  item["variation"] ? parseInt(item["variation"].id.substring(4)) : null;
        const newItem = {
            product_id: productId,
            amount: amount,
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
function renderShoppingCart() {
    const ordersDiv = document.getElementById("orders");
    if (shoppingCart === null || shoppingCart.length === 0) {
        const form = document.getElementsByClassName("order-form")
        form[0].style.display = "none";

        const title = document.getElementById("title");
        title.innerText = "Handlekurv"
        ordersDiv.appendChild(title);
        return;
    }
    for (const order of shoppingCart) {
        ordersDiv.appendChild(renderOrder(order))
    }
}

/**
 * Function for creating individual order div
 */
function renderOrder(order) {
    const orderDiv = document.createElement('div');
    orderDiv.className = "order";


    /** Add image */
    const image = document.createElement("img");
    image.src = order.img;
    image.className = "order-image"
    orderDiv.appendChild(image);

    /** Add info */
    const info = document.createElement("div");
    info.className = "order-info";

    /** Add name */
    const name = document.createElement("p");
    name.innerText = `${order.name} ${order.variation ? (" - " + order.variation.name) : ""}`;
    info.appendChild(name)

    /** Add price */
    const price = document.createElement("p");
    price.innerText = `Pris: ${parseInt(order.price) * order.amount}`;
    info.appendChild(price)


    /** Add amount */
    const amount = document.createElement("select");
    amount.className = "amount-select"
    amount.id = order.id + "-amount-select";
    for (let i = 1; i < 11; i++) {
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
        const newShoppingCart = shoppingCart.filter(e => e.id !== order.id);
        localStorage.setItem(SHOPPING_CART_KEY, JSON.stringify(newShoppingCart));
        orderDiv.remove();
    })
    orderDiv.appendChild(deleteButton)
    return orderDiv;
}
renderShoppingCart();