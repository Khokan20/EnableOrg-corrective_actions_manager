import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/dto/questionList_and_qnid_DTO.dart';
import 'package:enableorg/models/question_answer.dart';
import 'package:enableorg/models/user.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../controller/user/wellness_builder_controller.dart';
import '../../models/question.dart';

class WellnessBuilderPage extends StatefulWidget {
  final User user;

  WellnessBuilderPage({required this.user});

  @override
  State<WellnessBuilderPage> createState() => _WellnessBuilderPageState();
}

class _WellnessBuilderPageState extends State<WellnessBuilderPage> {
  late WellnessBuilderController controller;
  late Future<QuestionListAndQnidDTO> questionsFuture;
  int currentPageIndex = 0;
  int currentQuestionIndex = 0;
  List<int> questionResponses =
      List.filled(1000, 3); // TODO: Constants file for WB num questions

  @override
  void initState() {
    super.initState();
    controller = WellnessBuilderController(currentUser: widget.user);
    questionsFuture = controller.getQuestions(widget.user);
  }

  void onNextPressed() async {
    QuestionListAndQnidDTO questionsAndQnid = await questionsFuture;
    List<Question> questions = questionsAndQnid.qList;
    String? qnid = questionsAndQnid.qnid;
    if (currentPageIndex < questions.length ~/ 12 + 1) {
      List<Question> currentPageQuestions = questions.sublist(
        currentPageIndex * 12,
        min((currentPageIndex + 1) * 12, questions.length),
      );

      List<int> currentPageResponses = questionResponses.sublist(
        currentPageIndex * 12,
        min((currentPageIndex + 1) * 12, questions.length),
      );

      List<QuestionAnswer> questionAnswers = [];

      for (var i = 0; i < currentPageQuestions.length; i++) {
        var question = currentPageQuestions[i];
        var answer = currentPageResponses[i];

        QuestionAnswer questionAnswer = QuestionAnswer(
          qnid: qnid!,
          qaid: randomAlpha(30),
          creationTimestamp: Timestamp.now(),
          answer: answer,
          qid: question.qid,
          uid: widget.user.uid,
        );

        questionAnswers.add(questionAnswer);
      }

      await controller.saveAndNext(questionAnswers);
    }
    setState(() {
      currentPageIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Builder'),
      ),
      body: FutureBuilder<QuestionListAndQnidDTO>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No questions available.'),
            );
          } else {
            QuestionListAndQnidDTO questionsAndQnid = snapshot.data!;
            List<Question> questions = questionsAndQnid.qList;
            // questionResponses = List<int>.filled(questions.length, 4);
            List<Question> currentPageQuestions;
            if (currentPageIndex * 12 <= questions.length) {
              currentPageQuestions = questions.sublist(
                currentPageIndex * 12,
                min((currentPageIndex + 1) * 12, questions.length),
              );
            } else {
              currentPageQuestions = [];
            }

            Widget pageContent;

            if (currentPageQuestions.isEmpty) {
              pageContent = Center(
                child: Text(
                  'No questions available. You have completed all your questions :)',
                ),
              );
            } else {
              pageContent = ListView.builder(
                itemCount: currentPageQuestions.length,
                itemBuilder: (context, index) {
                  Question question = currentPageQuestions[index];
                  int questionIndex = currentPageIndex * 12 + index;

                  return Column(
                    children: [
                      Text(question.question),
                      Slider(
                        value: questionResponses[questionIndex].toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            questionResponses[questionIndex] = value.toInt();
                          });
                        },
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: questionResponses[questionIndex].toString(),
                      ),
                    ],
                  );
                },
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: pageContent,
                  ),
                ),
                if (currentPageQuestions.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: onNextPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 12, 67, 111),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
