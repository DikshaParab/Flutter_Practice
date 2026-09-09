import 'package:flutter/material.dart';
import 'package:demo/widgets/my_app_bar.dart';
import 'package:demo/widgets/logout_button.dart';
import 'package:demo/services/customer_service.dart';
import 'package:demo/pages/login_page.dart';
import 'package:demo/services/excel_export_service.dart';
import 'package:demo/widgets/bank/customer_filter.dart';
import 'package:demo/widgets/bank/customer_table.dart';
import 'package:demo/widgets/bank/pagination_controls.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _customerIDController = TextEditingController();

  static const _statusOptions = ['All', 'Approved', 'Pending', 'Rejected'];

  List<Map<String, dynamic>> _allCustomers = [];
  List<Map<String, dynamic>> _filterCustomers = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedStatus;
  bool _isLoading = true;
  bool _hasSearched = false;

  static const _pageSize = 5;
  int _currentPage = 0;

  List<Map<String, dynamic>> get _pageCustomers {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _filterCustomers.length);
    if (start >= _filterCustomers.length) return [];
    return _filterCustomers.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _toDate = now;
    _fromDate = DateTime(now.year, now.month - 1, now.day);
    _loadCustomers();
  }

  @override
  void dispose() {
    _customerIDController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    final customers = await CustomerService.loadCustomers();
    if (!mounted) return;
    setState(() {
      _allCustomers = customers;
      _filterCustomers = [];
      _isLoading = false;
    });
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime(2026, 1, 1),
      firstDate: DateTime(2020),
      lastDate: _toDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _applyFilters() {
    final query = _customerIDController.text.trim().toLowerCase();

    setState(() {
      _hasSearched = true;
      _currentPage = 0;
      _filterCustomers = _allCustomers.where((customer) {
        final cust_id = (customer['customer_id'] as String).toLowerCase();
        final date = customer['parsedDate'] as DateTime;
        final status = customer['loan_status'] as String;

        final matchesID = query.isEmpty || cust_id.contains(query);

        final matchesFrom = _fromDate == null || !date.isBefore(_fromDate!);
        final matchesTo = _toDate == null || !date.isAfter(_toDate!);

        final matchesStatus =
            _selectedStatus == null ||
            _selectedStatus == 'All' ||
            status == _selectedStatus;

        return matchesID && matchesFrom && matchesTo && matchesStatus;
      }).toList();
    });
  }

  void _clearFilters() {
    final now = DateTime.now();
    setState(() {
      _customerIDController.clear();
      _fromDate = DateTime(now.year, now.month - 1, now.day);
      _toDate = now;
      _selectedStatus = 'All';
      _filterCustomers = _allCustomers;
      _hasSearched = false;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(
          title: const Text(''),
          action: LogoutButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPageApp()),
              );
            },
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back to dashboard',
                      ),
                      Text(
                        'Customer Transactions',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                CustomerFilter(
                  customerIdController: _customerIDController,
                  fromDate: _fromDate,
                  toDate: _toDate,
                  selectedStatus: _selectedStatus,
                  statusOptions: _statusOptions,
                  onFromDateTap: _pickFromDate,
                  onToDateTap: _pickToDate,
                  onStatusChanges: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  onSearch: _applyFilters,
                  onClear: _clearFilters,
                  canExportPage: _hasSearched && _pageCustomers.isNotEmpty,
                  canExportAll: _hasSearched && _filterCustomers.isNotEmpty,
                  onExportPage: () {
                    ExcelExportService.exportCustomers(
                      _pageCustomers,
                      filename: 'page_customers.xlsx',
                    );
                  },
                  onExportAll: () {
                    ExcelExportService.exportCustomers(
                      _filterCustomers,
                      filename: 'all_customers.xlsx',
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _hasSearched
                          ? 'Total records: ${_filterCustomers.length}'
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(height: 3),
                Expanded(
                  child: _hasSearched
                      ? CustomerTable(customers: _pageCustomers)
                      : const SizedBox.shrink(),
                ),
                if (_hasSearched)
                  PaginationControls(
                    currentPage: _currentPage,
                    totalRecords: _filterCustomers.length,
                    pageSize: _pageSize,
                    onPrevious: () {
                      setState(() {
                        _currentPage -= 1;
                      });
                    },
                    onNext: () {
                      setState(() {
                        _currentPage += 1;
                      });
                    },
                  ),
              ],
            ),
    );
  }
}
