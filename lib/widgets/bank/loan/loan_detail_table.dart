  import 'package:flutter/material.dart';
  import 'package:demo/services/loan_type_service.dart';
  import 'package:demo/services/loan_edit_storage.dart';
  import 'package:demo/widgets/bank/loan/loan_subtype_dd.dart';
  import 'package:demo/widgets/bank/loan/loan_type_dd.dart';
  import 'package:demo/widgets/bank/loan/loan_status_dd.dart';
  import 'package:demo/widgets/bank/loan/loan_status_updated.dart';
  import 'package:demo/widgets/bank/loan/remarks_field.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:demo/widgets/bank/loan/loan_updated_summary_table.dart';

  class LoanDetailPanel extends StatefulWidget {
    const LoanDetailPanel({super.key, required this.customer, required this.onSaved});
    final Map<String, dynamic> customer;
    final ValueChanged<Map<String, dynamic>> onSaved;

    @override 
    State<LoanDetailPanel> createState() => _LoanDetailPanelState();
  }

  class _LoanDetailPanelState extends State<LoanDetailPanel>{
    Map<String, dynamic>? _lastSavedCustomer;
    final _formKey = GlobalKey<FormState>();
    static const _statusOptions = ['Approved', 'Pending', 'Rejected'];

    List<LoanTypeOption> _loanTypes = [];
    bool _isLoading = true;
    bool _isSaving = false;

    late String _selectedType;
    late String _selectedSubType;
    late String _selectedStatus;
    late TextEditingController _remarksController;
    late String _statusUpdatedDate;
    late String _originalStatus;

    @override
    void initState(){
      super.initState();
      _selectedType = widget.customer['loan_type'] as String;
      _selectedSubType = widget.customer['loan_subtype'] as String;
      _selectedStatus = widget.customer['loan_status'] as String;
      _originalStatus = _selectedStatus;
      _remarksController = TextEditingController(text: widget.customer['remarks'] as String);
      _statusUpdatedDate = widget.customer['status_updated_date'] as String;
      _loadLoanTypes();
    }

    @override
    void didUpdateWidget(covariant LoanDetailPanel oldWidget){
      super.didUpdateWidget(oldWidget);
      if(oldWidget.customer['customer_id'] != widget.customer['customer_id']){
      _selectedType = widget.customer['loan_type'] as String;
      _selectedSubType = widget.customer['loan_subtype'] as String;
      _selectedStatus = widget.customer['loan_status'] as String;
      _originalStatus = _selectedStatus;
      _remarksController.text = widget.customer['remarks'] as String? ?? '';
      _statusUpdatedDate = widget.customer['status_updated_date'] as String;
      _loadLoanTypes();
      }
    }

    @override
    void dispose(){
      _remarksController.dispose();
      super.dispose();
    }

    Future<void> _loadLoanTypes() async{
      final types = await LoanTypeService.loadLoanTypes();
      if(!mounted) return;
      setState(() {
        _loanTypes = types;
        _isLoading = false;
      });
    }

    List<String> get _subtypeforSelected{
      final match = _loanTypes.where((t) => t.name == _selectedType);
      if (match.isEmpty) return [];
      return match.first.subtypes.map((s) => s.name).toList();
    }

    String _todayFormatted(){
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }

    Future<void> _handleSave() async {
      setState(() => _isSaving = true);

      try {
        final statusChanged = _selectedStatus != _originalStatus;
        if (statusChanged) {
          _statusUpdatedDate = _todayFormatted();
        }

        final edit = {
          'loan_type': _selectedType,
          'loan_subtype': _selectedSubType,
          'loan_status': _selectedStatus,
          'remarks': _remarksController.text,
          'status_updated_date': _statusUpdatedDate,
        };

        await LoanEditStorage.saveEdit(widget.customer['customer_id'] as String, edit);

        if (!mounted) return;

        _originalStatus = _selectedStatus;
        final updatedCustomer = {...widget.customer, ...edit};
        widget.onSaved(updatedCustomer);

        setState(() {
          _lastSavedCustomer = updatedCustomer;
        });

        Fluttertoast.showToast(
          msg: 'Loan details updated.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green[700],
          textColor: Colors.white,
          fontSize: 16,
        );
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Failed to save changes. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red[700],
            textColor: Colors.white,
            fontSize: 16,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }

    @override
    Widget build(BuildContext context){
      if(_isLoading) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final subtypeNames = _subtypeforSelected;
      final safesubtype = subtypeNames.contains(_selectedSubType)
        ? _selectedSubType
        : (subtypeNames.isNotEmpty ? subtypeNames.first: null);

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Loan Details', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LoanTypeDd(
                      value: _selectedType,
                      items: _loanTypes.map((t) => t.name).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedType = value;
                          final newSubtypes = _loanTypes.firstWhere((t) => t.name == value).subtypes;
                          _selectedSubType = newSubtypes.isNotEmpty ? newSubtypes.first.name : '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: LoanSubtypeDd(
                      value: safesubtype,
                      items: subtypeNames,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedSubType = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: LoanStatusDropdown(
                      value: _selectedStatus,
                      items: _statusOptions,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedStatus = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: StatusUpdatedField(value: _statusUpdatedDate)),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: RemarksField(controller: _remarksController)),
                ],
              ),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                  :const Text('Save Changes'),
                ),
              ),
              
              if (_lastSavedCustomer != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: LoanUpdatedSummaryTable(customer: _lastSavedCustomer!),
                ),
              ],
            ],
          ),
        )
      );  
    }
  }





