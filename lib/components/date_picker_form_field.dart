import 'package:deans_dinners/models/entry.dart';
import 'package:flutter/material.dart';

class DatePickerFormField extends StatefulWidget {
  final Entry entry;
  const DatePickerFormField({Key? key, required this.entry}) : super(key: key);

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.entry.date;
  }

  Future pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: widget.entry.date,
        firstDate: DateTime(widget.entry.date.year - 5),
        lastDate: DateTime(widget.entry.date.year + 5));

    if (pickedDate == null) return;
    setState(() => selectedDate = pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
            text:
                '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
        onTap: () => pickDate(context),
        decoration: const InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          widget.entry.date = selectedDate;
        },
      ),
    );
  }
}
