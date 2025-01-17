import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map(
            (data) {
              Color indexColor = (data['user_answer'] as String) ==
                      (data['correct_answer'] as String)
                  ? const Color.fromARGB(255, 186, 76, 190)
                  : const Color.fromARGB(255, 40, 152, 208);
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8), // Add some padding
                    decoration: BoxDecoration(
                      color: indexColor,
                      shape: BoxShape.circle, // Make the shape circular
                    ),
                    child: Text(
                      ((data['question_index'] as int) + 1).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['question'] as String),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          data['user_answer'] as String,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 186, 76, 190),
                          ),
                        ),
                        Text(
                          data['correct_answer'] as String,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 40, 152, 208),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
