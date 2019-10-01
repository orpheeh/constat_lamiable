import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class DegatIndicator extends StatefulWidget {
  final FormRepository formRepository;

  const DegatIndicator({Key key, this.formRepository}) : super(key: key);

  @override
  _DegatIndicatorState createState() => _DegatIndicatorState();
}

class _DegatIndicatorState extends State<DegatIndicator> {
  @override
  Widget build(BuildContext context) {
    return widget.formRepository.currentCarIndex >= 0
        ? Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  widget.formRepository
                      .carTypes[widget.formRepository.currentCarIndex].asset,
                  width: 200,
                  height: 200,
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.BOTTOM_RIGHT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_bottom_right.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.BOTTOM_RIGHT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.BOTTOM;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_bottom.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.BOTTOM
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.BOTTOM_LEFT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_bottom_left.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.BOTTOM_LEFT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.RIGHT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 200,
                          child: Image.asset(
                            "assets/images/arrow_right.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.RIGHT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Color(0xff0000),
                            border:
                                Border.all(width: 1.0, color: Colors.black)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.LEFT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 200,
                          child: Image.asset(
                            "assets/images/arrow_left.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.LEFT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.TOP_RIGHT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_top_right.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.TOP_RIGHT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.TOP;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_top.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.TOP
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.formRepository.degat.chocInitial =
                                ChocInitial.TOP_LEFT;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/arrow_top_left.png",
                            width: 50,
                            height: 50,
                          ),
                          decoration: BoxDecoration(
                              color: widget.formRepository.degat.chocInitial ==
                                      ChocInitial.TOP_LEFT
                                  ? Color.fromARGB(128, 255, 0, 0)
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        : Center(child: Text("Choisissez un vehicule"));
  }
}
