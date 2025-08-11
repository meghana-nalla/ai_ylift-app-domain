import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/yan_trokel_bio.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/yuly_gorodisky_bio.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
class EventLocationDialog extends StatelessWidget {
  final String imageUrl;
  final String locationName;
  final String description;
  final String date;
  final AddressSimple locationAddress;

  const EventLocationDialog({
    super.key,
    required this.imageUrl,
    required this.locationName,
    required this.description,
    required this.date,
    required this.locationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 1400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(imageUrl),
                  const GapX(),
                  SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        Text(description),
                        const SizedBox(height: 32),
                        const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(locationAddress.twoLines),
                        const GapY(),
                        const Text('Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(date),
                        const GapY(),
                        const Text('Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Tel: ${locationAddress.phone}'),
                        const Text('Email: info@ylift.com'),
                      ],
                    ),
                  ),
                ],
              ),
              const GapY(),
              const Column(
                children: [
                  Text(
                    'Faculty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 32),
                  Wrap(
                    spacing: YLiftConstant.gap * 2,
                    runSpacing: YLiftConstant.gap * 2,
                    children: [
                      YanTrokelBio(),
                      YulyGorodiskyBio(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
