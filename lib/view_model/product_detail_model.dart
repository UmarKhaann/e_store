import 'package:url_launcher/url_launcher.dart';

class ProductDetailModel {
  static void launchTextMessage({phone}) async {
    final Uri url = Uri(
      scheme: 'sms',
      path: phone,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('error: 101');
    }
  }

  static void launchCall({phone}) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('error: 101');
    }
  }

  static void launchWhatsApp({phone}) async {
    if (await canLaunchUrl(Uri.parse('https://wa.me/923119273282'))) {
      await launchUrl(Uri.parse('https://wa.me/923119273282'));
    } else {
      print('error: 101');
    }
  }
}
