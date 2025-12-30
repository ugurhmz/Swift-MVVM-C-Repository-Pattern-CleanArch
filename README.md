# 📙 Repository Pattern vs Adapter Pattern (Neden İkisi de Şart?)



<br>
MVVM-C, Repository Pattern ve Adapter Pattern kullanılarak geliştirilmiş, Clean Architecture prensiplerine uygun, ölçeklenebilir iOS uygulaması. Dependency Injection ve SOLID prensipleriyle tamamen modüler bir yapı.

<br>

---
<br>


```swift
🔴 KULLANICI AKSİYONU (Tetikleyici) 1.
      |
      v
+-----------------------+
|      VIEW (UI)        |   2. [ View -> ViewModel'e Emir Verir ]  => "Bana listeyi getir, gerisine karışmam."
+-----------------------+
      |   
      v
+-----------------------+
|      VIEWMODEL        |  3. [ ViewModel -> Repository'ye İletir ] => "Protokol üzerinden veriyi getir."
+-----------------------+
      |    
      v
+-----------------------+
|     REPOSITORY        |  (Karar Anı: Cache mi? API mi?) 4. [ Repository -> Adapter'a Emreder ] => "Şu Endpoint'e git, veriyi al."
+-----------------------+
      |       
      v
+-----------------------+
|      ADAPTER          |  5. [ Adapter -> CoreNetworking'i Çalıştırır ] => "Motoru çalıştır, isteği at."
+-----------------------+
      |    
      v
+-----------------------+
|   INFRASTRUCTURE      |  6. HTTP Request
+-----------------------+
      |
      v
      ☁️ API (İnternet)
```

**Verinin Yolculuğu:**

1. **API :** `JSON` formatında ham, karmaşık ve kirli veri döner.
2. **Infrastructure/Adapter:** JSON verisini `Data` byte'larına veya `Decodable` bir objeye (`RickAndMortyResponse`) çevirir.
3. **Repository :** Burası en kritik yerdir. Dışarıdan gelen `RickAndMortyResponse`  modelini alır, içindeki gereksiz alanları atar, `Optional` değerleri temizler ve uygulamanın anlayacağı tertemiz `Character` (Entity) modeline çevirir (yani `toDomain` işlemi).
4. **ViewModel:** Artık elinde tertemiz `[Character]` dizisi vardır. Bunu UI'ın anlayacağı duruma (`HomeViewState.success`) çevirir.
5. **View:** Sadece son kullanıcıya listeyi gösterir

## Mimari Akış ve Sorumluluklar

- **View (VC):** Sadece veriyi ekranda gösterme işini yapar. Herhangi bir Logic barındırmaz.
- **ViewModel:** "Ne gösterileceğine" karar verir. Veriyi Repository katmanından talep eder. Asla Network detaylarını, URL'leri veya JSON yapısını bilmez.
- **Repository (Data Layer / Veri Katmanı):** ViewModel ile Network Adapter arasındaki "Karar Verici" mekanizmadır: -
    - ViewModel'den gelen isteği alır.
    - verinin API'den mi, önbellekten (Cache) mi yoksa yerel bir dosyadan (Mock) mı geleceğine karar verir.
    - En önemli görevi, ham veriyi (DTO) işleyip temiz Domain modeline çevirmektir.
- **CoreNetworking (Infrastructure):** İnternete çıkıp ham datayı getiren işçidir. Sadece isteği atar ve cevabı döner.

> Not: Profesyonel ve büyük ölçekli projelerde MVVM mimarisi kullanıldığında, Repository Pattern kullanımı neredeyse zorunludur.
> 

## Doğru Akış Nasıl Çalışmalı?

ViewModel ve Data katmanı arasındaki iletişim şu prensiplerle ilerlemelidir:

1. **ViewModel:** Repository'den karakter listesini ister. Verinin nasıl alındığı, hangi endpoint'e gidildiği veya JSON formatı ViewModel'in ilgi alanına girmez.
2. **Repository:** İsteği karşılar. Gerekli Endpoint detaylarını kullanarak Network Client'ı çağırır. Gelen `RickAndMortyResponse` (DTO) modelini, uygulamanın kullandığı temiz `Character` (Domain) modeline dönüştürür.
3. **ViewModel:** Temiz veriyi alır ve ekrana basar.

> Kritik Teknik Detay: ViewModel, Repository'nin kendisine (Class) değil, Protokolüne (Interface) bağımlıdır. Bu sayede test yazarken gerçek Repository yerine sahte bir MockRepository enjekte edilebilir. ViewModel arkada çalışan sınıfın ismini bilmez, sadece fetchCharacters() fonksiyonuna sahip bir yapı olduğunu bilir.
> 

## Kod Üzerinde Fark Analizi

Neyi yapmamalıyız ve neyi yapmalıyız?

### Yanlış Kullanım (Tight Coupling - Sıkı Bağlılık)

Aşağıdaki örnekte ViewModel, API'nin detaylarını (Endpoint) bilmektedir. Bu durum mimaride "Sızıntı" (Leaky Abstraction) yaratır.

```swift
// ViewModel içinde:
func fetch() {
   // HATA: ViewModel, API detayını ve Endpoint'i biliyor!
   networkClient.request(RickAndMortyEndpoint.getCharacters) 
}
```

### Doğru Kullanım (Loose Coupling - Gevşek Bağlılık)

Burada ViewModel sadece kendi işini bilir. Arkada REST API, GraphQL veya Local DB olup olmadığını bilmez.

```swift
// ViewModel içinde:
func fetch() {
   // DOĞRU: ViewModel sadece fonksiyonu çağırır. Arkada ne olduğu Repository'nin sorumluluğundadır.
   repository.getCharacters() 
}
```

## Karar Matrisi: MVVM ile Her Zaman Repository Kullanmalı mıyız?

Bu sorunun cevabı projenin ölçeğine ve hedeflerine göre değişir:

| **Senaryo** | **Mimari** | **Repository Gerekli mi?** | **Neden?** |
| --- | --- | --- | --- |
| **Prototip / Hackathon** | Düz MVVM | **HAYIR** | Hız önemlidir. Kodun kalıcılığı belirsizdir. Direkt ViewModel'den istek atılabilir. |
| **Freelance / Basit App** | MVVM + Service | **BELKİ** | Uygulama 2-3 ekrandan oluşuyorsa basit bir Service/Manager sınıfı yeterli olabilir. |
| **Kurumsal / Profesyonel** | MVVM + Clean Arch | **KESİNLİKLE EVET** | Test edilebilirlik, ekip çalışması ve kodun uzun vadeli bakımı için zorunludur. |

Neden "Kesinlikle Evet"?

Kodun sadece çalışması yetmez, kodun "yaşayabilmesi" gerekir. Repository Pattern'in hayat kurtardığı senaryolar şunlardır:

1. Önbellekleme (Caching) Senaryosu:
    
    Egerki Lead "İnternet yoksa veriyi veritabanından (CoreData/Realm) göster" dediğinde;
    
    - **Repository Yoksa:** Tüm ViewModel'leri tek tek gezip `if internetVar { api } else { db }` mantığını kurmanız gerekir.  Tam bir Kabus :(
    - **Repository Varsa:** ViewModel'e dokunmazsınız. Sadece Repository içindeki tek bir fonksiyonu güncellersiniz.
2. Mock Data ve Preview Gücü:
    
    SwiftUI veya UIKit Preview kullanırken gerçek internete çıkmak istemezsiniz. Repository sayesinde, ViewModel'e Dummy Data dönen bir MockRepository enjekte ederek ekranı anında tasarlayabilirsiniz.
    

## Bu Parçaları Kim Birleştiriyor? (Dependency Injection)

ViewModel, Repository'yi kendi içinde oluşturmaz (`let repo = Repository()` demez). Bu parçalar uygulamanın giriş noktasında, yani **Coordinator** veya **Composition Root** üzerinde birleştirilir:

Swift

```swift
// Coordinator içinde Montaj:
let adapter = CoreNetworkAdapter()
let repository = CharacterRepository(networkService: adapter)
let viewModel = HomeViewModel(repository: repository) // Enjeksiyon burada yapılır
```

Bu sayede ViewModel'in içi temiz kalır ve tüm bağımlılıklar dışarıdan yönetilir.

## Kritik Karşılaştırma: Repository Pattern Olursa Ne Olur?

Önceki yazılarımda MVVM + Adapter Pattern yapısından bahsetmiştim. Bu yapı teknik olarak çalışsa da, Repository Pattern eksik olduğunda mimaride hala bir "Sızıntı" (Leak) mevcuttur.

İki senaryoyu karşılaştıralım:

### 1. Senaryo: Repository Pattern OLMADAN (MVVM + Adapter)

Bu yapıda ViewModel, doğrudan Network Adapter ile konuşur.

**Akış:** `View -> ViewModel -> NetworkAdapter -> Alamofire`

```swift
// ViewModel
func fetch() {
    // ViewModel, Endpoint detayını ve API Response tipini  bilmek zorunda kalır.
    adapter.request(RickAndMortyEndpoint.getCharacters, model: RickAndMortyResponse.self)
}
```

**Riskler ve Sorunlar:**

- **Data Layer Sızıntısı:** ViewModel, verinin "nasıl" ve "nereden" geldiğini bilir. UI katmanı, veri katmanının detaylarına bulaşmış olur.
- **DTO Bağımlılığı:** API'den dönen ham veri modeli (`RickAndMortyResponse`), ViewModel'in içine kadar girer. API'de bir isim değişikliği olursa UI kodlarını da güncellemek zorunda kalırsınız.
- **Caching Zorluğu:** Önbellekleme mantığını ViewModel'e yazmak zorunda kalırsınız. Bu da kod tekrarına yol açar.

### 2. Senaryo: Repository Pattern İLE (MVVM + Adapter + Repository)

Bu yapıda ViewModel ve Adapter arasına bir "Veri Yöneticisi" girer.

**Akış:** `View -> ViewModel -> Repository -> NetworkAdapter -> Alamofire`

```swift
// ViewModel
func fetch() {
    // ViewModel sadece "Bana karakterleri ver" der. Endpoint veya DTO umurunda değildir.
    repository.getCharacters()
}
```

**Avantajlar:**

- **Tam İzolasyon (Loose Coupling):** ViewModel; HTTP, Endpoint veya JSON gibi terimleri bilmez. Sadece uygulamanın kendi modellerini (`Character`) bilir.
- **Mapping Merkezi:** API'den gelen karmaşık DTO, Repository içinde temiz Entity modeline çevrilir.
- **Kolay Test:** ViewModel testlerinde sadece "Repository bana veri döndü mü?" kontrolü yapılır. Mocklamak çok daha basittir.

### Özet Karşılaştırma Tablosu

| **Özellik** | **Repository OLMADAN** | **Repository İLE** |
| --- | --- | --- |
| **ViewModel Bilgisi** | Endpoint detaylarını bilir. | Sadece Domain Modellerini bilir. |
| **Veri Dönüşümü** | ViewModel içinde yapılır. | Repository içinde yapılır. |
| **Bağımlılık** | UI ve Data birbirine sıkı bağlıdır (Tight). | UI ve Data birbirinden kopuktur (Loose). |
| **Değişim Maliyeti** | API değişirse ViewModel değişir. | API değişirse sadece Repository değişir. |
| **Önbellekleme** | Yönetmesi zordur, kod tekrarı yaratır. | Tek bir merkezden yönetilir. |

## Sonuç ve Motto

Adapter Pattern (bağımlılığı soyutlamak için) ve Repository Pattern (veri mantığını yönetmek için) ayrılmaz bir ikilidir. Bu ikiliyi kullanmak, kodu sektör standartlarına taşır.

**Kural:** Bir mülakatta veya profesyonel projede "MVVM kullanıyorum" diyorsan, yanına Repository Pattern'i mutlaka eklemelisin.

**Motto:** ViewModel asla HTTP, Endpoint, JSON, URL gibi kelimeleri bilmemeli. O sadece kendi Domain Modellerini bilmeli ve ekranı yönetmelidir.
