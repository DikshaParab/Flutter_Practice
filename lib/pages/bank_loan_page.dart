import 'package:flutter/material.dart';
import 'package:demo/widgets/my_app_bar.dart';
import 'package:demo/widgets/logout_button.dart';
import 'package:demo/pages/login_page.dart';
import 'package:demo/widgets/bank/loan/loan_search_bar.dart';
import 'package:demo/widgets/bank/loan/loan_detail_table.dart';
import 'package:demo/widgets/bank/loan/loan_summary_bar.dart';
import 'package:demo/services/loan_detail_service.dart';

class BankLoanPage extends StatefulWidget {
  const BankLoanPage({super.key, required this.username});
  final String username;

  @override
  State<BankLoanPage> createState() => _BankLoanPageState();
}

class _BankLoanPageState extends State<BankLoanPage>{
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _allCustomers = [];
  Map<String, dynamic>? _selectedCustomer;
  bool _isLoading = true;
  bool _hasSearched = false;
  String? _error;

  @override
  void initState(){
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
  }

  Future<void> _loadCustomers() async{
    final customers = await LoanDetailService.loadLoanDetails();
    if (!mounted) return;
    setState(() {
      _allCustomers = customers;
      _isLoading = false;
    });
  }

  void _search(){
    final query = _searchController.text.trim().toUpperCase();

    setState(() {
      _hasSearched = true;

      if (query.isEmpty) {
        _selectedCustomer = null;
        _error = 'Please enter customer ID/ account number!';
        return;
      }

      final matches = _allCustomers.where((c)
        {
          final custId = (c['customer_id'] as String).toUpperCase();
          final accountNo = (c['account_number'] as String).toUpperCase();
          return custId == query || accountNo == query;
        },
      );

      if(matches.isEmpty){
      _selectedCustomer = null;
      _error = 'No customer found for "${_searchController.text.trim()}".';
      } else {
        _selectedCustomer = matches.first;
        _error = null;
      }
    });
  }

  void _clearSearch(){
    setState(() {
      _searchController.clear();
      _selectedCustomer = null;
      _hasSearched = false;
      _error = null;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      'Service Request Details',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              LoanSearchBar(controller: _searchController, onSearch: _search, onClear: _clearSearch),
              const Divider(height: 8),
              if(_hasSearched && _error != null)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red[700],fontSize: 15),
                  ),
                ),
              if (_selectedCustomer != null) ...[
                LoanSummaryBar(customer: _selectedCustomer!),
                Expanded(
                  child: SingleChildScrollView(
                    child: LoanDetailPanel(customer: _selectedCustomer!),
                  ),
                )
              ] else if (!_hasSearched)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Search a Customer ID or Account Number to view loan details.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ))
            ],
        )
    );
  }
}