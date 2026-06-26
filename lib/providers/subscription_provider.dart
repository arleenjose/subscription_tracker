import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  SharedPreferences? _prefs;

  List<Subscription> get subscriptions => _subscriptions;

  List<Subscription> get activeSubscriptions =>
      _subscriptions.where((s) => s.isActive).toList();

  double get totalMonthlyCost =>
      activeSubscriptions.fold(0, (sum, s) => sum + s.monthlyCost);

  double get totalYearlyCost =>
      activeSubscriptions.fold(0, (sum, s) => sum + s.yearlyCost);

  Map<SubCategory, double> get spendingByCategory {
    final Map<SubCategory, double> map = {};
    for (final sub in activeSubscriptions) {
      map[sub.category] = (map[sub.category] ?? 0) + sub.monthlyCost;
    }
    return map;
  }

  SubscriptionProvider() {
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    _prefs = await SharedPreferences.getInstance();
    final String? data = _prefs?.getString('subscriptions');
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      _subscriptions = jsonList.map((j) => Subscription.fromJson(j)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveSubscriptions() async {
    final String data = json.encode(
      _subscriptions.map((s) => s.toJson()).toList(),
    );
    await _prefs?.setString('subscriptions', data);
  }

  Future<void> addSubscription(Subscription subscription) async {
    _subscriptions.add(subscription);
    await _saveSubscriptions();
    notifyListeners();
  }

  Future<void> updateSubscription(Subscription subscription) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
    if (index != -1) {
      _subscriptions[index] = subscription;
      await _saveSubscriptions();
      notifyListeners();
    }
  }

  Future<void> deleteSubscription(String id) async {
    _subscriptions.removeWhere((s) => s.id == id);
    await _saveSubscriptions();
    notifyListeners();
  }

  Future<void> toggleSubscriptionStatus(String id) async {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _subscriptions[index] = _subscriptions[index].copyWith(
        isActive: !_subscriptions[index].isActive,
      );
      await _saveSubscriptions();
      notifyListeners();
    }
  }

  List<Subscription> getUpcomingRenewals(int days) {
    final now = DateTime.now();
    return activeSubscriptions.where((s) {
      if (s.nextBillingDate == null) return false;
      final diff = s.nextBillingDate!.difference(now).inDays;
      return diff >= 0 && diff <= days;
    }).toList();
  }
}