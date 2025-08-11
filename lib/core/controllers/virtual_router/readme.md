
when navigating to any page  the  welcome screen (spashscreen) stays. keep in mind the app_controller's logic for the splash screen is not being used. the component is inside the desktop_layout and the logic is using the loading controller wheater to show or not. the loading controller is already set to false but the visibility state of the splashscreenstate is not being updated

// In any controller or widget:
Future<void> someOperation() async {
await Get.find<LoadingService>().withLoading(
operation: () async {
// Your async operation here
await Future.delayed(Duration(seconds: 2)); // Example delay
await fetchData();
},
operationId: 'some-operation'
);
}

// For multiple operations:
await Get.find<LoadingService>().withMultiLoading(
operations: [
() => fetchData1(),
() => fetchData2(),
() => fetchData3(),
],
groupId: 'multiple-operations'
);


// For void operations
await loading.withLoading<void>(
operation: () async => await someVoidOperation()
);

// For operations returning data
final products = await loading.withLoading<List<Product>>(
operation: () => fetchProducts()
);

// For multiple operations of the same type
final results = await loading.withMultiLoading<String>(
operations: [
() => fetchString1(),
() => fetchString2(),
]
);