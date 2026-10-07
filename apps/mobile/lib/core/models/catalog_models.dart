/// Models representing the core store, category, and product entities
/// in the Grocerra / Sogrow marketplace.
///
/// Money is strictly handled in integer AUD cents across all models.
library;

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.abn,
    required this.kind,
    required this.isHalalCertified,
    required this.rating,
    required this.reviewCount,
    required this.deliveryEtaMinutes,
    required this.deliveryFeeCents,
    required this.heroImageUrl,
    required this.cuisines,
    required this.suburb,
    required this.addressLine,
    this.distanceKm,
    this.minimumOrderCents = 0,
    this.isOpen = true,
  });

  final String id;
  final String name;
  final String abn;
  final String kind; // 'grocery', 'butcher', 'caterer', 'sweets'
  final bool isHalalCertified;
  final double rating;
  final int reviewCount;
  final int deliveryEtaMinutes;
  final int deliveryFeeCents;
  final String heroImageUrl;
  final List<String> cuisines; // ['Pakistani', 'Indian', 'Bangladeshi', etc.]
  final String suburb;
  final String addressLine;
  final double? distanceKm;
  final int minimumOrderCents;
  final bool isOpen;

  String get formattedDeliveryFee => deliveryFeeCents == 0
      ? 'Free delivery'
      : '\$${(deliveryFeeCents / 100).toStringAsFixed(2)} delivery';

  String get formattedMinOrder => minimumOrderCents == 0
      ? 'No minimum'
      : 'Min \$${(minimumOrderCents / 100).toStringAsFixed(2)}';

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      abn: json['abn'] as String? ?? '',
      kind: json['kind'] as String? ?? 'grocery',
      isHalalCertified: json['halal_certified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 120,
      deliveryEtaMinutes: (json['delivery_eta_minutes'] as num?)?.toInt() ?? 35,
      deliveryFeeCents: (json['delivery_fee_cents'] as num?)?.toInt() ?? 499,
      heroImageUrl: json['hero_image_url'] as String? ?? '',
      cuisines: (json['cuisines'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          <String>[],
      suburb: json['suburb'] as String? ?? 'Melbourne',
      addressLine: json['address_line'] as String? ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      minimumOrderCents: (json['minimum_order_cents'] as num?)?.toInt() ?? 0,
      isOpen: json['status'] == 'active' || json['is_open'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'abn': abn,
      'kind': kind,
      'halal_certified': isHalalCertified,
      'rating': rating,
      'review_count': reviewCount,
      'delivery_eta_minutes': deliveryEtaMinutes,
      'delivery_fee_cents': deliveryFeeCents,
      'hero_image_url': heroImageUrl,
      'cuisines': cuisines,
      'suburb': suburb,
      'address_line': addressLine,
      'distance_km': distanceKm,
      'minimum_order_cents': minimumOrderCents,
      'is_open': isOpen,
    };
  }
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconName,
    this.description = 'Fresh and halal essentials',
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String slug;
  final String iconName;
  final String description;
  final int sortOrder;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'grid_view',
      sortOrder: (json['sort'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.label,
    required this.priceCents,
    this.weightGrams,
    this.isPricedByWeight = false,
    this.unitOfMeasure = 'each',
  });

  final String id;
  final String productId;
  final String label;
  final int priceCents;
  final int? weightGrams;
  final bool isPricedByWeight; // Catch-weight flag: pre-auth +10%
  final String unitOfMeasure; // 'kg', 'g', 'pack', 'each'

  String get formattedPrice => '\$${(priceCents / 100).toStringAsFixed(2)}';

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      productId: json['product_id'] as String? ?? '',
      label: json['label'] as String? ?? 'Standard',
      priceCents: (json['price_cents'] as num?)?.toInt() ?? 0,
      weightGrams: (json['weight_grams'] as num?)?.toInt(),
      isPricedByWeight: json['priced_by_weight'] as bool? ?? false,
      unitOfMeasure: json['unit_of_measure'] as String? ?? 'each',
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.storeId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isHalal = true,
    this.isVegetarian = false,
    this.storeName = 'Local Grocer',
    this.allergens = const <String>[],
    this.variants = const <ProductVariant>[],
  });

  final String id;
  final String storeId;
  final String storeName;
  final String categoryId;
  final String name;
  final String description;
  final String imageUrl;
  final bool isHalal;
  final bool isVegetarian;
  final List<String> allergens;
  final List<ProductVariant> variants;

  ProductVariant? get defaultVariant =>
      variants.isNotEmpty ? variants.first : null;

  String get formattedPrice => defaultVariant != null
      ? defaultVariant!.formattedPrice
      : '\$0.00';

  bool get isCatchWeight =>
      variants.any((ProductVariant v) => v.isPricedByWeight);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      categoryId: json['category_id'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      isHalal: json['is_halal'] as bool? ?? true,
      isVegetarian: json['is_vegetarian'] as bool? ?? false,
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          <String>[],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((dynamic v) =>
                  ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList() ??
          <ProductVariant>[],
    );
  }
}
