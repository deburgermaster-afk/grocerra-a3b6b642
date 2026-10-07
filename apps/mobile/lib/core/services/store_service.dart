import '../models/catalog_models.dart';
import 'supabase_service.dart';

/// Service responsible for fetching store listings, categories, and products.
/// Connects to Supabase PostgREST endpoints when configured, with seamless
/// local fallback to prototype stores (e.g. Madina Halal Meats) for testing and offline resilience.
class StoreService {
  StoreService._();
  static final StoreService instance = StoreService._();

  /// Returns active grocery stores and caterers in Melbourne.
  Future<List<Store>> getStores({String? cuisineFilter, String? kindFilter}) async {
    if (SupabaseService.isReady) {
      try {
        final List<dynamic> response = await SupabaseService.client
            .from('stores')
            .select('*')
            .eq('status', 'active');

        if (response.isNotEmpty) {
          List<Store> stores = response
              .map((dynamic data) => Store.fromJson(data as Map<String, dynamic>))
              .toList();

          if (cuisineFilter != null && cuisineFilter.isNotEmpty) {
            stores = stores
                .where((Store s) => s.cuisines.contains(cuisineFilter))
                .toList();
          }
          if (kindFilter != null && kindFilter.isNotEmpty) {
            stores = stores.where((Store s) => s.kind == kindFilter).toList();
          }
          return stores;
        }
      } catch (_) {
        // Fall back gracefully to mock prototype stores
      }
    }

    // Seeded prototype data matching the Reevake blueprints & project brief
    var list = _mockStores;
    if (cuisineFilter != null && cuisineFilter.isNotEmpty) {
      list = list.where((Store s) => s.cuisines.contains(cuisineFilter)).toList();
    }
    if (kindFilter != null && kindFilter.isNotEmpty) {
      list = list.where((Store s) => s.kind == kindFilter).toList();
    }
    return list;
  }

  /// Returns store by ID.
  Future<Store?> getStoreById(String id) async {
    final List<Store> all = await getStores();
    try {
      return all.firstWhere((Store s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns market categories (Halal Meat, Pantry, Spices, Sweets, etc.).
  Future<List<Category>> getCategories() async {
    return _mockCategories;
  }

  /// Returns products for a specific store.
  Future<List<Product>> getProductsByStore(String storeId, {String? categoryId}) async {
    if (SupabaseService.isReady) {
      try {
        var query = SupabaseService.client
            .from('products')
            .select('*, variants:product_variants(*)')
            .eq('store_id', storeId);

        if (categoryId != null && categoryId.isNotEmpty) {
          query = query.eq('category_id', categoryId);
        }

        final List<dynamic> response = await query;
        if (response.isNotEmpty) {
          return response
              .map((dynamic data) => Product.fromJson(data as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {
        // Fall through to mock products
      }
    }

    var products = _mockProducts.where((Product p) => p.storeId == storeId).toList();
    if (products.isEmpty) {
      // If requested store has no exact mocks, return prototype inventory
      products = _mockProducts;
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      products = products.where((Product p) => p.categoryId == categoryId).toList();
    }
    return products;
  }

  // ==========================================
  // Prototype Data (Melbourne Pilot Stores)
  // ==========================================

  static final List<Store> _mockStores = <Store>[
    const Store(
      id: 'store-madina-halal',
      name: 'Madina Halal Meats',
      abn: '32 109 876 543',
      kind: 'butcher',
      isHalalCertified: true,
      rating: 4.9,
      reviewCount: 312,
      deliveryEtaMinutes: 30,
      deliveryFeeCents: 450, // $4.50 AUD
      heroImageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=800&q=80',
      cuisines: <String>['Pakistani', 'Indian', 'Halal'],
      suburb: 'Coburg',
      addressLine: '142 Sydney Road, Coburg VIC 3058',
      distanceKm: 2.4,
      minimumOrderCents: 2500, // $25.00 AUD
    ),
    const Store(
      id: 'store-dhaka-fresh',
      name: 'Dhaka Fresh Grocers',
      abn: '54 231 987 654',
      kind: 'grocery',
      isHalalCertified: true,
      rating: 4.8,
      reviewCount: 184,
      deliveryEtaMinutes: 35,
      deliveryFeeCents: 500, // $5.00 AUD
      heroImageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80',
      cuisines: <String>['Bangladeshi', 'Indian', 'Halal'],
      suburb: 'Brunswick',
      addressLine: '388 Sydney Road, Brunswick VIC 3056',
      distanceKm: 3.1,
      minimumOrderCents: 2000, // $20.00 AUD
    ),
    const Store(
      id: 'store-karachi-catering',
      name: 'Karachi Feast & Catering',
      abn: '88 412 345 678',
      kind: 'caterer',
      isHalalCertified: true,
      rating: 4.9,
      reviewCount: 95,
      deliveryEtaMinutes: 60,
      deliveryFeeCents: 0,
      heroImageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=800&q=80',
      cuisines: <String>['Pakistani', 'Catering', 'Halal'],
      suburb: 'Dandenong',
      addressLine: '74 Foster Street, Dandenong VIC 3175',
      distanceKm: 8.5,
      minimumOrderCents: 15000, // $150.00 AUD
    ),
    const Store(
      id: 'store-mumbai-sweets',
      name: 'Royal Mumbai Sweets & Snacks',
      abn: '12 876 543 210',
      kind: 'sweets',
      isHalalCertified: false,
      rating: 4.7,
      reviewCount: 140,
      deliveryEtaMinutes: 25,
      deliveryFeeCents: 399,
      heroImageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=800&q=80',
      cuisines: <String>['Indian', 'Vegetarian'],
      suburb: 'Preston',
      addressLine: '215 High Street, Preston VIC 3072',
      distanceKm: 4.2,
      minimumOrderCents: 1500,
    ),
  ];

  static final List<Category> _mockCategories = <Category>[
    const Category(
      id: 'cat-halal-meat',
      name: 'Halal Meat',
      slug: 'halal-meat',
      iconName: 'set_meal',
      sortOrder: 1,
    ),
    const Category(
      id: 'cat-rice-flour',
      name: 'Rice & Atta',
      slug: 'rice-flour',
      iconName: 'grain',
      sortOrder: 2,
    ),
    const Category(
      id: 'cat-spices',
      name: 'Spices & Masalas',
      slug: 'spices',
      iconName: 'local_fire_department',
      sortOrder: 3,
    ),
    const Category(
      id: 'cat-lentils',
      name: 'Lentils & Dals',
      slug: 'lentils',
      iconName: 'spa',
      sortOrder: 4,
    ),
    const Category(
      id: 'cat-sweets-snacks',
      name: 'Sweets & Snacks',
      slug: 'sweets-snacks',
      iconName: 'cake',
      sortOrder: 5,
    ),
    const Category(
      id: 'cat-frozen',
      name: 'Frozen & Ready',
      slug: 'frozen',
      iconName: 'ac_unit',
      sortOrder: 6,
    ),
  ];

  static final List<Product> _mockProducts = <Product>[
    const Product(
      id: 'prod-goat-curry-cut',
      storeId: 'store-madina-halal',
      categoryId: 'cat-halal-meat',
      name: 'Fresh Halal Baby Goat (Curry Cut)',
      description: 'Prime Australian fresh goat meat, cut into curry pieces with bone. 100% certified Halal.',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
      isHalal: true,
      variants: <ProductVariant>[
        ProductVariant(
          id: 'var-goat-1kg',
          productId: 'prod-goat-curry-cut',
          label: '1 kg (Weight Approx)',
          priceCents: 2499, // $24.99 AUD
          weightGrams: 1000,
          isPricedByWeight: true, // Catch-weight flag!
          unitOfMeasure: 'kg',
        ),
        ProductVariant(
          id: 'var-goat-2kg',
          productId: 'prod-goat-curry-cut',
          label: '2 kg (Weight Approx)',
          priceCents: 4799,
          weightGrams: 2000,
          isPricedByWeight: true,
          unitOfMeasure: 'kg',
        ),
      ],
    ),
    const Product(
      id: 'prod-chicken-breast',
      storeId: 'store-madina-halal',
      categoryId: 'cat-halal-meat',
      name: 'Halal Skinless Chicken Breast Fillets',
      description: 'Tender fresh chicken fillets, hormone-free, grain-fed, hand-slaughtered certified halal.',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=600&q=80',
      isHalal: true,
      variants: <ProductVariant>[
        ProductVariant(
          id: 'var-chick-1kg',
          productId: 'prod-chicken-breast',
          label: '1 kg Tray',
          priceCents: 1450, // $14.50 AUD
          weightGrams: 1000,
          isPricedByWeight: true,
          unitOfMeasure: 'kg',
        ),
      ],
    ),
    const Product(
      id: 'prod-basmati-rice',
      storeId: 'store-dhaka-fresh',
      categoryId: 'cat-rice-flour',
      name: 'Daawat Ultima Extra Long Basmati Rice',
      description: 'Aged Himalayan Basmati rice with exquisite aroma and delicate fluffy texture.',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&q=80',
      isHalal: true,
      variants: <ProductVariant>[
        ProductVariant(
          id: 'var-rice-5kg',
          productId: 'prod-basmati-rice',
          label: '5 kg Bag',
          priceCents: 1899, // $18.99 AUD
          weightGrams: 5000,
          isPricedByWeight: false,
          unitOfMeasure: 'bag',
        ),
      ],
    ),
    const Product(
      id: 'prod-shan-biryani',
      storeId: 'store-dhaka-fresh',
      categoryId: 'cat-spices',
      name: 'Shan Special Bombay Biryani Masala',
      description: 'Authentic spice mix for royal fragrant biryani. No artificial preservatives.',
      imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=80',
      isHalal: true,
      variants: <ProductVariant>[
        ProductVariant(
          id: 'var-shan-bombay',
          productId: 'prod-shan-biryani',
          label: '50g Box',
          priceCents: 249, // $2.49 AUD
          weightGrams: 50,
          isPricedByWeight: false,
          unitOfMeasure: 'box',
        ),
      ],
    ),
  ];
}
