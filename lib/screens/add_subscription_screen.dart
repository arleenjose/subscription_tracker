import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../utils/constants.dart';

class AddSubscriptionScreen extends StatefulWidget {
  final Subscription? subscription;

  const AddSubscriptionScreen({super.key, this.subscription});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  BillingCycle _billingCycle = BillingCycle.monthly;
  SubCategory _category = SubCategory.entertainment;
  DateTime _startDate = DateTime.now();
  DateTime? _nextBillingDate;

  @override
  void initState() {
    super.initState();
    if (widget.subscription != null) {
      _nameController.text = widget.subscription!.name;
      _amountController.text = widget.subscription!.amount.toString();
      _descriptionController.text = widget.subscription!.description ?? '';
      _billingCycle = widget.subscription!.billingCycle;
      _category = widget.subscription!.category;
      _startDate = widget.subscription!.startDate;
      _nextBillingDate = widget.subscription!.nextBillingDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subscription != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Subscription' : 'Add Subscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Subscription Name',
                  prefixIcon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Billing Cycle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SegmentedButton<BillingCycle>(
                segments: BillingCycle.values.map((cycle) {
                  return ButtonSegment(
                    value: cycle,
                    label: Text(cycle.label),
                  );
                }).toList(),
                selected: {_billingCycle},
                onSelectionChanged: (Set<BillingCycle> newSelection) {
                  setState(() {
                    _billingCycle = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: SubCategory.values.map((cat) {
                  final isSelected = _category == cat;
                  return ChoiceChip(
                    avatar: Icon(
                      cat.icon,
                      size: 18,
                      color: isSelected ? Colors.white : cat.color,
                    ),
                    label: Text(cat.label),
                    selected: isSelected,
                    selectedColor: cat.color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _category = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start Date'),
                subtitle: Text(DateFormat('MMM d, yyyy').format(_startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Next Billing Date (Optional)'),
                subtitle: Text(
                  _nextBillingDate != null
                      ? DateFormat('MMM d, yyyy').format(_nextBillingDate!)
                      : 'Not set',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _nextBillingDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _nextBillingDate = date);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _saveSubscription,
                  child: Text(
                    isEditing ? 'Update Subscription' : 'Add Subscription',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSubscription() {
    if (!_formKey.currentState!.validate()) return;

    final subscription = Subscription(
      id: widget.subscription?.id,
      name: _nameController.text,
      amount: double.parse(_amountController.text),
      billingCycle: _billingCycle,
      category: _category,
      startDate: _startDate,
      nextBillingDate: _nextBillingDate,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
    );

    final provider = context.read<SubscriptionProvider>();

    if (widget.subscription != null) {
      provider.updateSubscription(subscription);
    } else {
      provider.addSubscription(subscription);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}