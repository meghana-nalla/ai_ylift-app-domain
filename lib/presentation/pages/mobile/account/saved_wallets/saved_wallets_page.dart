import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:YLift/presentation/components/dialogs/remove_card_payment_dialog.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_add_new_card_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileSavedWalletsPage extends StatefulWidget {
  const MobileSavedWalletsPage({super.key});

  @override
  State<MobileSavedWalletsPage> createState() => _MobileSavedWalletsPageState();
}

class _MobileSavedWalletsPageState extends State<MobileSavedWalletsPage> {
  final global = Get.find<GlobalController>();
  bool isLoading = false;
  String? errorMessage;

  final cards = <CardPayment>[];

  void fetchUserWallet() async {
    try {
      setState(() {
        isLoading = true;
      });

      final cachedCards = global.user.value.wallet ?? <CardPayment>[];

      setState(() {
        cards.clear();
        cards.addAll(cachedCards);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong while retrieving your saved wallets. Please try again later.',
          ),
        ),
      );
      debugPrint('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addNewCard() async {
    await Navigator.push<CardPayment>(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAddNewCardPage(),
      ),
    );

    setState(() {
      final wallet = global.user.value.wallet;
      if (wallet != null) {
        cards.clear();
        cards.addAll(wallet);
      }
    });
  }

  void setAsDefault(CardPayment card) async {
    try {
      await global.userController.setDefaultCardPayment(card.id);
      fetchUserWallet();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to set ${card.cardType} ****${card.last4} as default. Please try again later',
          ),
        ),
      );
    }
  }

  void removeCard(CardPayment card) async {
    try {
      final isDeleted = await showDialog<bool>(
        context: context,
        builder: (context) => RemoveCardPaymentDialog(card: card),
      );
      if (isDeleted ?? false) fetchUserWallet();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to remove ${card.cardType} ****${card.last4}. Please try again later',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    fetchUserWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Saved Wallets',
      onBackPressed: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineTextButton(
                  onPressed: addNewCard,
                  text: 'Add a new card',
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap on a card to set it as default',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final card = cards[index];

                return _CardPaymentTile(
                  card: card,
                  isDefault: card.isDefault,
                  onSelected: () => setAsDefault(card),
                  onRemove: () => removeCard(card),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPaymentTile extends StatelessWidget {
  final CardPayment card;
  final bool isDefault;
  final void Function() onSelected;
  final void Function()? onRemove;

  const _CardPaymentTile({
    super.key,
    required this.card,
    required this.onSelected,
    this.isDefault = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isExpired ? null : onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: card.isExpired ? Colors.grey.shade300 : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            PaymentMarkIcon(card.cardType),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.cardType} ending with ${card.last4}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (card.expirationDate != null)
                      Text(
                        'Expires on ${card.expirationDate!.month}/${card.expirationDate!.year}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle,
                        size: 4,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Default',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const Spacer(),
            if (!isDefault)
              MobileIcon(
                onPressed: onRemove,
                icon: Icons.delete_outline_rounded,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}
