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
        body: JSON.stringify(processShoppingCart())
    }).then(async response => {
        console.log(await response.json())
    }).catch(error => {
        console.error(error.value())
    });
});
function processShoppingCart() {
    let newShoppingCart = {
        name: document.getElementById("order_name").value,
        epost: document.getElementById("order_epost").value,
        products: []
    };
    for (const item of shoppingCart ) {
        //Remove product_id prefix and convert to Int
        const productId = parseInt(item["id"].substring(8));
        //Retrieve amount from select
        const amount = document.getElementById(item["id"] +"-amount-select").value;
        //Remove var_id prefix and convert to Int
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

function renderShoppingCart() {
    const ordersDiv = document.getElementById("orders");
    if (shoppingCart === null || shoppingCart === []) {
        let title = document.createElement('h1');
        const form = document.getElementsByClassName("order-form")
        form[0].style.display = "none";
        title.textContent = "No orders"

        ordersDiv.appendChild(title);
        return;
    }

    for (const order of shoppingCart) {
        ordersDiv.appendChild(renderOrder(order))
    }

}

function renderOrder(order) {
    const orderDiv = document.createElement('div');
    orderDiv.className = "order";


    //Add image
    const image = document.createElement("img");
    image.src = order.img;
    image.className = "order-image"
    orderDiv.appendChild(image);

    //Add info
    const info = document.createElement("div");
    info.className = "order-info";

    //Add name
    const name = document.createElement("p");
    name.innerText = `${order.name} ${order.variation ? (" - " + order.variation.name) : ""}`;

    info.appendChild(name)
    //Add price
    const price = document.createElement("p");
    price.innerText = `Pris: ${parseInt(order.price) * order.amount}`;
    info.appendChild(price)


    //Add amount
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

    return orderDiv;
}
renderShoppingCart();