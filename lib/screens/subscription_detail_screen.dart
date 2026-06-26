import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../utils/constants.dart';
import 'add_subscription_screen.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailScreen({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(subscription.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      subscription.category.color,
                      subscription.category.color.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    subscription.category.icon,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Amount',
                          currencyFormat.format(subscription.amount),
                          isHighlighted: true,
                        ),
                        const Divider(),
                        _buildInfoRow('Billing Cycle', subscription.billingCycle.label),
                        const Divider(),
                        _buildInfoRow('Category', subscription.category.label),
                        const Divider(),
                        _buildInfoRow(
                          'Monthly Cost',
                          currencyFormat.format(subscription.monthlyCost),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Yearly Cost',
                          currencyFormat.format(subscription.yearlyCost),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Start Date',
                          DateFormat('MMM d, yyyy').format(subscription.startDate),
                        ),
                        if (subscription.nextBillingDate != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            'Next Billing',
                            DateFormat('MMM d, yyyy').format(subscription.nextBillingDate!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (subscription.description != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subscription.description!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddSubscriptionScreen(
                                subscription: subscription,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Subscription'),
                                content: const Text(
                                  'Are you sure you want to delete this subscription?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.danger,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlighted ? 24 : 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}