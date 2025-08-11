import 'package:flutter/material.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const TermsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      scrollable: true,
      title: Text('Terms of Use'),
      content: SizedBox(
        width: 800,
        child: Text(terms),
      ),
    );
  }
}

const terms = r'''
Terms of Use
Y LIFT Store, Inc.’s mission is to provide an education platform to aesthetic professionals in the latest advancements and techniques available in aesthetic medicine. We enable certified medical professionals to create and share educational courses (instructors) and to enroll in these educational courses to learn (students). We consider our marketplace model the best way to offer valuable educational content to our users. We need rules to keep our platform and services safe for you, us and our student and instructor community. These Terms apply to all your activities on the Y LIFT Store, Inc. website, the Y LIFT Store, Inc. mobile applications, our TV applications, our APIs and other related services (“Services”).

Subject to initial approval, if you publish a course on the Y LIFT Store, Inc. platform, you must also agree to the Instructor Agreement. We also provide details regarding our processing of personal data of our students and instructors in our Privacy Policy. If you are using Y LIFT Store, Inc. as part of your employer’s Y LIFT Store, Inc. For Business learning and development program (YFB), you can consult our YFB Privacy Statement.

If you live in the United States or Canada, by agreeing to these Terms, you agree to resolve disputes with Y LIFT Store, Inc. through binding arbitration (with very limited exceptions, not in court), and you waive certain rights to participate in class actions, as detailed in the Dispute Resolution section.

1. Accounts
You need an account for most activities on our platform. Keep your password somewhere safe, because you’re responsible for all activity associated with your account. If you suspect someone else is using your account, let us know by contacting us at info@yliftstore.com. You must have reached the age of consent for online services in your country to use Y LIFT Store, Inc..

You need an account for most activities on our platform, including to purchase and enroll in a course or to submit a course for publication. When setting up and maintaining your account, you must provide and continue to provide accurate and complete information, including a valid email address. You have complete responsibility for your account and everything that happens on your account, including for any harm or damage (to us or anyone else) caused by someone using your account without your permission. This means you need to be careful with your password. You may not transfer your account to someone else or use someone else’s account without their permission. If you contact us to request access to an account, we will not grant you such access unless you can provide us the login credential information for that account. In the event of the death of a user, the account of that user will be closed.

If you share your account login credential with someone else, you are responsible for what happens with your account and Y LIFT Store, Inc. will not intervene in disputes between students or instructors who have shared account login credentials. You must notify us immediately upon learning that someone else may be using your account without your permission (or if you suspect any other breach of security) by contacting us at info@yliftstore.com. We may request some information from you to confirm that you are indeed the owner of your account.

Students and instructors must be at least 18 years of age to create an account on Y LIFT Store, Inc. and use the Services. Under our Instructor Agreement, you will be requested to verify your identity before you are authorized to submit a course for publication on Y LIFT Store, Inc., subject to review and approval by Y LIFT Store, Inc.

You can terminate your account at any time by contacting us at info@yliftstore.com. Check our Privacy Policy to see what happens when you terminate your account.

2. Course Enrollment and Lifetime Access
When you enroll in a course, you get a license from us to view it via the Y LIFT Store, Inc. Services and no other use. Don’t try to transfer or resell courses in any way. We grant you a lifetime access license, except when we must disable the course because of legal or policy reasons.

Under our Instructor Agreement, when instructors publish a course on Y LIFT Store, Inc., they grant Y LIFT Store, Inc. a license to offer a license to the course to students. This means that we have the right to sublicense the course to the students who enroll in the course. As a student, when you enroll in a course, whether it’s a free or paid course, you are getting from Y LIFT Store, Inc. a license to view the course via the Y LIFT Store, Inc. platform and Services, and Y LIFT Store, Inc. is the licensor of record. Courses are licensed, and not sold, to you. This license does not give you any right to resell the course in any manner (including by sharing account information with a purchaser or illegally downloading the course and sharing it on torrent sites).

In legal, more complete terms, Y LIFT Store, Inc. grants you (as a student) a limited, non-exclusive, non-transferable license to access and view the courses and associated content for which you have paid all required fees, solely for your personal, non- commercial, educational purposes through the Services, in accordance with these Terms and any conditions or restrictions associated with a particular courses or feature of our Services. All other uses are expressly prohibited. You may not reproduce, redistribute, transmit, assign, sell, broadcast, rent, share, lend, modify, adapt, edit, create derivative works of, sublicense, or otherwise transfer or use any course unless we give you explicit permission to do so in a written agreement signed by a Y LIFT Store, Inc. authorized representative. This also applies to content you can access via any of our APIs.

We generally give a lifetime access license to our students when they enroll in a course. However, we reserve the right to revoke any license to access and use courses at any point in time in the event where we decide or are obligated to disable access to a course due to legal or policy reasons, for example, if the course you enrolled in is the object of a copyright complaint, or if we determine its content violates our Trust & Safety Guidelines. The lifetime access is not applicable to add-on features and services associated with a course, for example translation captions of courses may be disabled by instructors at any time, and an instructor may decide at any time to no longer provide teaching assistance or Q&A services in association with a course. To be clear, the lifetime access is to the course content but not to the instructor.

Instructors may not grant licenses to their courses to student directly and any such direct license shall be null and void and a violation of these Terms.

3. Payments, Credits, and Refunds
When you make a payment, you agree to use a valid payment method. All course sales are FINAL. No Refunds.

3.1 Pricing
The prices of courses on Y LIFT Store, Inc. are determined based on the terms of the Instructor Agreement and our Pricing and Promotions Policy. In some instances, the price of a course offered on the Y LIFT Store, Inc. website may not be exactly the same as the price offered on our mobile or TV applications, due to mobile platform providers’ pricing systems and their policies around implementing sales and promotions.

We regularly run promotions and sales for our courses and certain courses are only available at discounted prices for a set period of time. The price applicable to a course will be the price at the time you complete your purchase of the course (at checkout). Any price offered for a particular course may also be different when you are logged into your account from the price available to users who aren’t registered or logged in, because some of our promotions are available to new users only.

If you are logged into your account, the listed currency you see is based on your location when you created your account. If you are not logged into your account, the price currency is based on the country where you are located. We do not enable users to see pricing in other currencies.

If you are a student located in a country where use and sales tax, goods and services tax, or value added tax is applicable to consumer sales, we are responsible for collecting and remitting that tax to the proper tax authorities. In certain countries, the price you see may include such taxes.

3.2 Payments
You agree to pay the fees for courses that you purchase, and you authorize us to charge your debit or credit card or process other means of payment (such as Boleto, SEPA, direct debit, or mobile wallet) for those fees. Y LIFT Store, Inc. works with third party payment processing partners to offer you the most convenient payment methods in your country and to keep your payment information secure. Check out our Privacy Policy for more details.

When you make a purchase, you agree not to use an invalid or unauthorized payment method. If your payment method fails and you still get access to the course you are enrolling in, you agree to pay us the corresponding fees within thirty (30) days of notification from us. We reserve the right to disable access to any course for which we have not received adequate payments.

In some cases, we may issue credits to your account. These credits will be automatically applied towards your next course purchase on our website, but can’t be used for purchases in our mobile or TV applications. Credits may expire if not used within the specified period, and have no cash value.

4. Content and Behavior Rules
You can only use Y LIFT Store, Inc. for lawful purposes. You’re responsible for all the content that you post on our platform. You should keep the reviews, questions, posts, courses and other content you upload in line with our Trust & Safety Guidelines and the law, and respect the intellectual property rights of others. We can ban your account for repeated or major offenses. If you think someone is infringing your copyright on our platform, let us know.

You may not access or use the Services or create an account for unlawful purposes. Your use of the Services and behavior on our platform must comply with applicable local or national laws or regulations of your country. You are solely responsible for the knowledge of and compliance with such laws and regulations that are applicable to you. You may not access our Services if you are from a territory where U.S. businesses are prohibited from engaging in business (such as Cuba, Iran, North Korea, Sudan, or Syria) or if you have been designated a Specially Designated National, Denied Person, or Denied Entity by the U.S. government.

If you are a student, the Services enable you to ask questions to the instructors of courses you are enrolled in, and to post reviews of courses. For certain courses, the instructor invites you to submit content as “homework” or tests. Don’t post or submit anything that is not yours.

If you are an instructor, you can submit courses for publication on the platform and you can also communicate with the students who have enrolled in your courses. In both cases, you must abide by the law and respect the rights of others: you cannot post any course, question, answer, review or other content that violates applicable local or national laws or regulations of your country. You are solely responsible for any courses, content, and actions you post or take via the platform and Services and their consequences. Make sure you understand all the copyright restrictions set forth in the Instructor Agreement before you submit any course for publication on Y LIFT Store, Inc..

If we are put on notice that your course or content violates the law or the rights of others (for example, if it is established that it violates intellectual property or image rights of others, or is about an illegal activity), if we discover that your content or behavior violates our Trust & Safety Guidelines, or if we believe your content or behavior is unlawful, inappropriate, or objectionable (for example if you impersonate someone else), we may remove your content from our platform. Y LIFT Store, Inc. complies with copyright laws. Check out our Intellectual Property Policy for more details.

Y LIFT Store, Inc. has discretion in enforcing these Terms and our Trust & Safety Guidelines. We may terminate or suspend your permission to use our platform and Services or ban your account at any time, with or without notice, for any violation of these Terms, if you fail to pay any fees when due, upon the request of law enforcement or government agencies, for extended periods of inactivity, for unexpected technical issues or problems, or if we suspect that you engage in fraudulent or illegal activities. Upon any such termination we may delete your account and content, and we may prevent you from further access to the platforms and use of our Services. Your content may still be available on the platforms even if your account is terminated or suspended. You agree that we will have no liability to you or any third party for termination of your account, removal of your content, or blocking of your access to our platforms and services.

If one of our instructors has published a course that infringes your copyright or trademark rights, please let us know. Under our Instructor Agreement, we require our instructors to follow the law and respect the intellectual property rights of others. For more details on how to file a copyright or trademark infringement claim with us, see our Intellectual Property Policy.

5. Y LIFT Store, Inc.’s Rights to Content You Post
You retain ownership of content you post to our platform, including your courses. We’re allowed to share your content to anyone through any media, including promoting it via advertising on other websites.

The content you post as a student or instructor (including courses) remains yours. By posting courses and other content, you allow Y LIFT Store, Inc. to reuse and share it but you do not lose any ownership rights you may have over your content. If you are an instructor, be sure to understand the course licensing terms that are detailed in the Instructor Agreement.

When you post comments, questions, reviews, and when you submit to us ideas and suggestions for new features or improvements, you authorize Y LIFT Store, Inc. to use and share this content with anyone, distribute it and promote it on any platform and in any media, and to make modifications or edits to it as we see fit. In legal language, by submitting or posting content on or through the platforms, you grant us a worldwide, non-exclusive, royalty-free license (with the right to sublicense) to use, copy, reproduce, process, adapt, modify, publish, transmit, display, and distribute your content in any and all media or distribution methods (existing now or later developed). This includes making your content available to other companies, organizations, or individuals who partner with Y LIFT Store, Inc. for the syndication, broadcast, distribution, or publication of content on other media. You represent and warrant that you have all the rights, power, and authority necessary to authorize us to use any content that you submit. You also agree to all such uses of your content with no compensation paid to you.

6. Using Y LIFT Store, Inc. at Your Own Risk
Anyone can use Y LIFT Store, Inc. and we enable instructors and students to interact for teaching and learning. Like other platforms where people can post content and interact, some things can go wrong, and you use Y LIFT Store, Inc. at your own risk.

Y LIFT Store, Inc. enables medical professionals anywhere to create and share educational courses. We host many courses on our online learning marketplace. Our platform model means we do not review or edit the courses for legal issues, and we are not in a position to determine the legality of course content. We do not exercise any editorial control over the courses that are available on the platform and, as such, do not guarantee in any manner the reliability, validity, accuracy or truthfulness of the courses. If you enroll a course, you rely on any information provided by an instructor at your own risk.

By using the Services, you may be exposed to content that you consider offensive, indecent, or objectionable. Y LIFT Store, Inc. has no responsibility to keep such content from you and no liability for your access or enrollment in any course, to the extent permissible under applicable law. This also applies to any courses relating to health, wellness and physical exercise. You acknowledge the inherent risks and dangers in the strenuous nature of these types of courses, and by enrolling in such courses, you choose to assume those risks voluntarily, including risk of illness, bodily injury, disability, or death. You assume full responsibility for the choices you make before, during and after your enrollment in a course.

When you interact directly with a student or an instructor, you must be careful about the types of personal information that you share. We do not control what students and instructors do with the information they obtain from other users on the platform. You should not share your email or other personal information about you for your safety.

We do not hire or employ instructors nor are we responsible or liable for any interactions involved between instructors and students. We are not liable for disputes, claims, losses, injuries, or damage of any kind that might arise out of or relate to the conduct of instructors or students.

When you use our Services, you will find links to other websites that we don’t own or control. We are not responsible for the content or any other aspect of these third-party sites, including their collection of information about you. You should also read their terms and conditions and privacy policies.

7. Y LIFT Store, Inc.’s Rights
We own the Y LIFT Store, Inc. platform and Services, including the website, present or future apps and services, and things like our logos, API, code, and content created by our employees. You can’t tamper with those or use them without authorization.

All right, title, and interest in and to the Y LIFT Store, Inc. platform and Services, including our website, our existing or future applications, our APIs, databases, and the content our employees or partners submit or provide through our Services (but excluding content provided by instructors and students) are and will remain the exclusive property of Y LIFT Store, Inc. and its licensors. Our platforms and services are protected by copyright, trademark, and other laws of both the United States and foreign countries. Nothing gives you a right to use the Y LIFT Store, Inc. name or any of the Y LIFT Store, Inc. trademarks, logos, domain names, and other distinctive brand features. Any feedback, comments, or suggestions you may provide regarding Y LIFT Store, Inc. or the Services is entirely voluntary and we will be free to use such feedback, comments, or suggestions as we see fit and without any obligation to you.

You may not do any of the following while accessing or using the Y LIFT Store, Inc. platform and Services:

access, tamper with, or use non-public areas of the platform, Y LIFT Store, Inc.’s computer systems, or the technical delivery systems of Y LIFT Store, Inc.’s service providers.
disable, interfere with, or try to circumvent any of the features of the platforms related to security or probe, scan, or test the vulnerability of any of our systems.
copy, modify, create a derivative work of, reverse engineer, reverse assemble, or otherwise attempt to discover any source code of or content on the Y LIFT Store, Inc. platform or Services.
access or search or attempt to access or search our platform by any means (automated or otherwise) other than through our currently available search functionalities that are provided via our website, mobile apps, or API (and only pursuant to those API terms and conditions). You may not scrape, spider, use a robot, or use other automated means of any kind to access the Services.
in any way use the Services to send altered, deceptive, or false source-identifying information (such as sending email communications falsely appearing as Y LIFT Store, Inc.); or interfere with, or disrupt, (or attempt to do so), the access of any user, host, or network, including, without limitation, sending a virus, overloading, flooding, spamming, or mail-bombing the platforms or services, or in any other manner interfering with or creating an undue burden on the Services.
8. Miscellaneous Legal Terms
These Terms are like any other contract, and they have boring but important legal terms that protect us from the countless things that could happen and that clarify the legal relationship between us and you.

8.1 Binding Agreement
You agree that by registering, accessing or using our Services, you are agreeing to enter into a legally binding contract with Y LIFT Store, Inc. If you do not agree to these Terms, do not register, access, or otherwise use any of our Services.

If you are an instructor accepting these Terms and using our Services on behalf of a company, organization, government, or other legal entity, you represent and warrant that you are authorized to do so.

Any version of these Term in a language other than English is provided for convenience and you understand and agree that the English language will control if there is any conflict.

These Terms (including any agreements and policies linked from these Terms) constitute the entire agreement between you and us (which include, if you are an instructor, the Instructor Agreement and the Pricing and Promotions Policy).

If any part of these Terms is found to be invalid or unenforceable by applicable law, then that provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and the remainder of these Terms will continue in effect.

Even if we are delayed in exercising our rights or fail to exercise a right in one case, it doesn’t mean we waive our rights under these Terms, and we may decide to enforce them in the future. If we decide to waive any of our rights in a particular instance, it doesn’t mean we waive our rights generally or in the future.

The following sections shall survive the expiration or termination of these Terms: Sections 2 (Course Enrollment and Lifetime Access), 5 (Y LIFT Store, Inc.’s Rights to Content You Post), 6 (Using Y LIFT Store, Inc. at Your Own Risk), 7 (Y LIFT Store, Inc.’s Rights), 8 (Miscellaneous Legal Terms), and 9 (Dispute Resolution).

8.2 Disclaimers
It may happen that our platform is down, either for planned maintenance or because something goes down with the site. It may happen that one of our instructors is making misleading statements in their course. It may also happen that we encounter security issues. These are just examples. You accept that you will not have any recourse against us in any of these types of cases where things don’t work out right. In legal, more complete language, the Services and their content are provided on an “as is” and “as available” basis. We (and our affiliates, suppliers, partners, and agents) make no representations or warranties about the suitability, reliability, availability, timeliness, security, lack of errors, or accuracy of the Services or their content, and expressly disclaim any warranties or conditions (express or implied), including implied warranties of merchantability, fitness for a particular purpose, title, and non-infringement. We (and our affiliates, suppliers, partners, and agents) make no warranty that you will obtain specific results from use of the Services. Your use of the Services (including any content) is entirely at your own risk. Some jurisdictions don’t allow the exclusion of implied warranties, so some of the above exclusions may not apply to you.

We may decide to cease making available certain features of the Services at any time and for any reason. Under no circumstances will Y LIFT Store, Inc. or its affiliates, suppliers, partners or agents be held liable for any damages due to such interruptions or lack of availability of such features.

We are not responsible for delay or failure of our performance of any of the Services caused by events beyond our reasonable control, like an act of war, hostility, or sabotage; natural disaster; electrical, internet, or telecommunication outage; or government restrictions.

8.3 Limitation of Liability
There are risks inherent into using our Services, for example, if you enroll in a health and wellness course like yoga, and you injure yourself. You fully accept these risks and you agree that you will have no recourse to seek damages against even if you suffer loss or damage from using our platform and Services. In legal, more complete language, to the extent permitted by law, we (and our group companies, suppliers, partners, and agents) will not be liable for any indirect, incidental, punitive, or consequential damages (including loss of data, revenue, profits, or business opportunities, or personal injury or death), whether arising in contract, warranty, tort, product liability, or otherwise, and even if we’ve been advised of the possibility of damages in advance. Our liability (and the liability of each of our group companies, suppliers, partners, and agents) to you or any third parties under any circumstance is limited to the greater of one hundred dollars ($100) or the amount you have paid us in the twelve (12) months before the event giving rise to your claims. Some jurisdictions don’t allow the exclusion or limitation of liability for consequential or incidental damages, so some of the above may not apply to you.

8.4 Indemnification
If you behave in a way that gets us in legal trouble, we may exercise legal recourse against you. You agree to indemnify, defend (if we so request), and hold harmless Y LIFT Store, Inc., our group companies, and their officers, directors, suppliers, partners, and agents from an against any third-party claims, demands, losses, damages, or expenses (including reasonable attorney fees) arising from (a) the content you post or submit, (b) your use of the Services (c) your violation of these Terms, or (d) your violation of any rights of a third party. Your indemnification obligation will survive the termination of these Terms and your use of the Services.

8.5 Governing Law and Jurisdiction
These Terms are governed by the laws of the State of New York, USA without reference to its choice or conflicts of law principles. Where the “Dispute Resolution” section below does not apply, you and we consent to the exclusive jurisdiction and venue of federal and state courts in New York, New York, USA.

8.6 Legal Actions and Notices
No action, regardless of form, arising out of or relating to this Agreement may be brought by either party more than one (1) year after the cause of action has accrued.

Any notice or other communication to be given hereunder will be in writing and given by registered or certified mail return receipt requested, or email (by us to the email associated with your account or by you to info@YLIFTStore.com).

8.7 Relationship Between Us
You and we agree that no joint venture, partnership, employment, contractor, or agency relationship exists between us.

8.8 No Assignment
You may not assign or transfer these Terms (or the rights and licenses granted under them). For example, if you registered an account as an employee of a company, your account cannot be transferred to another employee. We may assign these Terms (or the rights and licenses granted under them) to another company or person without restriction. Nothing in these Terms confers any right, benefit, or remedy on any third-party person or entity. You agree that your account is non-transferable and that all rights to your account and other rights under these Terms terminate upon your death.

9. Dispute Resolution
If there’s a dispute, our Support Team is happy to help resolve the issue. If that doesn’t work and you live in the United States or Canada, your options are to go to small claims court or bring a claim in binding arbitration; you may not bring that claim in another court or participate in a non-individual class action claim against us.

This Dispute Resolution section applies only if you live in the United States or Canada. Most disputes can be resolved, so before bringing a formal legal case, please first try contacting our Support Team at info@yliftstore.com

9.1 Small Claims
Either of us can bring a claim in small claims court in (a) New York, NY, (b) the county where you live, or (c) another place we both agree on, as long as it qualifies to be brought in that court.

9.2 Going to Arbitration
If we can’t resolve our dispute amicably, you and Y LIFT Store, Inc. agree to resolve any claims related to these Terms (or our other legal terms) through final and binding arbitration, regardless of the type of claim or legal theory. If one of us brings a claim in court that should be arbitrated and the other party refuses to arbitrate it, the other party can ask a court to force us both to go to arbitration (compel arbitration). Either of us can also ask a court to halt a court proceeding while an arbitration proceeding is ongoing.

9.3 The Arbitration Process
Any disputes that involve a claim of less than $10,000 USD must be resolved exclusively through binding non-appearance-based arbitration. A party electing arbitration must initiate proceedings by filing an arbitration demand with the American Arbitration Association (AAA). The arbitration proceedings shall be governed by the AAA Commercial Arbitration Rules, Consumer Due Process Protocol, and Supplementary Procedures for Resolution of Consumer-Related Disputes. You and we agree that the following rules will apply to the proceedings: (a) the arbitration will be conducted by telephone, online, or based solely on written submissions (at the choice of the party seeking relief); (b) the arbitration must not involve any personal appearance by the parties or witnesses (unless we and you agree otherwise); and (c) any judgment on the arbitrator’s rendered award may be entered in any court with competent jurisdiction. Disputes that involve a claim of more than $10,000 USD must be resolved per the AAA’s rules about whether the arbitration hearing has to be in-person.

9.4 No Class Actions

We both agree that we can each only bring claims against the other on an individual basis. This means: (a) neither of us can bring a claim as a plaintiff or class member in a class action, consolidated action, or representative action; (b) an arbitrator can’t combine multiple people’s claims into a single case (or preside over any consolidated, class, or representative action); and (c) an arbitrator’s decision or award in one person’s case can only impact that user, not other users, and can’t be used to decide other users’ disputes. If a court decides that this “No class actions” clause isn’t enforceable or valid, then this “Dispute Resolution” section will be null and void, but the rest of the Terms will still apply.

9.5 Changes
Notwithstanding the “Updating these Terms” section below, if Y LIFT Store, Inc. changes this "Dispute Resolution" section after the date you last indicated acceptance to these Terms, you may reject any such change by providing Y LIFT Store, Inc. written notice of such rejection by mail or hand delivery to: Y LIFT Store, Inc., Inc. Attn: Legal, 2 E 61 ST, STE 413, New York, NY 10065, or by email from the email address associated with your Account to: info@yliftstore.com, within 30 days of the date such change became effective, as indicated by the "last updated on" language above. To be effective, the notice must include your full name and clearly indicate your intent to reject changes to this "Dispute Resolution" section. By rejecting changes, you are agreeing that you will arbitrate any dispute between you and Y LIFT Store, Inc. in accordance with the provisions of this "Dispute Resolution" section as of the date you last indicated acceptance to these Terms.

10. Updating These Terms
From time to time, we may update these Terms to clarify our practices or to reflect new or different practices (such as when we add new features), and Y LIFT Store, Inc. reserves the right in its sole discretion to modify and/or make changes to these Terms at any time. If we make any material change, we will notify you using prominent means such as by email notice sent to the email address specified in your account or by posting a notice through our Services. Modifications will become effective on the day they are posted unless stated otherwise.

Your continued use of our Services after changes become effective shall mean that you accept those changes. Any revised Terms shall supersede all previous Terms.

11. How to Contact Us
The best way to get in touch with us is to contact our Support Team at info@yliftstore.com We’d love to hear your questions, concerns, and feedback about our Services.

Thanks for teaching and learning with us.
''';
