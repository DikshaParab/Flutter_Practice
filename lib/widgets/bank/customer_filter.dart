import 'package:flutter/material.dart';

class CustomerFilter extends StatelessWidget {
  const CustomerFilter({
    super.key,
    required this.customerIdController,
    required this.fromDate,
    required this.toDate,
    required this.selectedStatus,
    required this.statusOptions,
    required this.onFromDateTap,
    required this.onToDateTap,
    required this.onStatusChanges,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController customerIdController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? selectedStatus;
  final List<String> statusOptions;
  final VoidCallback onFromDateTap;
  final VoidCallback onToDateTap;
  final ValueChanged<String?> onStatusChanges;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static const _fieldHeight = 40.0;
  static const _fontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Customer ID + Loan Status
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: TextField(
                    controller: customerIdController,
                    style: const TextStyle(fontSize: _fontSize),
                    decoration: const InputDecoration(
                      labelText: 'Customer ID',
                      labelStyle: TextStyle(fontSize: _fontSize),
                      prefixIcon: Icon(Icons.badge_outlined, size: 18),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    style: const TextStyle(fontSize: _fontSize, color: Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Loan status',
                      labelStyle: TextStyle(fontSize: _fontSize),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: onStatusChanges,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: From Date + To Date
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton.icon(
                    onPressed: onFromDateTap,
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: Text(
                      'From: ${_formatDate(fromDate)}',
                      style: const TextStyle(fontSize: _fontSize),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton.icon(
                    onPressed: onToDateTap,
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: Text(
                      'To: ${_formatDate(toDate)}',
                      style: const TextStyle(fontSize: _fontSize),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 3: Search + Clear
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: ElevatedButton.icon(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Search', style: TextStyle(fontSize: _fontSize)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear', style: TextStyle(fontSize: _fontSize)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}