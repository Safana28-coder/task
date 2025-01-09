import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ColorConst.dart';
import 'package:task/ImageConst.dart';
import 'package:task/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ProjectTask extends StatefulWidget {
  const ProjectTask({super.key});

  @override
  State<ProjectTask> createState() => _ProjectTaskState();
}

class _ProjectTaskState extends State<ProjectTask> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<String> originSuggestions = [];
  List<String> destinationSuggestions = [];
  bool isCheckedDestination=false;
  bool isCheckedPort=false;
  bool FCL=false;
  bool LCL=false;
  DateTime? _selectedDate;
  TextEditingController dateController=TextEditingController();
  final List<String> items = [
    "test1",
    "test2",
    "test3",
    "test4",
    "test5",
  ];
  final List<String> items1 = [
    "40'",
    "30'",
    "60'",
    "70'",
    "100'",
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Start date for date selection
      lastDate: DateTime.now(), // Ensure the date cannot be in the future
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate); // Format the date
      });
    }
  }
  String? selectedValue;
  String? selectedValue1;
  Future<void> fetchSuggestions(String query, String type) async {
    if (query.isEmpty) return;
    final url = Uri.parse('http://universities.hipolabs.com/search?name=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final List<String> suggestions =
        data.map<String>((item) => item['name'] as String).toList();
        setState(() {
          if (type == "origin") {
            originSuggestions = suggestions;
          } else {
            destinationSuggestions = suggestions;
          }
        });
      }
    } catch (e) {
      // Handle error
      print("Error fetching suggestions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.backGroundColor,
    appBar: AppBar(
      backgroundColor: Colors.white.withOpacity(0.3),
      title: Text("Search for the best Freight rates",
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black
      ),),
      actions:[
        Container(
          height: width*0.026,
          width: width*0.07,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width*0.03),
              border: Border.all(
                color: ColorConst.textColor,
              )
          ),
          child: const Center(child: Text("History",
          style: TextStyle(
            color: ColorConst.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),)),
        ),
        SizedBox(width: width*0.01,)
      ]
    ),
      body: Padding(
        padding: EdgeInsets.all(width*0.02),
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.43,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  controller: originController,
                                  onChanged: (value) => fetchSuggestions(value, "origin"),
                                  cursorColor: ColorConst.textformText,
                                  decoration: InputDecoration(
                                    labelText: 'Origin',
                                    hintText: "Origin",
                                    labelStyle: const TextStyle(color: ColorConst.textformText),
                                    hintStyle: const TextStyle(color: ColorConst.textformText),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(width * 0.01),
                                      child: SvgPicture.asset(ImageConst.location),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                  ),
                                ),
                                if (originSuggestions.isNotEmpty)
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorConst.borderColor
                                      )
                                    ),
                                    child: ListView.builder(
                                      itemCount: originSuggestions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(originSuggestions[index]),
                                          onTap: () {
                                            setState(() {
                                              originController.text = originSuggestions[index];
                                              originSuggestions.clear();
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: ColorConst.textColor,
                                side: const BorderSide(color: ColorConst.borderColor),
                                value: isCheckedPort,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedPort = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Include near by origin ports",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.43,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  controller: destinationController,
                                  onChanged: (value) => fetchSuggestions(value, "destination"),
                                  cursorColor: ColorConst.textformText,
                                  decoration: InputDecoration(
                                    labelText: 'Destination',
                                    labelStyle:const TextStyle(color: ColorConst.textformText),
                                    hintText: "Destination",
                                    hintStyle: const TextStyle(color: ColorConst.textformText),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(width * 0.01),
                                      child: SvgPicture.asset(ImageConst.location),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorConst.borderColor,
                                      ),
                                    ),
                                  ),
                                ),
                                if (destinationSuggestions.isNotEmpty)
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorConst.borderColor
                                      )
                                    ),
                                    child: ListView.builder(
                                      itemCount: destinationSuggestions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(destinationSuggestions[index]),
                                          onTap: () {
                                            setState(() {
                                              destinationController.text =
                                              destinationSuggestions[index];
                                              destinationSuggestions.clear();
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: ColorConst.textColor,
                                side: const BorderSide(color: ColorConst.borderColor),
                                value: isCheckedDestination,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedDestination = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Include near by destination ports",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width*0.9,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width:width*0.43,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          decoration: const InputDecoration(

                            labelText: "Commodity",
                            labelStyle: TextStyle(color: ColorConst.textformText),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorConst.borderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorConst.borderColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorConst.borderColor,
                              ),
                            ),
                          ),

                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          isExpanded: true,

                          hint: const Text( "Commodity",
                           style: TextStyle(
                                color: ColorConst.textformText
                            ),),
                          value: selectedValue, // Current selected value
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding:  EdgeInsets.only(left: width*0.01),
                                child: Text(item,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                                ),),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value; // Update the selected value
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: width*0.43,
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          controller: dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          cursorColor: ColorConst.textformText,
                          cursorHeight: width * 0.04,
                          decoration: InputDecoration(
                            hintText: 'Cut off date',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(ImageConst.calender),
                            ),
                            hintStyle:const TextStyle(
                              color: ColorConst.textformText,
                              fontWeight: FontWeight.w400
                            ),
                            counter: const Offstage(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:BorderSide(color: ColorConst.borderColor),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: ColorConst.borderColor),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Text("Shipment type :",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,

                ),),
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: ColorConst.textColor,
                          side: const BorderSide(
                            color: ColorConst.borderColor,
                          ),
                          value: FCL,
                          onChanged: (value) {
                            setState(() {
                              FCL = value!;
                              if (FCL) {
                                LCL = false; // Uncheck LCL if FCL is selected
                              }
                            });
                          },
                        ),
                        const Text(
                          "FCL",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.05),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: ColorConst.textColor,
                          side: const BorderSide(
                            color: ColorConst.borderColor,
                          ),
                          value: LCL,
                          onChanged: (value) {
                            setState(() {
                              LCL = value!;
                              if (LCL) {
                                FCL = false; // Uncheck FCL if LCL is selected
                              }
                            });
                          },
                        ),
                        const Text(
                          "LCL",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.43,
                      child: DropdownButtonFormField<String>(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(

                          labelText: "Container Size",
                          labelStyle: TextStyle(color: ColorConst.textformText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConst.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConst.borderColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConst.borderColor,
                            ),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        isExpanded: true, // Ensures the dropdown fills the width of the container
                         // Removes the default underline
                        value: selectedValue1, // Current selected value
                        hint: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align text and icon
                          children: [
                            Text(
                              "Container Size",
                              style: TextStyle(
                                color: ColorConst.textformText,
                              ),
                            ),

                          ],
                        ),
                        items: items1.map((String item) {

                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              '$item  Standard',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue1 = value; // Update the selected value
                          });
                        },
                      ),
                    ),


                    SizedBox(
                      width: width*0.2,
                      child:TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        cursorColor: ColorConst.textformText,
                        decoration: const InputDecoration(
                          labelText: "No:of boxes",
                          labelStyle: TextStyle(
                              color: ColorConst.textformText
                          ),
                          hintText: "No:of boxes",
                          hintStyle: TextStyle(
                              color: ColorConst.textformText
                          ),

                          border: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            )
                        ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width*0.3,
                      child:TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        cursorColor: ColorConst.textformText,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              color: ColorConst.textformText
                          ),
                          labelText: "Weight",
                          hintText: "Weight(kg)",
                          hintStyle: TextStyle(
                              color: ColorConst.textformText
                          ),

                          border: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            )
                        ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                                color: ColorConst.borderColor
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(ImageConst.info),
                    const Text(" To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666)
                    ),)
                  ],
                ),
                SizedBox(height: width*0.009,),
                const Text("Container internal Dimension :",style:
                  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,

                  ),),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Length : ",
                              style: TextStyle(
                                  fontSize: width*0.01,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff666666)
                              ),),
                             Text("39.5 ft",
                              style: TextStyle(
                                  fontSize: width*0.012,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              ),)
                          ],
                        ),
                        Row(
                          children: [
                            Text("Width : ",
                            style: TextStyle(
                                fontSize:width*0.012,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff666666)
                            ),
                            ),
                            Text("7.5 ft",
                              style: TextStyle(
                                  fontSize:width*0.012,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              ),)
                          ],
                        ),
                        Row(
                          children: [
                            Text("height: ",
                              style: TextStyle(
                                  fontSize:width*0.012,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff666666)
                              ),),
                            Text("7.8 ft",
                              style: TextStyle(
                                  fontSize:width*0.012,
                                  fontWeight: FontWeight.w400,
                                  color:Colors.black
                              ),)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: width*0.005,),
                    Container(
                      height: width*0.07,
                      width: width*0.3,
                      decoration: const BoxDecoration(
                        image:  DecorationImage(image: AssetImage(ImageConst.container))
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Padding(
                      padding:  EdgeInsets.only(right:width*0.03),
                      child: Container(
                        height: width*0.029,
                        width: width*0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width*0.03),
                            border: Border.all(
                              color: ColorConst.textColor,
                            )
                        ),
                        child: Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(ImageConst.search,
                            width: width*0.013,
                            height: width*0.013,),
                            SizedBox(width: width*0.003,),
                            const Text("Search",
                              style: TextStyle(
                                  color: ColorConst.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),),
                          ],
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
