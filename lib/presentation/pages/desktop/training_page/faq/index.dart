import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';

import 'package:flutter/material.dart';
import 'package:YLift/core/constants/color.dart';

class FAQData {
  final String question;
  final String answer;
  final bool isExpanded;

  const FAQData({
    required this.question,
    required this.answer,
    required this.isExpanded,
  });

  FAQData copyWith({bool? isExpanded}) {
    return FAQData(question: question, answer: answer, isExpanded: isExpanded ?? this.isExpanded);
  }

  static const faqs = <FAQData>[
    FAQData(
      question: 'How does the hands-on training work?',
      answer:
          'After successfully registering for one of our training courses (Y LIFT, SurgYlift, or MagnYm), you can choose to train at our location or have one of our experts come to your practice. Each training spans two days with 3-5 live patients to help you master our techniques. Once registered, you\'ll also gain access to all network benefits.',
      isExpanded: false,
    ),
    FAQData(
      question: 'What are the network benefits I\'ll receive after registering for the trainings?',
      answer: '• Top-tier pricing on dermal fillers, neurotoxins, threads, and more.\n'
          '• Patient leads sent to you through our finder\'s map.\n'
          '• Use of all Y LIFT MEDIA KIT promotional materials.\n'
          '• Access to the ASK Y platform for education and networking.\n'
          '• Have questions after your session? We\'re always here for you.\n',
      isExpanded: false,
    ),
    FAQData(
      question: 'How can I gain access to Galderma products?',
      answer:
          'Once you complete registration for one of our training courses, all products in the store will unlock, granting you top-tier pricing. This process may take a few hours. If the products don\'t appear in your account, please contact our support team.',
      isExpanded: false,
    ),
    FAQData(
      question: 'Where do the trainings take place?',
      answer:
          'Our training centers are located in Oxnard, California, and New York City, New York. Alternatively, we can travel to your practice at your convenience, with no additional charges.\n'
          'Note: Virtual training is available for MagnYm courses.',
      isExpanded: false,
    ),
    FAQData(
      question: 'How do I recruit patients for the training?',
      answer:
          'You can announce the new procedure to your existing patient database. We\'ll provide you with Y LIFT media kits for marketing. We recommend offering discounted pricing for patients during the training. If you need help determining pricing or recruiting patients, contact our support team for guidance.',
      isExpanded: false,
    ),
    FAQData(
      question: 'What is the cost of the trainings?',
      answer:
          'The cost varies depending on the specific training course. You can view the pricing on each individual training page. There is also a \$2,400 annual fee for maintaining your membership.\n'
          'Many of our providers offset their initial training costs by performing procedures on the 3-5 live patients included in the training. They also save significantly on top-tier product purchases in the store over time.',
      isExpanded: false,
    ),
    FAQData(
      question: 'Where can I find more details about the trainings?',
      answer:
          'You can find all our training options at the top of this page. Simply click on the training you\'re interested in to view more details or register. If you have any questions about individual procedures, feel free to contact our office or visit ylift.com for more information.',
      isExpanded: false,
    ),
  ];
}

class FrequentlyAskedQuestionsSection extends StatefulWidget {
  const FrequentlyAskedQuestionsSection({super.key});

  @override
  State<FrequentlyAskedQuestionsSection> createState() => _FrequentlyAskedQuestionsSectionState();
}

class _FrequentlyAskedQuestionsSectionState extends State<FrequentlyAskedQuestionsSection> {
  final faqs = FAQData.faqs.toList();

  static const _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: YLiftConstant.pageWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Frequently Asked Questions', style: YLiftTextStyle.title),
          const GapY(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 520,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(blurRadius: 8, color: Colors.black12),
                    ],
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        faqs[panelIndex] = faqs[panelIndex].copyWith(isExpanded: isExpanded);
                      });
                    },
                    children: List.generate(
                      faqs.length,
                      (index) {
                        final faq = faqs[index];
                        return ExpansionPanel(
                          backgroundColor: Colors.white,
                          canTapOnHeader: true,
                          headerBuilder: (context, isExpanded) => Container(
                            height: 64,
                            padding: const EdgeInsets.only(top: 22, left: 16),
                            child: Text(faq.question),
                          ),
                          body: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(faq.answer),
                            ),
                          ),
                          isExpanded: faq.isExpanded,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 64),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8, color: Colors.black12)],
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                    minHeight: 520,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        _imageRepository.getImageUrl('4a42abae-97c0-4fb7-ab09-848f5c88f5f9'),
                      ),
                      const GapY(),
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          'Need Customer Support? Y LIFT team is here for you!',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          'Our office hours are from 9:00 a.m. to 6.00 p.m. EST',
                          style: TextStyle(fontSize: 13.33, color: Colors.grey),
                        ),
                      ),
                      const GapY(),
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: YLiftColor.orange,
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text('+1 (212) 861-7787'),
                            GapX(),
                            CircleAvatar(
                              backgroundColor: YLiftColor.orange,
                              child: Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text('info@ylift.com'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
