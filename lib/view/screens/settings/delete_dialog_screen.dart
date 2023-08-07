import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/view/widgets/delete_dialog.dart';

class DeleteDialogScreen extends ConsumerStatefulWidget {
  const DeleteDialogScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteDialogScreenState();
}

class _DeleteDialogScreenState extends ConsumerState<DeleteDialogScreen> {
  @override
  void initState() {
    deleteDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
