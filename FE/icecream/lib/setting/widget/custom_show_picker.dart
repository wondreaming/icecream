import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> CustomShowPicker({
  required Time value,
  required Function(Time) onChange,
}) {
  return showPicker(
      hideButtons: true,
      value: value,
      sunrise: TimeOfDay(hour: 6, minute: 0),
      sunset: TimeOfDay(hour: 18, minute: 0),
      duskSpanInMinutes: 120,
      onChange: onChange,
    );
}
