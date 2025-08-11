import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:flutter/material.dart';

/*
dermamd - 1776624d-1884-4186-a740-5014d66b16f0
miraculously - 6db0805e-1dd2-4302-9b06-a0f6b3a3cdc4
leocorps - 50b6f821-6db4-40a0-958d-14f696c693f4
promoitalia - 1e213d89-ad2f-48b5-a15d-ee3624b56968
cutera - 383f1700-f1c1-461b-a9bc-b44660cdd7bd
evoskin - f363f474-a646-4452-9273-b6096c858806
evolus - b9487e80-fde1-4c58-8e2b-0ef969cb1e25
galderma - c2e5295f-207c-4d6c-8360-b7765afc2ae5
cosmofrance - cc14d479-8c42-4396-a9c7-3baf43ed97c1
rejuran - c377c671-ae24-404c-bf62-5195eed19184
renuvion - 71080128-c401-46bf-9bb0-0aeed60668f0
benev - 7db41c23-49f6-4314-a0e2-1571d942d697
merz - 0d3c05a7-8b9e-430a-bff0-9b1e32514d38
 */

const _imageUuids = <String>[
  '1776624d-1884-4186-a740-5014d66b16f0',
  '6db0805e-1dd2-4302-9b06-a0f6b3a3cdc4',
  '50b6f821-6db4-40a0-958d-14f696c693f4',
  '1e213d89-ad2f-48b5-a15d-ee3624b56968',
  '383f1700-f1c1-461b-a9bc-b44660cdd7bd',
  'f363f474-a646-4452-9273-b6096c858806',
  'b9487e80-fde1-4c58-8e2b-0ef969cb1e25',
  'c2e5295f-207c-4d6c-8360-b7765afc2ae5',
  'cc14d479-8c42-4396-a9c7-3baf43ed97c1',
  'c377c671-ae24-404c-bf62-5195eed19184',
  '71080128-c401-46bf-9bb0-0aeed60668f0',
  '7db41c23-49f6-4314-a0e2-1571d942d697',
  '0d3c05a7-8b9e-430a-bff0-9b1e32514d38',
];

class PartnershipListView extends StatefulWidget {
  const PartnershipListView({
    super.key,
  });

  @override
  State<PartnershipListView> createState() => _PartnershipListViewState();
}

class _PartnershipListViewState extends State<PartnershipListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _autoScroll();
    });
    super.initState();
  }

  void _autoScroll() async {
    if (scrollController.offset >= (scrollController.position.maxScrollExtent - 440)) {
      scrollController.jumpTo(0);
    }
    await scrollController.animateTo(
      scrollController.offset + 240 + 30,
      duration: const Duration(seconds: 4),
      curve: Curves.linear,
    );
    _autoScroll();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: _imageUuids.length * 2,
      itemBuilder: (context, index) {
        // if (index.isOdd) return const GapX();
        final imageUuid = _imageUuids[index % _imageUuids.length];
        return _PartnershipImage(uuid: imageUuid);

        // return Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(),
        //   ),
        //   width: 240,
        //   alignment: Alignment.center,
        //   child: Text('Partnership ${index + 1}'),
        // );
      },
    );
  }
}

class _PartnershipImage extends StatefulWidget {
  final String uuid;
  const _PartnershipImage({
    super.key,
    required this.uuid,
  });

  @override
  State<_PartnershipImage> createState() => _PartnershipImageState();
}

class _PartnershipImageState extends State<_PartnershipImage> with AutomaticKeepAliveClientMixin {
  static const imageRepository = ImageRepository();
  late final Future<String> imageFuture;

  @override
  void initState() {
    imageFuture = imageRepository.getAsyncImageUrl(widget.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            width: 240,
            alignment: Alignment.center,
            child: const Text('Partnership'),
          );
        }
        final imageUrl = snapshot.requireData;
        return Image.network(imageUrl);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
