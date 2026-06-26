import 'package:flutter/material.dart';
import '../models/subscription.dart';

class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const dark = Color(0xFF1F2937);
  static const gray = Color(0xFF6B7280);
  static const lightGray = Color(0xFFF3F4F6);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

extension SubCategoryExtension on SubCategory {
  String get label {
    switch (this) {
      case SubCategory.entertainment:
        return 'Entertainment';
      case SubCategory.productivity:
        return 'Productivity';
      case SubCategory.health:
        return 'Health';
      case SubCategory.finance:
        return 'Finance';
      case SubCategory.shopping:
        return 'Shopping';
      case SubCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case SubCategory.entertainment:
        return Icons.movie;
      case SubCategory.productivity:
        return Icons.work;
      case SubCategory.health:
        return Icons.favorite;
      case SubCategory.finance:
        return Icons.account_balance;
      case SubCategory.shopping:
        return Icons.shopping_bag;
      case SubCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case SubCategory.entertainment:
        return Colors.red;
      case SubCategory.productivity:
        return Colors.blue;
      case SubCategory.health:
        return Colors.green;
      case SubCategory.finance:
        return Colors.amber;
      case SubCategory.shopping:
        return Colors.purple;
      case SubCategory.other:
        return Colors.grey;
    }
  }
}

extension BillingCycleExtension on BillingCycle {
  String get label {
    switch (this) {
      case BillingCycle.weekly:
        return 'Weekly';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }
}