import 'package:YLift/core/constants/constant.dart';

class PracticeLuxuryPromotionData {
  final int tierLevel;
  final String productDescriptions;

  /// In cents so 100000 is $1000.00
  final int spendingThreshold;
  final List<String> selectableItems;
  final String imageUrl;

  static const headerImageUrl =
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img4.png';

  static final expirationDate = DateTime(2025, 3, 31, 18); // March 31, 2025, 6:00 PM

  const PracticeLuxuryPromotionData._({
    required this.tierLevel,
    required this.productDescriptions,
    required this.spendingThreshold,
    required this.selectableItems,
    required this.imageUrl,
  });

  static List<PracticeLuxuryPromotionData> list = [
    PracticeLuxuryPromotionData._(
      tierLevel: 6,
      productDescriptions: 'Corganics Clinical CBD Cream & Drops',
      spendingThreshold: 1000000, // $10,000
      selectableItems: _tier6Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img5.png',
    ),
    PracticeLuxuryPromotionData._(
      tierLevel: 5,
      productDescriptions: 'AirPods 4th Generation',
      spendingThreshold: 1500000, // $15,000
      selectableItems: _tier5Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img6.png',
    ),
    PracticeLuxuryPromotionData._(
      tierLevel: 4,
      productDescriptions: 'Designer Card Cases & Bags',
      spendingThreshold: 2000000, // $20,000
      selectableItems: _tier4Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img7.png',
    ),
    PracticeLuxuryPromotionData._(
      tierLevel: 3,
      productDescriptions: 'Designer Card Cases & Bags',
      spendingThreshold: 2500000, // $25,000
      selectableItems: _tier3Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img8.png',
    ),
    PracticeLuxuryPromotionData._(
      tierLevel: 2,
      productDescriptions: 'Hermes, Burberry, YSL',
      spendingThreshold: 3000000, // $30,000
      selectableItems: _tier2Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img9.png',
    ),
    PracticeLuxuryPromotionData._(
      tierLevel: 1,
      productDescriptions: 'Hermes, Bottega Veneta, YSL',
      spendingThreshold: 4000000, // $40,000
      selectableItems: _tier1Items,
      imageUrl:
      '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img10.png',
    ),
  ];
}

const _tier6Items = <String>['Corganics Clinical CBD Cream & Drops'];
const _tier5Items = <String>['AirPods 4th Generation'];
const _tier4Items = <String>[
  "Burberry Classic Cotton & Leather Card Case",
  "Givenchy Giv Cut Card Holder In 4G Lurex Embroidery And Leather",
  "FERRAGAMO Gancini Leather Card Case",
  "Dagne Dover Dakota Large Air Mesh Backpack",
  "MZ Wallace Metro Quilted Nylon Backpack Deluxe",
  "Maison de Sabre Leather Sling Bag",
  "MICHAEL Michael Kors Ruthie Small Leather Satchel",
  "Jacquemus Le Chouchou Le Porte Bambino Leather Wristlet",
  "kate spade new york Large Bleecker Saffiano Leather Tote Bag",
  "Naghedi St. Barths Mini Graphic",
  "Naghedi St. Barths Mini Tote",
  "Hermès Tressages Equestres",
];
const _tier3Items = <String>[
  "Givenchy Voyou Card Holder in Crocodile Effect Leather",
  "Bottega Veneta Intrecciato Leather & Denim Card Case",
  "Saint Laurent Cassandre Matelasse Card Case in Grain De Poudre Embossed Leather",
  "Valentino Garavani Vlogo Signature Grainy Calfskin Cardholder",
  "Tory Burch Large Ella Crochet Tote Bag",
  "Dragon Diffusion Santa Croce Leather Tote Bag",
  "Tory Burch Perry Leather Tote",
  "Alexander Wang Ryan Large Bag",
  "Rebecca Minkoff Medium Edie Leather Tote Bag",
];

const _tier2Items = <String>[
  "Harper Emile Hermès Bucket Hat",
  "Burberry Bucket Hat",
  "Burberry Baseball Cap",
  "Hermès Les Folies du Faubourg Scarf 90",
  "Burberry Classic Cashmere Scarf",
  "YSL Monogram Large Bill Pouch in Grained Leather",
];

const _tier1Items = <String>[
  'Hermès Oran sandal',
  'Hermès Clic H bracelet',
  'Hermès Casaque Tete a Queue muffler',
  'Hermès Game slip-on sneaker',
  'Hermès Paris loafer',
  'Hermès Bouncing sneaker',
  'Hermès Saut Hermès set of 3 mugs',
  'Avalon pillow, large model',
  'Cassandre Envelope Chain Wallet In Grain De Poudre Leather',
  'Bottega Veneta Torino Chelsea Boots',
  'Saint Laurent Maddie Square Toe Boots',
];