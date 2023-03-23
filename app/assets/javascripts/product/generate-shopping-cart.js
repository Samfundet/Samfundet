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
        console.log(await response.text())
    }).catch(error => {
        console.error(error.value())
    });
})

function renderShoppingCart() {
    const ordersDiv = document.getElementById("orders");
    if (shoppingCart === null || shoppingCart === []) {
        let title = document.createElement('h1');
        title.textContent = "No orders"

        ordersDiv.appendChild(title);
        return;
    }

    for (order of shoppingCart) {
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
    name.innerText = `${order.name}`;
    info.appendChild(name)

    //Add variation
    if (order.variation) {
        const variation = document.createElement("p");
        variation.innerText = `${order.variation}`;
        info.appendChild(variation)
    }

    //Add price
    const price = document.createElement("p");
    price.innerText = `Pris: ${parseInt(order.price) * order.amount}`;
    info.appendChild(price)

    orderDiv.appendChild(info)


    //Add amount
    const amount = document.createElement("select");
    amount.className = "amount-select"
    for (let i = 1; i < 11; i++) {
        const option = document.createElement("option");
        option.value = i.toString();
        option.innerText = i.toString();
        amount.appendChild(option);
    }
    orderDiv.appendChild(amount)

    return orderDiv;
}
renderShoppingCart();