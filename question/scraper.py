import sys
from urllib.parse import urlencode
import requests
from bs4 import BeautifulSoup
BASE_URL = "https://mdcomputers.in/"
def search_products1(search_term):
    """Fetch and extract products from the MDComputers search page."""

    params = {
        "route": "product/search",
        "search": search_term,
    }
    search_url = f"{BASE_URL}?{urlencode(params)}"

    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; TechnicalAssignment/1.0)"
    }

    try:
        response = requests.get(
            search_url,
            headers=headers,
            timeout=15
        )
        response.raise_for_status()
    except requests.RequestException as error:
        print(f"Error retrieving website: {error}")
        return []
    soup = BeautifulSoup(response.text, "html.parser")
    products = []
    # MDComputers product cards contain product names and prices.
    product_names = soup.select("h4.product-title")

    for product_name in product_names:
        name = product_name.get_text(" ", strip=True)

        product_card = product_name.find_parent(
            class_="product-thumb"
        )

        if not product_card:
            continue

        price_element = product_card.select_one(".price-new")

        if price_element:
            price = price_element.get_text(" ", strip=True)

            products.append({
                "name": name,
                "price": price
            })

    return products

def main():
    search_term = input("Enter search term: ").strip()

    if not search_term:
        print("Search term cannot be empty.")
        return

    products = search_products1(search_term)

    if not products:
        print("No products found.")
        return

    print(f"\nProducts found for: {search_term}")
    print("-" * 70)

    for index, product in enumerate(products, start=1):
        print(f"{index}. {product['name']}")
        print(f"   Price: {product['price']}")
        print()

main()
