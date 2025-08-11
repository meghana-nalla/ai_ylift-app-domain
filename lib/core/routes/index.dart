import 'package:YLift/core/routes/middleware/auth_middleware.dart';
import 'package:get/get.dart';
import 'package:YLift/presentation/pages/mobile/z-index_export.dart';
import 'package:YLift/app_controller.dart';
import 'middleware/product_meta_tag.dart';

// developer note: this is a list of routes for the app
// however, the route logic is implemented in the AppController
// as well as the virtual router.
// this is used for cold entry points
class AppPages {
  static final routesMobile = [
    GetPage(name: '/', page: () => AppController()),
    GetPage(name: '/home', page: () => AppController()),
    GetPage(name: '/video', page: () => AppController()),
    GetPage(name: '/profile', page: () => AppController()),
    GetPage(name: '/cart', page: () => AppController()),
    GetPage(name: '/menu', page: () => AppController()),
    GetPage(name: '/chat', page: () => AppController()),
    GetPage(name: '/shop', page: () => AppController()),
    GetPage(name: '/user/migration', page: () => AppController()),
    GetPage(
      name: '/product/:id',
      page: () => ProductScreen(),
      middlewares: [ProductMetaTagMiddleware()],
    ),
  ];

  static final routesDesktop = <GetPage>[
    GetPage(
      name: '/',
      page: () => AppController(),
      transition: Transition.noTransition,
      middlewares: [AuthMiddleWare()]
    ),
    GetPage(
      name: '/login',
      page: () => AppController(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/shop/brand/:brandId',
      page: () => AppController(),
      transition: Transition.noTransition,
      preventDuplicates: false,
    ),
    GetPage(
      name: '/shop/product/:productId',
      page: () => AppController(),
      transition: Transition.noTransition,
      preventDuplicates: false,
    ),
    GetPage(
      name: '/courses/view/:videoId',
      page: () => AppController(),
      transition: Transition.noTransition,
      preventDuplicates: false,
    ),
    GetPage(
      name: '/training/videos/:videoId',
      page: () => AppController(),
      transition: Transition.noTransition,
      preventDuplicates: false,
    ),
  ];
}
