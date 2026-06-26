import 'package:uuid/uuid.dart';

enum BillingCycle { weekly, monthly, yearly }

enum SubCategory {
  entertainment,
  productivity,
  health,
  finance,
  shopping,
  other
}

class Subscription {
  final String id;
  final String name;
  final double amount;
  final BillingCycle billingCycle;
  final SubCategory category;
  final DateTime startDate;
  final DateTime? nextBillingDate;
  final String? description;
  final String? iconUrl;
  final bool isActive;

  Subscription({
    String? id,
    required this.name,
    required this.amount,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    this.nextBillingDate,
    this.description,
    this.iconUrl,
    this.isActive = true,
  }) : id = id ?? const Uuid().v4();

  double get monthlyCost {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 4.33;
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.yearly:
        return amount / 12;
    }
  }

  double get yearlyCost {
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 52;
      case BillingCycle.monthly:
        return amount * 12;
      case BillingCycle.yearly:
        return amount;
    }
  }

  Subscription copyWith({
    String? name,
    double? amount,
    BillingCycle? billingCycle,
    SubCategory? category,
    DateTime? startDate,
    DateTime? nextBillingDate,
    String? description,
    String? iconUrl,
    bool? isActive,
  }) {
    return Subscription(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'billingCycle': billingCycle.index,
      'category': category.index,
      'startDate': startDate.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'description': description,
      'iconUrl': iconUrl,
      'isActive': isActive,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      billingCycle: BillingCycle.values[json['billingCycle']],
      category: SubCategory.values[json['category']],
      startDate: DateTime.parse(json['startDate']),
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.parse(json['nextBillingDate'])
          : null,
      description: json['description'],
      iconUrl: json['iconUrl'],
      isActive: json['isActive'],
    );
  }
}