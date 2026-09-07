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
    required this.onExportPage,
    required this.onExportAll,
    required this.canExportPage,
    required this.canExportAll,
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
  final VoidCallback onExportPage;
  final VoidCallback onExportAll;
  final bool canExportPage;
  final bool canExportAll;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static const _fieldHeight = 48.0;
  static const _fontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Customer ID, Loan Status, From Date, To Date
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.badge_outlined, size: 18),
                      prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    isExpanded: true,
                    style: const TextStyle(fontSize: _fontSize, color: Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Loan status',
                      labelStyle: TextStyle(fontSize: _fontSize),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: onStatusChanges,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: TextFormField(
                    key: ValueKey('from-$fromDate'),
                    readOnly: true,
                    initialValue: _formatDate(fromDate),
                    onTap: onFromDateTap,
                    style: const TextStyle(fontSize: _fontSize),
                    decoration: const InputDecoration(
                      labelText: 'From Date',
                      labelStyle: TextStyle(fontSize: _fontSize),
                      hintText: 'yyyy-mm-dd',
                      hintStyle: TextStyle(fontSize: _fontSize),
                      hintTextDirection: TextDirection.ltr,
                      suffixIcon: Icon(Icons.calendar_today, size: 14),
                      suffixIconConstraints: BoxConstraints(minWidth: 36, minHeight: 36),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: TextFormField(
                    key: ValueKey('to-$toDate'),
                    readOnly: true,
                    initialValue: _formatDate(toDate),
                    onTap: onToDateTap,
                    style: const TextStyle(fontSize: _fontSize),
                    decoration: const InputDecoration(
                      labelText: 'To Date',
                      labelStyle: TextStyle(fontSize: _fontSize),
                      hintText: 'yyyy-mm-dd',
                      hintStyle: TextStyle(fontSize: _fontSize),
                      suffixIcon: Icon(Icons.calendar_today, size: 14),
                      suffixIconConstraints: BoxConstraints(minWidth: 36, minHeight: 36),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Search, Clear, Export, Export All
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: ElevatedButton(
                    onPressed: onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Search', style: TextStyle(fontSize: _fontSize)),
                        SizedBox(width: 6),
                        Icon(Icons.search, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton(
                    onPressed: onClear,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Clear', style: TextStyle(fontSize: _fontSize)),
                        SizedBox(width: 6),
                        Icon(Icons.clear, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton(
                    onPressed: canExportPage ? onExportPage : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Export', style: TextStyle(fontSize: _fontSize)),
                        SizedBox(width: 6),
                        Icon(Icons.download, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: _fieldHeight,
                  child: OutlinedButton(
                    onPressed: canExportAll ? onExportAll : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Export All', style: TextStyle(fontSize: _fontSize)),
                        SizedBox(width: 6),
                        Icon(Icons.download, size: 16),
                      ],
                    ),
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