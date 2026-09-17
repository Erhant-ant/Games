import 'package:flutter/material.dart';

import '../../../core/models/journal_models.dart';
import '../presentation/widgets/journal_article_components.dart';

abstract final class JournalData {
  static List<JournalArticle> articles = [
    JournalArticle(
      id: 'odun-atesinde-salca',
      titleTr: "Madenköy'ün Domatesinden Odun Ateşinde Salçaya",
      titleEn: "From Madenköy's Tomatoes to Wood-Fired Paste",
      summaryTr: "Zahide Hanım Çiftliği'nde toprakta başlayıp odun ateşinde son bulan geleneksel salça yapım hikayemiz.",
      summaryEn: "Our traditional tomato paste making story starting in the soil and ending on wood fire at Zahide Hanım Farm.",
      coverImageUrl: 'https://images.unsplash.com/photo-1628773822503-930a7eaecf80?auto=format&fit=crop&w=1600&q=80',
      tagsTr: ['Ev Yapımı Salça', 'Organik Tarım', 'Doğal Ürünler', 'Madenköy', 'Ata Tohumu', 'Zahide Hanım Çiftliği'],
      tagsEn: ['Homemade Paste', 'Organic Farming', 'Natural Products', 'Madenkoy', 'Heirloom Seeds', 'Zahide Hanim Farm'],
      date: '10 Ekim 2026',
      author: 'Zahide Hanım Çiftliği',
      authorAvatarUrl: '',
      contentBuilder: (context, isTurkish) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bir salçanın lezzeti sadece domatesten gelmez. Domatesin tohumu, yetiştiği toprak, gördüğü güneş, suyu, yetiştirilme şekli ve en sonunda nasıl pişirildiği... Hepsi bir araya gelir.'
                : 'The taste of tomato paste doesn\'t just come from the tomato. The seed, the soil, the sun it sees, the water, how it\'s grown, and finally how it\'s cooked... They all come together.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim salçamızın hikâyesi de Siirt\'in Şirvan ilçesinin yüksek ve serin dağlarında, Madenköy\'de başlıyor. Burada yetiştirdiğimiz domates ve biberleri mümkün olduğunca doğal yöntemlerle yetiştiriyor, ardından kendi mutfağımızda salça ve soslara dönüştürüyoruz.'
                : 'The story of our tomato paste begins in the high and cool mountains of Siirt\'s Şirvan district, in Madenköy. We grow the tomatoes and peppers here as naturally as possible, then turn them into pastes and sauces in our own kitchen.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Yani bizim için salçanın hikâyesi kavanozda değil, toprakta başlıyor.'
                : 'So for us, the story of tomato paste starts in the soil, not in the jar.'),
            
            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🌱 Her şey iyi bir domatesle başlıyor' : '🌱 It all starts with a good tomato'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Biz üretimimizde ata tohumlarını tercih ediyoruz. Salçamızda ağırlıklı olarak iki farklı domatesi bir arada kullanıyoruz: Pembe domates ve kırmızı domates.'
                : 'We prefer heirloom seeds in our production. We mainly use two different tomatoes together in our paste: Pink tomatoes and red tomatoes.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Pembe domatesin kendine özgü aromasıyla kırmızı domatesin rengi ve yoğunluğu birleşince ortaya bizim sevdiğimiz o belirgin domates lezzeti çıkıyor.'
                : 'When the unique aroma of the pink tomato combines with the color and intensity of the red tomato, that distinct tomato flavor we love emerges.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Belki küçük bir ayrıntı gibi görünüyor ama bizim için önemli. Çünkü domatesin kendisi güzel değilse, ondan yaptığınız salçanın da aynı lezzeti vermesini beklemek zor.'
                : 'It might seem like a small detail, but it\'s important to us. Because if the tomato itself isn\'t good, it\'s hard to expect the paste made from it to have the same taste.'),
            JournalArticleComponents.buildQuote(isTurkish
                ? '"Biz bu yüzden salçayı kazanda değil, bahçede başlatıyoruz."'
                : '"That\'s why we start the tomato paste in the garden, not in the cauldron."'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🍅 Madenköy domatesinin farkı nereden geliyor?' : '🍅 Where does the difference of Madenköy tomatoes come from?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Madenköy\'de yetişen domateslerimizi kendi üretim anlayışımız içerisinde yetiştiriyoruz. Ürünlerimizde kimyasal zirai ilaç kullanmamaya özen gösteriyoruz.'
                : 'We grow our tomatoes in Madenköy according to our own production philosophy. We are careful not to use chemical pesticides on our products.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Burada özellikle bir şeyi açıkça söylemek istiyoruz: Laboratuvar analizi ve resmi sertifikasyon olmadan bir ürüne "sertifikalı organik" demek doğru değil. Bu nedenle biz de sadece kulağa güzel geldiği için "organik" demek yerine, nasıl üretim yaptığımızı anlatmayı tercih ediyoruz.'
                : 'We specifically want to state something clearly here: It is not right to call a product "certified organic" without laboratory analysis and official certification. That\'s why, instead of saying "organic" just because it sounds nice, we prefer to explain how we produce.'),
            JournalArticleComponents.buildSubTitle(isTurkish ? 'Bizim için önemli olan:' : 'What matters to us:'),
            JournalArticleComponents.buildList(isTurkish 
                ? ['Ata tohumu', 'Kendi üretimimiz', 'Kimyasal zirai ilaç kullanmadan yetiştirme', 'Geleneksel yöntemlerle işleme']
                : ['Heirloom seed', 'Our own production', 'Growing without chemical pesticides', 'Processing with traditional methods']
            ),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🔬 Peki doğal yetişen domates ile diğer domatesler arasında fark var mı?' : '🔬 Is there a difference between naturally grown tomatoes and others?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bu konuda bilimsel araştırmaların sonuçları oldukça ilginç. Bazı çalışmalarda organik yöntemlerle yetiştirilen domateslerde C vitamini, likopen, fenolik bileşikler ve flavonoidlerin daha yüksek olduğu görülmüş.'
                : 'The results of scientific research on this topic are quite interesting. Some studies have shown higher levels of vitamin C, lycopene, phenolic compounds, and flavonoids in organically grown tomatoes.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Ama bütün araştırmalar aynı sonucu vermiyor. Bazı çalışmalarda organik ve konvansiyonel domatesler arasında belirgin bir besin farkı bulunmamış. Domatesin çeşidi, yetiştiği bölge, toprak ve yetiştirme koşulları da sonucu ciddi şekilde etkileyebiliyor.'
                : 'But not all research yields the same results. Some studies found no significant nutritional difference between organic and conventional tomatoes. The variety of the tomato, the region it\'s grown in, the soil, and growing conditions can also seriously affect the outcome.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim söyleyebileceğimiz şey belli: Domatesimizi nasıl yetiştirdiğimizi biliyoruz ve bunu olduğu gibi anlatıyoruz.'
                : 'What we can say is clear: We know how we grow our tomatoes, and we tell it exactly as it is.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🔥 Sonra işin en güzel kısmı başlıyor' : '🔥 Then the best part begins'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Domateslerimizi hazırladıktan sonra salçamızı odun ateşinde kaynatıyoruz. Ateş yanıyor. Kazan kuruluyor. Domatesler yavaş yavaş pişiyor.'
                : 'After preparing our tomatoes, we boil our paste over a wood fire. The fire burns. The cauldron is set up. The tomatoes cook slowly.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Suyu azaldıkça kıvamı koyulaşıyor, kokusu bütün ortama yayılıyor. Ve saatler süren bu sürecin sonunda bahçeden topladığımız domates, sofraya girecek salçaya dönüşüyor.'
                : 'As its water decreases, it thickens, and its smell spreads throughout the environment. And at the end of this hours-long process, the tomatoes we gathered from the garden turn into paste ready for the table.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim için bu sadece bir pişirme yöntemi değil. Biraz sabır, biraz emek ve biraz da geçmişten gelen alışkanlık.'
                : 'For us, this isn\'t just a cooking method. It\'s a bit of patience, a bit of effort, and a bit of habit from the past.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🍅 Pişen domatesin faydası kayboluyor mu?' : '🍅 Are the benefits of cooked tomatoes lost?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Domatesin pişirilmesi bazı besin öğelerinde kayıplara neden olabilir. Fakat likopen konusunda durum biraz farklı.'
                : 'Cooking tomatoes can cause losses in some nutrients. But when it comes to lycopene, the situation is a bit different.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Araştırmalar, domatesin işlenmesiyle likopenin vücut tarafından kullanılabilirliğinin artabileceğini gösteriyor. Örneğin bir insan çalışmasında domates salçasından alınan likopenin, taze domatese kıyasla daha yüksek biyoyararlanım gösterdiği bulunmuş.'
                : 'Research shows that processing tomatoes can increase the body\'s availability of lycopene. For example, in a human study, lycopene from tomato paste was found to have higher bioavailability compared to fresh tomatoes.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Yani domatesi salçaya dönüştürmek, "bütün besin değerleri yok oluyor" anlamına gelmiyor. Nasıl işlendiği önemli. Biz ise bu işi bildiğimiz geleneksel yöntemlerle yapıyoruz.'
                : 'So turning tomatoes into paste doesn\'t mean "all nutritional values are destroyed". How it\'s processed matters. We do this work with the traditional methods we know.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🫑 Biberlerimiz de aynı hikâyenin parçası' : '🫑 Our peppers are part of the same story'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Sadece domates değil. Kendi yetiştirdiğimiz biberlerden biber salçası ve çeşitli soslar da hazırlıyoruz. Burada da aynı anlayış devam ediyor.'
                : 'Not just tomatoes. We also prepare pepper paste and various sauces from the peppers we grow ourselves. The same understanding continues here.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Hazır bir ürünü alıp sadece kavanozlamak yerine, ürünün mümkün olduğunca başından sonuna kadar kendi elimizden geçmesini istiyoruz. Çünkü sofranıza koyduğumuz ürünü önce kendimiz yemek istiyoruz.'
                : 'Instead of just taking a ready-made product and jarring it, we want the product to pass through our hands from beginning to end as much as possible. Because we want to eat the product we put on your table first.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🏡 Bir kavanoz salçanın içinde neler var?' : '🏡 What\'s inside a jar of tomato paste?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Dışarıdan baktığınızda bir kavanoz salça görüyorsunuz. Biz biraz daha farklı bakıyoruz. O kavanozda;'
                : 'When you look from the outside, you see a jar of paste. We look a bit differently. In that jar;'),
            JournalArticleComponents.buildList(isTurkish 
                ? ['Pembe domates var.', 'Kırmızı domates var.', 'Ata tohumu var.', 'Madenköy\'ün toprağı var.', 'Kullandığımız temiz su var.', 'Odun ateşi var.', 'Emek var.', 'Ve en önemlisi, ev yapımı bir ürün hazırlama isteği var.']
                : ['There is pink tomato.', 'There is red tomato.', 'There is heirloom seed.', 'There is Madenkoy\'s soil.', 'There is clean water we use.', 'There is wood fire.', 'There is effort.', 'And most importantly, there is a desire to prepare a homemade product.']
            ),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Belki de bu yüzden bizim salçamızın tadı alıştığınız bazı salçalardan farklı gelebilir. Daha yoğun, daha belirgin ve daha domatesli. Çünkü biz domatesin tadını mümkün olduğunca öne çıkarmaya çalışıyoruz.'
                : 'Perhaps that\'s why the taste of our paste might seem different from some pastes you are used to. More intense, more distinct, and more tomatoey. Because we try to bring out the tomato taste as much as possible.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🌿 Madenköy\'den sofranıza' : '🌿 From Madenköy to your table'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Zahide Hanım Çiftliği\'nde bizim için iyi ürün sadece güzel görünen ürün değil. Nereden geldiğini bildiğimiz, nasıl üretildiğini anlatabildiğimiz ve kendi soframıza koymaktan çekinmediğimiz ürün.'
                : 'At Zahide Hanım Farm, a good product is not just a good-looking product for us. It\'s a product we know where it comes from, we can explain how it\'s produced, and we don\'t hesitate to put it on our own table.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bugün bir kavanoz salçadan bahsettik. Ama aslında anlattığımız şey biraz daha büyük: Topraktan sofraya uzanan bir üretim hikâyesi. Madenköy\'den sofranıza... Zahide Hanım Çiftliği. 🌿🍅'
                : 'Today we talked about a jar of paste. But actually what we are telling is a bit bigger: A production story extending from the soil to the table. From Madenköy to your table... Zahide Hanım Farm. 🌿🍅'),

            JournalArticleComponents.buildBibliography([
              'Vinha AF ve ark. (2014) — Organic versus conventional tomatoes: influence on physicochemical parameters, bioactive compounds and sensorial attributes. Food and Chemical Toxicology.',
              'Hallmann E. (2012) — The influence of organic and conventional cultivation systems on the nutritional value and content of bioactive compounds in selected tomato types. Journal of the Science of Food and Agriculture.',
              'Gärtner C, Stahl W, Sies H. (1997) — Lycopene is more bioavailable from tomato paste than from fresh tomatoes. American Journal of Clinical Nutrition.',
              'Shi J. ve ark. (2001) — Processing effects on lycopene content and antioxidant activity of tomatoes. Journal of Agricultural and Food Chemistry.'
            ], isTurkish),
          ],
        );
      }
    ),
    JournalArticle(
      id: 'siirt-fistigi-faydalari',
      titleTr: 'Siirt Fıstığı Nedir? Faydaları, Besin Değeri ve Nasıl Tüketilir?',
      titleEn: 'What is Siirt Pistachio? Benefits, Nutritional Value, and How to Consume It?',
      summaryTr: "Siirt fıstığını diğer kuruyemişlerden ayıran nedir? Besin değeri nasıldır? Fazla tüketildiğinde kilo aldırır mı? Gelin birlikte bakalım.",
      summaryEn: "What distinguishes Siirt pistachio from other nuts? What is its nutritional value? Let's take a look together.",
      coverImageUrl: 'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&w=1600&q=80',
      tagsTr: ['Siirt Fıstığı', 'Siirt Yöresel Ürünler', 'Fıstığın Faydaları', 'Kuruyemiş', 'Sağlıklı Beslenme'],
      tagsEn: ['Siirt Pistachio', 'Siirt Regional Products', 'Pistachio Benefits', 'Nuts', 'Healthy Nutrition'],
      date: 'Sürekli Güncel',
      author: 'Zahide Hanım Çiftliği',
      authorAvatarUrl: '',
      contentBuilder: (context, isTurkish) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JournalArticleComponents.buildParagraph(isTurkish 
                ? 'Siirt denince akla gelen güzelliklerden biri de hiç şüphesiz Siirt fıstığı. Kendine özgü aroması, iri yapısı ve lezzetiyle özellikle çerez olarak severek tüketilen Siirt fıstığı, son yıllarda Türkiye\'nin farklı bölgelerinde de daha fazla tanınmaya başladı.' 
                : 'One of the beauties that comes to mind when Siirt is mentioned is undoubtedly the Siirt pistachio. With its unique aroma, large size, and delicious taste, it is loved as a snack and has become increasingly popular in different regions of Turkey in recent years.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Biz de Zahide Hanım Çiftliği olarak yetiştiğimiz toprakların değerini ve bize sunduğu doğal ürünleri anlatmaya buradan başlamak istedik. İlk yazımızda konuğumuz, bizim için ayrı bir yeri olan Siirt fıstığı.'
                : 'As Zahide Hanım Çiftliği, we wanted to start by explaining the value of the lands we grew up in and the natural products it offers us. Our guest in our first article is the Siirt pistachio, which holds a special place for us.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Peki Siirt fıstığını diğer kuruyemişlerden ayıran nedir? Besin değeri nasıldır? Fazla tüketildiğinde kilo aldırır mı? Gelin birlikte bakalım.'
                : 'So what distinguishes the Siirt pistachio from other nuts? What is its nutritional value? Does it cause weight gain if consumed too much? Let\'s take a look together.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🌿 Siirt Fıstığı Nedir?' : '🌿 What is Siirt Pistachio?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı, Güneydoğu Anadolu\'nun önemli tarım ürünlerinden biridir. Özellikle Siirt ve çevresinde yetiştirilen fıstık, kendine özgü iklim ve toprak koşullarının da etkisiyle farklı bir aromaya sahip olur.'
                : 'The Siirt pistachio is one of the important agricultural products of Southeastern Anatolia. Especially grown in and around Siirt, it acquires a distinct aroma due to the unique climate and soil conditions.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Antep fıstığıyla aynı aileden gelen Siirt fıstığının en dikkat çekici özelliklerinden biri iri taneli ve dolgun yapısıdır. Tadı ise daha belirgin, yağlı ve aromatik bir karaktere sahiptir.'
                : 'Coming from the same family as the Antep pistachio, one of the most striking features of the Siirt pistachio is its large and plump grains. Its taste has a more pronounced, oily, and aromatic character.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim açımızdan Siirt fıstığını özel yapan sadece lezzeti değil. Aynı zamanda bu ürünün arkasında toprak, emek ve uzun bir üretim süreci olması.'
                : 'For us, what makes the Siirt pistachio special is not just its taste, but also the soil, labor, and long production process behind it.'),
            
            JournalArticleComponents.buildQuote(isTurkish 
                ? '"Bir avuç fıstığın arkasında, aslında aylarca hatta yıllarca süren bir üretim hikâyesi var."'
                : '"Behind a handful of pistachios, there is actually a production story that lasts for months or even years."'),

            const SizedBox(height: 16),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🥜 Siirt Fıstığının Faydaları Nelerdir?' : '🥜 What Are the Benefits of Siirt Pistachio?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı, diğer kuruyemişlerde olduğu gibi protein, yağ, lif, vitamin ve mineral açısından zengin bir besindir. Dengeli bir beslenme içerisinde ölçülü miktarda tüketildiğinde günlük beslenmeye değerli besin öğeleri sağlayabilir.'
                : 'Like other nuts, Siirt pistachio is a food rich in protein, fat, fiber, vitamins, and minerals. When consumed in moderation within a balanced diet, it can provide valuable nutrients.'),
            JournalArticleComponents.buildSubTitle(isTurkish ? 'Protein içerir' : 'Contains Protein'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı bitkisel protein kaynaklarından biridir. Bu nedenle özellikle ara öğünlerde tok tutmaya yardımcı olabilecek besinlerden biri olarak tercih edilebilir.'
                : 'Siirt pistachio is a source of plant-based protein. Therefore, it can be preferred as a food that helps keep you full, especially during snacks.'),
            JournalArticleComponents.buildSubTitle(isTurkish ? 'Sağlıklı yağlar açısından zengindir' : 'Rich in healthy fats'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Fıstığın önemli bir bölümünü yağ oluşturur. Ancak burada önemli olan nokta, yağın türüdür. Fıstıkta ağırlıklı olarak doymamış yağ asitleri bulunur. Bu nedenle fıstığı tamamen hayatımızdan çıkarmak yerine miktarına dikkat ederek tüketmek daha doğru bir yaklaşım olacaktır.'
                : 'A significant portion of the pistachio consists of fat. However, the important point here is the type of fat. It mainly contains unsaturated fatty acids. Therefore, instead of completely removing it from our lives, it is a better approach to consume it carefully.'),
            JournalArticleComponents.buildSubTitle(isTurkish ? 'Lif içerir' : 'Contains fiber'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığında diyet lifi de bulunur. Lif, dengeli beslenmenin önemli parçalarından biridir ve tokluk hissinin oluşmasına katkı sağlayabilir.'
                : 'Siirt pistachio also contains dietary fiber. Fiber is an important part of a balanced diet and contributes to a feeling of fullness.'),
            JournalArticleComponents.buildSubTitle(isTurkish ? 'Vitamin ve mineraller' : 'Vitamins and minerals'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Fıstık; özellikle B grubu vitaminleri, E vitamini, fosfor, magnezyum, demir ve diğer mineraller açısından değerli bir besindir. Elbette tek başına herhangi bir hastalığı tedavi eden bir besin olarak düşünülmemelidir. Faydalarından yararlanmanın en güzel yolu, onu çeşitli ve dengeli bir beslenmenin parçası haline getirmektir.'
                : 'Pistachios are a valuable food, especially regarding B vitamins, vitamin E, phosphorus, magnesium, iron, and other minerals. Of course, it should not be considered a food that treats any disease on its own. The best way to benefit from it is to make it part of a varied and balanced diet.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '❤️ Siirt Fıstığı Kalp ve Damar Sağlığı İçin Faydalı mı?' : '❤️ Is Siirt Pistachio Good for Heart Health?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Kuruyemişler üzerine yapılan araştırmalar, düzenli ve ölçülü kuruyemiş tüketiminin genel beslenme düzeni içerisinde kalp-damar sağlığı açısından olumlu etkilerle ilişkili olabileceğini gösteriyor.'
                : 'Research on nuts shows that regular and moderate consumption can be associated with positive effects on cardiovascular health within a general diet.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığının içerdiği doymamış yağlar, lif, protein ve antioksidan bileşenler bu açıdan dikkat çekiyor. Ancak burada küçük bir ayrıntıyı unutmamak gerekiyor: Fıstık sağlıklı bir besin olsa da sınırsız tüketilebilecek düşük kalorili bir yiyecek değildir.'
                : 'The unsaturated fats, fiber, protein, and antioxidant components contained in Siirt pistachios draw attention in this regard. But there is a small detail not to forget: Even though it is healthy, it is not a low-calorie food that can be consumed unlimitedly.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '⚖️ Siirt Fıstığı Kilo Aldırır mı?' : '⚖️ Does Siirt Pistachio Cause Weight Gain?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bu soru bize en çok sorulanlardan biri. Kısaca söyleyelim: Fazla tüketildiğinde evet, kilo alımına katkıda bulunabilir.'
                : 'This is one of the most frequently asked questions. In short: Yes, if consumed in excess, it can contribute to weight gain.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Çünkü fıstık besleyici olmasının yanında enerji yoğun bir besindir. Özellikle televizyon karşısında veya sohbet sırasında fark etmeden bir avuçtan çok daha fazlasını yemek oldukça kolaydır.'
                : 'Because pistachios are energy-dense in addition to being nutritious. Especially in front of the television or during conversations, it is easy to eat much more than a handful without realizing it.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Öte yandan porsiyon kontrolü yapıldığında fıstık, tokluk sağlayan protein ve lif içeriği sayesinde dengeli bir beslenme içerisinde güzel bir ara öğün seçeneği olabilir. Yani mesele fıstığı tamamen bırakmak değil, ne kadar tükettiğimizi bilmek.'
                : 'On the other hand, when portion control is practiced, its protein and fiber content provide satiety, making it a great snack option. So the issue is not quitting pistachios entirely, but knowing how much we consume.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '📊 Siirt Fıstığının Besin Değeri' : '📊 Nutritional Value of Siirt Pistachio'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Kaynağa ve ürünün işlenme şekline göre besin değerlerinde farklılıklar görülebilir. Verilen örnek değerlere göre 100 gram Siirt fıstığında yaklaşık olarak:'
                : 'Nutritional values can vary depending on the source and processing method. According to sample values, 100 grams of Siirt pistachio contains approximately:'),
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE7E1D4)),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                border: const TableBorder.symmetric(inside: BorderSide(color: Color(0xFFE7E1D4))),
                children: [
                  JournalArticleComponents.buildTableRow(isTurkish ? 'Besin öğesi' : 'Nutrient', isTurkish ? '100 g için' : 'Per 100 g', isHeader: true),
                  JournalArticleComponents.buildTableRow(isTurkish ? 'Enerji' : 'Energy', '628 kcal'),
                  JournalArticleComponents.buildTableRow(isTurkish ? 'Yağ' : 'Fat', '58,69 g'),
                  JournalArticleComponents.buildTableRow(isTurkish ? 'Karbonhidrat' : 'Carbohydrates', '4,41 g'),
                  JournalArticleComponents.buildTableRow('Protein', '20,63 g'),
                  JournalArticleComponents.buildTableRow(isTurkish ? 'Diyet lifi' : 'Dietary fiber', '11,74 g'),
                ],
              ),
            ),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Buradaki değerlerin ürünün çeşidine, kavrulma yöntemine ve hazırlanma şekline göre değişebileceğini de belirtmek isteriz. Özellikle tuzlu veya farklı yöntemlerle işlenmiş ürünlerde besin değerleri değişebilir.'
                : 'We would also like to point out that these values can change depending on the variety, roasting method, and preparation. Especially in salted or differently processed products, nutritional values may differ.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🔥 Siirt Fıstığı Nasıl Tüketilir?' : '🔥 How to Consume Siirt Pistachio?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığını tüketmenin en keyifli yollarından biri, onu kavrulmuş olarak çerez şeklinde tüketmek. Çayın yanında, kahvenin yanında veya dostlarla yapılan uzun sohbetlerde güzel bir eşlikçi oluyor.'
                : 'One of the most pleasant ways to consume Siirt pistachios is roasted as a snack. It makes a wonderful companion to tea, coffee, or long conversations with friends.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Ayrıca:\n• Kahvaltıda,\n• Ara öğünlerde,\n• Kuruyemiş karışımlarında,\n• Salatalarda,\n• Tatlı ve kurabiye tariflerinde,\n• Ev yapımı atıştırmalıklarda\nkullanılabilir.'
                : 'Additionally, it can be used:\n• At breakfast,\n• As a snack,\n• In nut mixes,\n• In salads,\n• In desserts and cookies,\n• In homemade snacks.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim favorimiz ise çok basit: Bir avuç Siirt fıstığı, güzel bir çay ve uzun bir sohbet. 🌿 Bazen iyi bir ürün için çok fazla şeye ihtiyaç olmuyor.'
                : 'Our favorite is very simple: A handful of Siirt pistachios, good tea, and a long conversation. 🌿 Sometimes you don\'t need much for a good product.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🆚 Siirt Fıstığı ile Antep Fıstığı Arasındaki Fark Nedir?' : '🆚 What is the Difference Between Siirt Pistachio and Antep Pistachio?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı ve Antep fıstığı birbirine benzese de aralarında bazı farklar bulunur.'
                : 'Although Siirt and Antep pistachios look similar, they have some differences.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı genellikle daha iri ve dolgun taneli yapısıyla dikkat çeker. Lezzet karakteri de farklıdır. Antep fıstığı ise özellikle tatlı ve baklava sektöründe yaygın şekilde kullanılmasıyla öne çıkar.'
                : 'Siirt pistachios generally stand out with their larger and plumper grains. Their flavor profile is also different. Antep pistachios are especially known for their widespread use in the dessert and baklava industry.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Kısacası ikisinin de kendine özgü bir yeri var. Biz Siirt fıstığını ise özellikle çerezlik olarak tüketildiğinde ortaya çıkan aroması ve kendine özgü lezzeti nedeniyle ayrı bir yere koyuyoruz.'
                : 'In short, both have their own unique place. We place Siirt pistachios in a special category due to the aroma and unique taste that emerges when consumed as a snack.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🌱 Bizim İçin Siirt Fıstığı Ne Anlama Geliyor?' : '🌱 What Does Siirt Pistachio Mean to Us?'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Bizim için Siirt fıstığı sadece bir ürün değil. Toprağın, emeğin ve üretimin bir parçası. Bir ürünü internetten satın almak kolay. Ama o ürünün sofraya gelene kadar geçtiği süreci çoğu zaman görmüyoruz.'
                : 'For us, the Siirt pistachio is not just a product. It is a part of the soil, labor, and production. Buying a product online is easy. But we often do not see the process it goes through before reaching the table.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Biz Zahide Hanım Çiftliği olarak ürünlerimizi anlatırken sadece "şu kadar faydalı" veya "şu kadar lezzetli" demek istemiyoruz. Nereden geldiğini, nasıl tüketilebileceğini ve sofralarımıza nasıl ulaştığını da anlatmak istiyoruz. Çünkü bizim için iyi ürün, önce iyi üretim ve güvenle başlıyor.'
                : 'As Zahide Hanım Çiftliği, we do not just want to say "it is this healthy" or "this delicious." We want to explain where it comes from, how it can be consumed, and how it reaches our tables. Because for us, a good product starts with good production and trust.'),

            const SizedBox(height: 32),
            JournalArticleComponents.buildSectionTitle(isTurkish ? '🥜 Son Bir Avuç Siirt Fıstığı...' : '🥜 One Last Handful of Siirt Pistachios...'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Siirt fıstığı; lezzeti, besin içeriği ve kendine özgü aromasıyla sofralarımızda kendine güzel bir yer edinmiş değerli bir ürün. Ancak her besinde olduğu gibi burada da önemli olan denge ve ölçü.'
                : 'With its taste, nutritional content, and unique aroma, the Siirt pistachio is a valuable product that has earned a beautiful place on our tables. But as with any food, balance and moderation are key.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'İster çayın yanında birkaç tane, ister sevdiklerinizle paylaşacağınız güzel bir çerez tabağında... Önemli olan, ne yediğimizi bilmek ve iyi ürünü doğru şekilde tüketmek.'
                : 'Whether it\'s a few with tea or on a beautiful snack plate shared with loved ones... The important thing is knowing what we eat and consuming a good product properly.'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Biz de bundan sonraki yazılarımızda Siirt\'in, toprağın ve üretimin bize sunduğu değerleri anlatmaya devam edeceğiz. Zahide Hanım Çiftliği\'nden sofranıza uzanan hikâyenin ilk yazısı bu olsun. 🌿'
                : 'In our upcoming articles, we will continue to explain the values that Siirt, the soil, and production offer us. Let this be the first article of the story extending from Zahide Hanım Çiftliği to your table. 🌿'),
            JournalArticleComponents.buildParagraph(isTurkish
                ? 'Not: Beslenme ve sağlıkla ilgili bilgiler genel bilgilendirme amaçlıdır. Herhangi bir hastalığın tedavisi veya önlenmesi için tek başına Siirt fıstığına güvenilmemelidir.'
                : 'Note: Information regarding nutrition and health is for general informational purposes. Siirt pistachios should not be relied upon alone to treat or prevent any disease.'),
          ],
        );
      }
    ),
  ];
}
