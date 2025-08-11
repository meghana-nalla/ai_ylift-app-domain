
# Route Notes

## Shop Route

```agsl
      /*
        SHOP ROUTE /shop

        parent widget to display:
          - ShopPage()
            - path: /lib/presentation/pages/desktop/shopping/store_password_field.dart

        child widgets using API data:
          - BrowseByCategory() uses:
            - GlobalController.categories: List<ProductCategory>
              - ProductCategory.name: String

          - BestSellersView() uses:
            - GlobalController.bestSellerSimple: List<ProductSimple>
              - ProductSimple.name: String
              - ProductSimple.price: double
              - ProductSimple.imageUrl: String

        child widgets with additional routing:
          - BestSellersView.ProductCard() -> ProductPageView()

      */
```