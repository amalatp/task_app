import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onTap;
  const DateSelector(
      {super.key, required this.selectedDate, required this.onTap});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final weekDays = generateWeekDates(weekOffset);
    String monthName = DateFormat("MMMM").format(weekDays.first);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset--;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Text(monthName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset++;
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                final day = weekDays.elementAt(index);
                final date = DateFormat("d").format(day);
                final weekday = DateFormat("E").format(day);
                bool isSelected =
                    DateFormat("d").format(widget.selectedDate) == date &&
                        widget.selectedDate.month == day.month &&
                        widget.selectedDate.year == day.year;

                return GestureDetector(
                  onTap: () => widget.onTap(day),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrange : null,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isSelected ? Colors.deepOrange : Colors.grey,
                            width: 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(date,
                            style: TextStyle(
                                color: isSelected ? Colors.white : null,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(weekday,
                            style: TextStyle(
                                color: isSelected ? Colors.white : null,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
