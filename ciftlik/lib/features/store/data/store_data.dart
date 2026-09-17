import '../../../core/models/store_models.dart';

abstract final class StoreData {
  static List<StoreCategory> categories(bool isTurkish) => [
    StoreCategory(id: 'jams-and-molasses', title: isTurkish ? 'Pekmez & Reçel' : 'Jams & Molasses', imageUrl: 'https://images.unsplash.com/photo-1599399651610-2da7a6d0cb54?auto=format&fit=crop&w=700&q=80'),
    StoreCategory(id: 'sauces', title: isTurkish ? 'Salça ve Soslar' : 'Pastes & Sauces', imageUrl: 'https://images.unsplash.com/photo-1591871937573-74dbba2b6f9c?auto=format&fit=crop&w=700&q=80'),
    StoreCategory(id: 'dried', title: isTurkish ? 'Kurutulmuş Ürünler' : 'Dried Products', imageUrl: 'https://images.unsplash.com/photo-1601633413994-068d874521bd?auto=format&fit=crop&w=700&q=80'),
    StoreCategory(id: 'siirt-yoresel', title: isTurkish ? 'Siirt Yöresel' : 'Siirt Regional', imageUrl: 'https://images.unsplash.com/photo-1587049352847-4d4b126a71dc?auto=format&fit=crop&w=700&q=80'),
    StoreCategory(id: 'campaigns', title: isTurkish ? 'Kampanyalar' : 'Campaigns', imageUrl: 'https://images.unsplash.com/photo-1607083206968-13611e3d76db?auto=format&fit=crop&w=700&q=80'),
  ];

  static List<StoreProduct> products(bool isTurkish) => [
    // Campaigns / Bundles
    StoreProduct(
      id: 'kis-hazirlik-paketi',
      name: isTurkish ? 'Kışa Hazırlık Paketi (Pekmez + Sumak)' : 'Winter Prep Bundle (Molasses + Sumac)',
      weight: '850 g + 100 g',
      price: '₺ 410',
      oldPrice: '₺ 460',
      categoryId: 'campaigns',
      imageUrl: 'https://images.unsplash.com/photo-1621293954908-907159247fc8?auto=format&fit=crop&w=600&q=80',
    ),
    StoreProduct(
      id: 'kahvalti-seti',
      name: isTurkish ? 'Bereketli Kahvaltı Seti (Bal + Reçel)' : 'Abundant Breakfast Set (Honey + Jam)',
      weight: '400 g + 400 g',
      price: '₺ 1250',
      oldPrice: '₺ 1430',
      categoryId: 'campaigns',
      imageUrl: 'https://images.unsplash.com/photo-1555940280-5a3610931215?auto=format&fit=crop&w=600&q=80',
    ),
    StoreProduct(id: 'ev-yapimi-domates-salcasi', name: isTurkish ? 'Ev Yapımı Domates Salçası' : 'Homemade Tomato Paste', weight: '650 g', price: '₺ 400', categoryId: 'sauces-tomato', imageUrl: 'https://images.unsplash.com/photo-1628773822503-930a7eaecf80?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'kahvaltilik-aci-sos', name: isTurkish ? 'Kahvaltılık Acı Sos' : 'Spicy Breakfast Sauce', weight: '380 g', price: '₺ 250', categoryId: 'sauces-other', imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'cilek-receli', name: isTurkish ? 'Çilek Reçeli' : 'Strawberry Jam', weight: '400 g', price: '₺ 280', categoryId: 'jams', imageUrl: 'https://images.unsplash.com/photo-1582295664951-5c1a30e7dfb4?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'uzum-pekmezi', name: isTurkish ? 'Üzüm Pekmezi' : 'Grape Molasses', weight: '400 g', price: '₺ 320', categoryId: 'molasses', imageUrl: 'https://images.unsplash.com/photo-1622484212850-eb596bc67f6c?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'koy-baharati', name: isTurkish ? 'Köy Baharatı' : 'Village Spice Blend', weight: '90 g', price: '₺ 150', categoryId: 'spices', imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80'),
    // Dried Fruits
    StoreProduct(id: 'elma-kurusu', name: isTurkish ? 'Elma Kurusu' : 'Dried Apple', weight: '200 g', price: '₺ 200', categoryId: 'dried-fruits', imageUrl: 'https://images.unsplash.com/photo-1528699633788-424224dc89b5?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'erik-kurusu', name: isTurkish ? 'Erik Kurusu' : 'Dried Plum', weight: '250 g', price: '₺ 220', categoryId: 'dried-fruits', imageUrl: 'https://images.unsplash.com/photo-1601633413994-068d874521bd?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'kayisi-kurusu', name: isTurkish ? 'Kayısı Kurusu' : 'Dried Apricot', weight: '300 g', price: '₺ 350', categoryId: 'dried-fruits', imageUrl: 'https://images.unsplash.com/photo-1596590209489-08d4b3df2438?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'kuru-uzum', name: isTurkish ? 'Kuru Üzüm' : 'Dried Raisins', weight: '400 g', price: '₺ 250', categoryId: 'dried-fruits', imageUrl: 'https://images.unsplash.com/photo-1600181515915-c2d1b8c049ee?auto=format&fit=crop&w=600&q=80'),
    // Dried Vegetables
    StoreProduct(id: 'domates-kurusu', name: isTurkish ? 'Domates Kurusu' : 'Dried Tomato', weight: '250 g', price: '₺ 280', categoryId: 'dried-vegetables', imageUrl: 'https://images.unsplash.com/photo-1582281170792-663806a64287?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'biber-kurusu', name: isTurkish ? 'Biber Kurusu' : 'Dried Pepper', weight: '150 g', price: '₺ 250', categoryId: 'dried-vegetables', imageUrl: 'https://images.unsplash.com/photo-1583274291772-23c21a1ec6f4?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'yesil-dolma-kurusu', name: isTurkish ? 'Yeşil Dolma Kurusu' : 'Dried Stuffed Pepper', weight: '200 g', price: '₺ 300', categoryId: 'dried-vegetables', imageUrl: 'https://images.unsplash.com/photo-1606760594248-085732c525f1?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'patlican-kurusu', name: isTurkish ? 'Patlıcan Kurusu' : 'Dried Eggplant', weight: '150 g', price: '₺ 280', categoryId: 'dried-vegetables', imageUrl: 'https://images.unsplash.com/photo-1588825700870-87422fcaab03?auto=format&fit=crop&w=600&q=80'),
    // Dried Other
    StoreProduct(id: 'reyhan-kurusu', name: isTurkish ? 'Kuru Reyhan' : 'Dried Basil', weight: '50 g', price: '₺ 120', categoryId: 'dried-other', imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'sumak', name: isTurkish ? 'Sumak' : 'Sumac', weight: '100 g', price: '₺ 140', categoryId: 'dried-other', imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80'),
    // Siirt Regional
    StoreProduct(id: 'asma-yapragi', name: isTurkish ? 'Siirt Yöresel Asma Yaprağı' : 'Siirt Regional Vine Leaves', weight: '500 g', price: '₺ 220', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1596450628292-12711dc756f7?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'tandir-ekmegi', name: isTurkish ? 'Siirt Yöresel Tandır Ekmeği' : 'Siirt Regional Tandoor Bread', weight: '5 Adet', price: '₺ 250', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'kaya-tuzu', name: isTurkish ? 'Siirt Yöresel Kaya Tuzu' : 'Siirt Regional Rock Salt', weight: '500 g', price: '₺ 120', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1518118014377-ce94fddbb762?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'pervari-bali-250g', name: isTurkish ? 'Orijinal Pervari Balı' : 'Pervari Honey', weight: '250 g', price: '₺ 750', categoryId: 'siirt-yoresel', optionsGroup: 'pervari-bali', isMainOption: true, imageUrl: 'https://images.unsplash.com/photo-1587049352847-4d4b126a71dc?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'pervari-bali-500g', name: isTurkish ? 'Orijinal Pervari Balı' : 'Pervari Honey', weight: '500 g', price: '₺ 1450', categoryId: 'siirt-yoresel', optionsGroup: 'pervari-bali', isMainOption: false, imageUrl: 'https://images.unsplash.com/photo-1587049352847-4d4b126a71dc?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'pervari-bali-1000g', name: isTurkish ? 'Orijinal Pervari Balı' : 'Pervari Honey', weight: '1000 g', price: '₺ 2800', categoryId: 'siirt-yoresel', optionsGroup: 'pervari-bali', isMainOption: false, imageUrl: 'https://images.unsplash.com/photo-1587049352847-4d4b126a71dc?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'zivzik-nari-eksisi', name: isTurkish ? 'Orijinal Zivzik Narı Ekşisi' : 'Zivzik Pomegranate Sour', weight: '500 ml', price: '₺ 650', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1599399651610-2da7a6d0cb54?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'menengic', name: isTurkish ? 'Menengiç' : 'Terebinth', weight: '250 g', price: '₺ 200', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'menengic-kahvesi', name: isTurkish ? 'Menengiç Kahvesi' : 'Terebinth Coffee', weight: '250 g', price: '₺ 250', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1559525839-b184a4d698c7?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'siirt-bittim-sabunu', name: isTurkish ? 'Hakiki Siirt Bıttım Sabunu' : 'Siirt Bıttım Soap', weight: '1 Adet', price: '₺ 100', categoryId: 'siirt-yoresel', imageUrl: 'https://images.unsplash.com/photo-1600857062241-98e5dba7f214?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'siirt-fistigi-250g', name: isTurkish ? 'Siirt Fıstığı' : 'Siirt Pistachio', weight: '250 g', price: '₺ 280', categoryId: 'siirt-yoresel', optionsGroup: 'siirt-fistigi', isMainOption: true, imageUrl: 'https://images.unsplash.com/photo-1599598425947-330026e6371a?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'siirt-fistigi-500g', name: isTurkish ? 'Siirt Fıstığı' : 'Siirt Pistachio', weight: '500 g', price: '₺ 550', categoryId: 'siirt-yoresel', optionsGroup: 'siirt-fistigi', isMainOption: false, imageUrl: 'https://images.unsplash.com/photo-1599598425947-330026e6371a?auto=format&fit=crop&w=600&q=80'),
    StoreProduct(id: 'siirt-fistigi-1000g', name: isTurkish ? 'Siirt Fıstığı' : 'Siirt Pistachio', weight: '1000 g', price: '₺ 1050', categoryId: 'siirt-yoresel', optionsGroup: 'siirt-fistigi', isMainOption: false, imageUrl: 'https://images.unsplash.com/photo-1599598425947-330026e6371a?auto=format&fit=crop&w=600&q=80'),
  ];

  static List<StoreProduct> mainProducts(bool isTurkish) => products(isTurkish).where((p) => p.isMainOption).toList();
}

extension StringTurkishExtension on String {
  String toSearchable() {
    return toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll('â', 'a')
        .replaceAll('î', 'i');
  }
}
