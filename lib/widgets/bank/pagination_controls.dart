import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget{
  const PaginationControls ({
    super.key,
    required this.currentPage,
    required this.totalRecords,
    required this.pageSize,
    required this.onPrevious,
    required this.onNext
  });

  final int currentPage;
  final int totalRecords;
  final int pageSize;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context){
    if (totalRecords == 0){
      return const SizedBox.shrink();
    }

    final startRecord = currentPage * pageSize + 1;
    final endRecord = ((currentPage + 1) * pageSize).clamp(0, totalRecords);
    final isFirstPage = currentPage == 0;
    final isLastPage = endRecord >= totalRecords;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: isFirstPage ? null: onPrevious, 
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            tooltip: 'Previous',
          ),
          const SizedBox(width: 16),

          Text(
            '$startRecord - $endRecord of $totalRecords',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),

          const SizedBox(width: 16),
          IconButton(
            onPressed: isLastPage ? null: onNext,
             icon: const Icon(Icons.arrow_forward_ios, size: 16),
             tooltip: 'Next',
          ),
        ],
      )
    );

  }
}