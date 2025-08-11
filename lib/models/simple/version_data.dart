import 'package:YLift/hardcodes/promotions/spring_into_rewards/spring_into_rewards.dart';

enum UpdateType { major, minor, patch,  none }

class VersionCode implements Comparable<VersionCode> {
  final int major;
  final int minor;
  final int patch;

  const VersionCode(this.major, this.minor, this.patch);

  factory VersionCode.fromString(String value) {
    value = value.replaceAll('v', '');
    final parts = value.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid version format: $value');
    }
    final major = int.tryParse(parts[0]) ?? 0;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = int.tryParse(parts[2]) ?? 0;
    return VersionCode(major, minor, patch);
  }

  static UpdateType checkUpdateType(VersionCode current, VersionCode latest) {
    if (latest.major > current.major) {
      return UpdateType.major;
    }
    if (latest.major == current.major && latest.minor > current.minor) {
      return UpdateType.minor;
    }
    if (latest.major == current.major &&
        latest.minor == current.minor &&
        latest.patch > current.patch) {
      return UpdateType.patch;
    }
    return UpdateType.none;
  }

  @override
  String toString() => '$major.$minor.$patch';

  @override
  int compareTo(VersionCode other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }

    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }

    return patch.compareTo(other.patch);
  }

  bool operator >(VersionCode other) {
    return compareTo(other) > 0;
  }

  bool operator <(VersionCode other) {
    return compareTo(other) < 0;
  }

  bool operator >=(VersionCode other) {
    return compareTo(other) >= 0;
  }

  bool operator <=(VersionCode other) {
    return compareTo(other) <= 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VersionCode &&
        other.major == major &&
        other.minor == minor &&
        other.patch == patch;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;
}

class VersionData {
  final VersionCode versionCode;
  final List<FeatureData> features;
  const VersionData({required this.versionCode, required this.features});

  static const version104 = VersionData(
    versionCode: VersionCode(1, 0, 4),
    features: [
      FeatureData(
        title: 'New Promotion: Spring Into Rewards',
        description:
            'Buy Galderma products and get up to 250 \$50 coupon codes!\nPromotion lasts until May 2nd, 2025',
        imageUrl: SpringIntoRewardsPromotion.bannerImageUrl,
      ),
      FeatureData(
        title: 'Clearer Order Requirements!',
        description: 'Order requirements are now more visible and instructive',
      ),
    ],
  );
}

class FeatureData {
  final String title;
  final String? imageUrl;
  final String description;

  const FeatureData({
    required this.title,
    required this.description,
    this.imageUrl,
  });
}
