import 'dart:ui';

import 'package:flutter/material.dart';

import '../helper/helper.dart';

class UniversityLocation {
  String assetImage;
  String name;
  int numOfUni;

  UniversityLocation(this.assetImage, this.name, this.numOfUni);
}

class StudyAbroad extends StatelessWidget {
  final UniversityLocation location;

  const StudyAbroad({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(location.assetImage),
          fit: BoxFit.fill,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: appWidth(context) / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.black12,
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sText(location.name,
                          weight: FontWeight.bold,
                          size: 12,
                          color: Colors.white),
                      SizedBox(
                        height: appHeight(context) * 0.001,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.school,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appWidth(context) * 0.02,
                          ),
                          sText("${location.numOfUni}+ Universities",
                              weight: FontWeight.w500,
                              size: 10,
                              color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
