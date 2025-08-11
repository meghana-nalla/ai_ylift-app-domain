import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:web/web.dart' as web;

class MetaTagController extends GetxController {
  // Note: this is such a pain, research a better way to do this
  final GlobalController global = Get.find<GlobalController>();

  void updateProductMetaTags(int productId) async {
    final product = await global.products.getProductSimple(productId);

    final title = '${product.name} - YLift';

    _updateDocumentTitle(title);
    _updateManifest(productId);

    _updateMetaTag('title', title, isProperty: false);
    _updateMetaTag('description', product.description ?? 'Check out this product on YLift', isProperty: false);
    _updateMetaTag('og:title', product.name, isProperty: true);
    _updateMetaTag('og:description',
        product.description ?? 'Check out this product on YLift',
        isProperty: true);
    _updateMetaTag('og:image', PLACEHOLDER_IMAGE, isProperty: true);
    _updateMetaTag('thumbnail', PLACEHOLDER_IMAGE, isProperty: false);
    _updateMetaTag('og:url', '$DOMAIN/product/${product.id}', isProperty: true);
    _updateMetaTag('twitter:card', 'summary_large_image', isProperty: false);
  }

  void _updateDocumentTitle(String title) {
    web.document.title = title;
  }

  void _updateManifest(int productId) {
    final head = web.document.head!;
    var manifestLink = head.querySelector('link[rel="manifest"]');

    if (manifestLink != null) {
      manifestLink.setAttribute('href',
          'https://ylift.app/api/v2/neptune/manifests/manifest-product-$productId.json');
    }
  }

  void _updateMetaTag(String nameOrProperty, String content,
      {required bool isProperty}) {
    final head = web.document.head!;
    final attributeName = isProperty ? 'property' : 'name';

    var element = head.querySelector('meta[$attributeName="$nameOrProperty"]');

    if (element == null) {
      element = web.HTMLLinkElement();
      if (isProperty) {
        element.setAttribute('property', nameOrProperty);
      } else {
        element.setAttribute('name', nameOrProperty);
      }
      element.setAttribute('content', content);
      element.setAttribute('data-rh', 'true');

      head.append(element);
    }
  }
}