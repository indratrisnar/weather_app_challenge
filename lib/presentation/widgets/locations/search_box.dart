import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  SearchBox({
    super.key,
    this.searchFocus,
    this.onChanged,
    required this.onClose,
  });
  final edtSearch = TextEditingController();
  final FocusNode? searchFocus;
  final void Function(String query)? onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey.shade100),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.blueGrey),
            ),
            DView.width(12),
            Expanded(
              child: TextField(
                controller: edtSearch,
                focusNode: searchFocus,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  hintText: 'Find city',
                  hintStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: onChanged,
              ),
            ),
            DButtonBorder(
              height: 36,
              width: 36,
              radius: 36,
              borderWidth: 1,
              borderColor: Colors.blueGrey.shade100,
              mainColor: Colors.transparent,
              child: const Icon(Icons.clear, color: Colors.blueGrey),
              onClick: () {
                edtSearch.clear();
                onClose();
              },
            ),
          ],
        ),
      ),
    );
  }
}
