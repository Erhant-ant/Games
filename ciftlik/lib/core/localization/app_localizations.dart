import 'package:flutter/widgets.dart';

class AppLocalizations extends InheritedWidget {
  const AppLocalizations({super.key, required this.locale, required super.child});

  static const supportedLocales = [Locale('tr'), Locale('en')];
  final Locale locale;

  bool get isTurkish => locale.languageCode == 'tr';

  String text(String key) => (_translations[locale.languageCode] ?? _translations['tr']!)[key] ?? key;

  static AppLocalizations of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocalizations>()!;
  }

  @override
  bool updateShouldNotify(AppLocalizations oldWidget) => oldWidget.locale != locale;
}

const _translations = <String, Map<String, String>>{
  'tr': {
    'freeShipping': '2500 ₺ ve üzeri siparişlerde kargo bedava',
    'promoMessage': 'Mutfağımızın doğal lezzetlerini hemen keşfedin', 'blog': 'Çiftlik Günlüğü', 'whatsappOrder': 'WhatsApp Sipariş',
    'headerPromise': 'Zahide Hanım’dan ev yapımı lezzetler', 'aboutUs': 'Hakkımızda', 'orderTracking': 'Sipariş Takip',
    'searchHint': 'Ürün, kategori veya lezzet ara', 'account': 'Hesabım',
    'navHome': 'Ana Sayfa', 'navJam': 'Reçel Çeşitleri', 'navMolasses': 'Pekmez Çeşitleri', 'navSauces': 'Salça ve Soslar', 'navSpices': 'Baharatlar',
    'navSiirtYoresel': 'Siirt Yöresel', 'navCampaigns': 'Kampanyalar', 'navStory': 'Hikâyemizi Keşfedin', 'navContact': 'İletişim',
    'megaMenuSubtitle': 'Zahide Hanım’ın mutfağından',
    'products': 'Ürünler', 'story': 'Hikâyemiz', 'journal': 'Çiftlik Günlüğü', 'contact': 'İletişim',
    'heroEyebrow': 'TOPRAĞIN BEREKETİ', 'heroTitle': 'Her kavanozda\nemeğimiz var.',
    'heroBody': 'Zahide Hanım’ın mevsiminde, sevgiyle hazırladığı doğal lezzetler sofranızda.', 'discover': 'Lezzetleri keşfet  →',
    'trustSeasonal': 'Mevsiminde üretim', 'trustNatural': 'Katkısız & doğal', 'trustPacked': 'Özenle paketlenir', 'trustDelivery': 'Türkiye’nin her yerine',
    'categoryEyebrow': 'Çiftliğimizden sofranıza', 'categoryTitle': 'Mevsimin en güzel halleri',
    'productEyebrow': 'Zahide Hanım öneriyor', 'productTitle': 'Bu haftanın favorileri', 'allProducts': 'Tüm ürünleri gör →',
    'handmade': 'El emeği',
    'storyEyebrow': 'BİZİM HİKÂYEMİZ', 'storyTitle': 'Bir annenin emeği, bir çiftliğin bereketi.',
    'storyBody': 'Zahide Hanım Çiftliği’nde her ürün, toprağa duyduğumuz saygıyla ve yılların birikimiyle hazırlanır. Çünkü iyi yemek, iyi malzemeyle başlar.', 'readStory': 'Hikâyemizi okuyun',
    'benefitEyebrow': 'Neden Zahide Hanım Çiftliği?', 'benefitTitle': 'İçiniz rahat, sofranız bereketli',
    'benefitNaturalTitle': 'Doğal içerik', 'benefitNaturalBody': 'Ne koyduğumuzu bilir, etikette açıkça yazarız.',
    'benefitCareTitle': 'Zahide Hanım’ın eli', 'benefitCareBody': 'Her tarif, ev mutfağından gelen özenle hazırlanır.',
    'benefitTrustTitle': 'Güvenilir üretim', 'benefitTrustBody': 'Üründen pakete kadar titiz bir süreç izleriz.',
    'newsletterEyebrow': 'ÇİFTLİKTEN HABERLER', 'newsletterTitle': 'Mevsimin lezzetlerini kaçırmayın.',
    'newsletterBody': 'Yeni ürünler, mutfaktan tarifler ve size özel fırsatlar için e-posta listemize katılın.', 'email': 'E-posta adresiniz', 'subscribe': 'Katıl',
    'tagline': 'Doğadan kavanoza, Zahide Hanım’ın emeğiyle.', 'faq': 'Sıkça Sorulanlar', 'copyright': '© 2026 Zahide Hanım Çiftliği',
    'all': 'Tümü', 'filterProducts': 'Ürünleri filtrele', 'cart': 'Sepetim', 'emptyCart': 'Sepetiniz henüz boş.',
    'emptyCartDetail': 'Sevdiğiniz doğal lezzetleri ekleyerek alışverişe başlayın.', 'continueShopping': 'Alışverişe devam et',
    'subtotal': 'Ara toplam', 'shippingAtCheckout': 'Kargo, ödeme adımında hesaplanır.', 'checkout': 'Ödemeye geç',
    'addToCart': 'Sepete ekle', 'added': 'Eklendi!', 'ingredients': 'İçindekiler', 'deliveryInfo': 'Kargo bilgisi',
    'productDetailBody': 'Zahide Hanım’ın mutfağında mevsiminde seçilen malzemelerle, küçük partiler halinde hazırlanır.',
    'productIngredients': 'Mevsiminde seçilmiş doğal malzemeler. Katkı ve koruyucu içermez.',
    'productShipping': 'Siparişleriniz özenle paketlenir ve 1-3 iş günü içinde kargoya verilir.',
    'checkoutTitle': 'Teslimat ve ödeme', 'checkoutSubtitle': 'Siparişinizi birkaç adımda tamamlayın.',
    'contactInfo': 'İletişim bilgileri', 'fullName': 'Ad soyad', 'phone': 'Telefon numarası',
    'deliveryAddress': 'Teslimat adresi', 'address': 'Açık adres', 'city': 'İl', 'district': 'İlçe',
    'paymentMethod': 'Ödeme yöntemi', 'cardPayment': 'Kredi / banka kartı', 'cashOnDelivery': 'Kapıda ödeme',
    'bankTransfer': 'Havale / EFT', 'orderSummary': 'Sipariş özeti', 'placeOrder': 'Siparişi tamamla',
    'securePayment': 'Güvenli ödeme altyapısı ile korunur.', 'formRequired': 'Lütfen zorunlu alanları doldurun.',
    'orderReceived': 'Sipariş talebiniz alındı', 'orderReceivedBody': 'Ödeme ve sipariş onayı için sizinle iletişime geçeceğiz.',
    'searchResultsFor': '"{query}" için arama sonuçları', 'noResults': 'Maalesef aradığınız kriterlere uygun ürün bulamadık.',
    'footerCorporate': 'KURUMSAL', 'footerCategories': 'KATEGORİLER', 'footerAccount': 'HESABIM',
    'footerCorpZahide': 'Zahide Hanım', 'footerCorpSocial': 'Sosyal Sorumluluk Projeleri', 'footerCorpFaq': 'Sıkça Sorulan Sorular', 'footerCorpPrivacy': 'Gizlilik ve KVKK Politikası', 'footerCorpDistance': 'Mesafeli Satış Sözleşmesi', 'footerCorpContact': 'İletişim',
    'footerCatOliveOil': 'Zeytinyağları', 'footerCatOlives': 'Doğal Zeytinler', 'footerCatSoap': 'Sabun ve Kozmetikler', 'footerCatSpecial': 'Özel Lezzetler', 'footerCatGifts': 'Kurumsal Hediyeler', 'footerCatCampaigns': 'Kampanya ve Fırsatlar',
    'footerAccMembership': 'Üyelik İşlemleri', 'footerAccOrders': 'Siparişlerim', 'footerAccTracking': 'Kargom Nerede', 'footerAccFavorites': 'Favori Ürünlerim', 'footerAccGuide': 'İşlem Rehberi', 'footerAccPassword': 'Şifre Yenileme',
    'footerNewsTitle': 'Kampanya ve indirimlerden ilk siz haberdar olun', 'footerNewsPlaceholder': 'E-posta', 'footerNewsSubmit': 'Gönder',
    'footerAddress': 'Zahide Hanım Çiftliği:\nSiirt Şirvan Madenköy No:242',
    'footerCopyrightDetails': 'Tüm Hakları Saklıdır | Zahide Hanım Çiftliği\nSİTEMİZDE 256 BIT SSL SERTİFİKASI İLE GÜVENLİ ALIŞVERİŞ YAPABİLİRSİNİZ',
  },
  'en': {
    'freeShipping': 'Free shipping on orders over ₺3000',
    'promoMessage': 'Discover the natural flavours from our kitchen', 'blog': 'Farm Journal', 'whatsappOrder': 'Order via WhatsApp',
    'headerPromise': 'Homemade flavours by Zahide Hanım', 'aboutUs': 'About us', 'orderTracking': 'Track order',
    'searchHint': 'Search products, categories or flavours', 'account': 'My account',
    'navHome': 'Home', 'navJam': 'Jams', 'navMolasses': 'Molasses', 'navSauces': 'Pastes & Sauces', 'navSpices': 'Spices',
    'navSiirtYoresel': 'Siirt Regional', 'navCampaigns': 'Campaigns', 'navStory': 'Discover Our Story', 'navContact': 'Contact',
    'megaMenuSubtitle': 'From Zahide Hanım’s kitchen',
    'products': 'Products', 'story': 'Our Story', 'journal': 'Farm Journal', 'contact': 'Contact',
    'heroEyebrow': 'THE BOUNTY OF THE LAND', 'heroTitle': 'A little care\nin every jar.',
    'heroBody': 'Natural flavours lovingly prepared by Zahide Hanım, at the peak of the season.', 'discover': 'Discover our flavours  →',
    'trustSeasonal': 'Seasonal production', 'trustNatural': 'Natural & additive-free', 'trustPacked': 'Carefully packed', 'trustDelivery': 'Delivery across Türkiye',
    'categoryEyebrow': 'From our farm to your table', 'categoryTitle': 'The finest flavours of the season',
    'productEyebrow': 'Zahide Hanım recommends', 'productTitle': 'This week’s favourites', 'allProducts': 'View all products →',
    'handmade': 'Handmade',
    'storyEyebrow': 'OUR STORY', 'storyTitle': 'A mother’s care, a farm’s abundance.',
    'storyBody': 'At Zahide Hanım Çiftliği, every product is made with respect for the land and the wisdom of years. Because great food starts with great ingredients.', 'readStory': 'Read our story',
    'benefitEyebrow': 'Why Zahide Hanım Çiftliği?', 'benefitTitle': 'Good for your table, easy on your mind',
    'benefitNaturalTitle': 'Natural ingredients', 'benefitNaturalBody': 'We know every ingredient and clearly state it on the label.',
    'benefitCareTitle': 'Zahide Hanım’s touch', 'benefitCareBody': 'Every recipe is made with the care of a home kitchen.',
    'benefitTrustTitle': 'Trusted production', 'benefitTrustBody': 'We follow a careful process from product to parcel.',
    'newsletterEyebrow': 'NEWS FROM THE FARM', 'newsletterTitle': 'Don’t miss the flavours of the season.',
    'newsletterBody': 'Join our mailing list for new products, recipes from our kitchen and special offers.', 'email': 'Your email address', 'subscribe': 'Subscribe',
    'tagline': 'From the land to the jar, made with Zahide Hanım’s care.', 'faq': 'Frequently Asked Questions', 'copyright': '© 2026 Zahide Hanım Çiftliği',
    'all': 'All', 'filterProducts': 'Filter products', 'cart': 'My cart', 'emptyCart': 'Your cart is empty.',
    'emptyCartDetail': 'Add your favourite natural flavours to begin shopping.', 'continueShopping': 'Continue shopping',
    'subtotal': 'Subtotal', 'shippingAtCheckout': 'Shipping is calculated at checkout.', 'checkout': 'Proceed to checkout',
    'addToCart': 'Add to cart', 'added': 'Added!', 'ingredients': 'Ingredients', 'deliveryInfo': 'Delivery information',
    'productDetailBody': 'Prepared in Zahide Hanım’s kitchen in small batches, with ingredients selected at their seasonal best.',
    'productIngredients': 'Naturally selected seasonal ingredients. No additives or preservatives.',
    'productShipping': 'Your order is carefully packed and dispatched within 1–3 business days.',
    'checkoutTitle': 'Delivery & payment', 'checkoutSubtitle': 'Complete your order in a few simple steps.',
    'contactInfo': 'Contact information', 'fullName': 'Full name', 'phone': 'Phone number',
    'deliveryAddress': 'Delivery address', 'address': 'Full address', 'city': 'City', 'district': 'District',
    'paymentMethod': 'Payment method', 'cardPayment': 'Credit / debit card', 'cashOnDelivery': 'Cash on delivery',
    'bankTransfer': 'Bank transfer', 'orderSummary': 'Order summary', 'placeOrder': 'Complete order',
    'securePayment': 'Protected by secure payment infrastructure.', 'formRequired': 'Please fill in the required fields.',
    'orderReceived': 'Your order request was received', 'orderReceivedBody': 'We will contact you to confirm your payment and order.',
    'searchResultsFor': 'Search results for "{query}"', 'noResults': 'Unfortunately, we could not find any products matching your criteria.',
    'footerCorporate': 'CORPORATE', 'footerCategories': 'CATEGORIES', 'footerAccount': 'MY ACCOUNT',
    'footerCorpZahide': 'Zahide Hanım', 'footerCorpSocial': 'Social Responsibility', 'footerCorpFaq': 'Frequently Asked Questions', 'footerCorpPrivacy': 'Privacy Policy', 'footerCorpDistance': 'Distance Selling Contract', 'footerCorpContact': 'Contact',
    'footerCatOliveOil': 'Olive Oils', 'footerCatOlives': 'Natural Olives', 'footerCatSoap': 'Soaps & Cosmetics', 'footerCatSpecial': 'Special Flavors', 'footerCatGifts': 'Corporate Gifts', 'footerCatCampaigns': 'Campaigns & Offers',
    'footerAccMembership': 'Membership', 'footerAccOrders': 'My Orders', 'footerAccTracking': 'Track My Order', 'footerAccFavorites': 'My Favorites', 'footerAccGuide': 'User Guide', 'footerAccPassword': 'Reset Password',
    'footerNewsTitle': 'Be the first to know about campaigns and discounts', 'footerNewsPlaceholder': 'Email', 'footerNewsSubmit': 'Send',
    'footerAddress': 'Zahide Hanım Farm:\nSiirt Sirvan Madenkoy No:242',
    'footerCopyrightDetails': 'All Rights Reserved | Zahide Hanım Farm\nSECURE SHOPPING WITH 256 BIT SSL CERTIFICATE ON OUR SITE',
  },
};
