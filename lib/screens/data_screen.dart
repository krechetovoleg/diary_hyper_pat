import 'package:diary_hyper_pat/database/dhp_db.dart';
import 'package:diary_hyper_pat/database/dhpfilter_db.dart';
import 'package:diary_hyper_pat/models/dhp_filter_model.dart';
import 'package:diary_hyper_pat/models/dhp_model.dart';
import 'package:group_button/group_button.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Future<List<Dhp>>? futureDhp;

  final dhpDb = DhpDB();
  final dhpFilterDb = DhpFilterDB();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFil = GlobalKey<FormState>();
  var wellbeingList = [
    'Отличное',
    'Хорошее',
    'Нормальное',
    'Плохое',
    'Очень плохое'
  ];
  int isNew = 1;
  bool isVisiblePeriod = false;
  int changeFil = 0;

  TextEditingController tcSyst = TextEditingController();
  TextEditingController tcDist = TextEditingController();
  TextEditingController tcPulse = TextEditingController();
  TextEditingController tcwellbeing = TextEditingController();
  TextEditingController tcComment = TextEditingController();
  TextEditingController tcDates = TextEditingController();
  TextEditingController tcTimes = TextEditingController();
  TextEditingController tcFiltDFrom = TextEditingController();
  TextEditingController tcFiltDto = TextEditingController();

  GroupButtonController filterCont = GroupButtonController();

  final listFilButt = [
    'Все',
    'Последние 30 дней',
    'Последние 7 дней',
    'Период'
  ];

  DhpFiltrer? futureFilterDhp;

  @override
  void initState() {
    fetchDhp();
    super.initState();
  }

  void fetchDhp() {
    dhpFilterDb.fetchDhpFilter().then((value) {
      setState(() {
        futureFilterDhp = value;

        if (futureFilterDhp?.id != null) {
          filterCont = GroupButtonController(
            selectedIndex: futureFilterDhp!.id,
          );
          futureFilterDhp!.id == 3
              ? isVisiblePeriod = true
              : isVisiblePeriod = false;
        } else {
          filterCont = GroupButtonController(
            selectedIndex: 0,
          );
          isVisiblePeriod = false;
        }
      });
    });
    futureDhp = dhpDb.fetchAllData();
  }

  Future<void> selectDate(TextEditingController tec) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
      locale: const Locale("ru", "RU"),
    );

    if (selected != null) {
      setState(() {
        tec.text = DateFormat('dd.MM.yyyy').format(selected);
      });
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selected != null) {
      setState(() {
        tcTimes.text =
            "${selected.hour.toString().padLeft(2, '0')} : ${selected.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void showDlgData(int isNew, Map<String, dynamic>? elements) {
    double width = MediaQuery.of(context).size.width;

    if (isNew == 1) {
      tcSyst.clear();
      tcDist.clear();
      tcPulse.clear();
      tcwellbeing.clear();
      tcComment.clear();
      tcDates.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
      tcTimes.text = DateFormat('HH:mm').format(DateTime.now());
    } else if (isNew == 0) {
      tcSyst.text = elements?['syst'];
      tcDist.text = elements?['dist'];
      tcPulse.text = elements?['pulse'];
      tcwellbeing.text = elements?['wellbeing'];
      tcComment.text = elements?['comment'];
      tcDates.text = elements?['dates'];
      tcTimes.text = elements?['times'];
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              insetPadding: const EdgeInsets.all(10),
              title: isNew == 1
                  ? const Text(
                      "Добавить",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : const Text(
                      "Редактировать",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
              content: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.39,
                              child: TextFormField(
                                controller: tcDates,
                                onTap: () => selectDate(tcDates),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Дата",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: width * 0.39,
                              child: TextFormField(
                                controller: tcTimes,
                                onTap: () => selectTime(),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Время",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.25,
                              child: TextFormField(
                                controller: tcSyst,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Сист.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: width * 0.25,
                              child: TextFormField(
                                controller: tcDist,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Диаст.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: width * 0.25,
                              child: TextFormField(
                                controller: tcPulse,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Пульс",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.8,
                              child: TextFormField(
                                controller: tcwellbeing,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Center(
                                    child: Text(
                                      "Самочуствие",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  suffixIcon: PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (String value) {
                                      tcwellbeing.text = value;
                                    },
                                    constraints:
                                        BoxConstraints(minWidth: width * 0.8),
                                    itemBuilder: (BuildContext context) {
                                      return wellbeingList
                                          .map<PopupMenuItem<String>>(
                                              (String value) {
                                        return PopupMenuItem(
                                            value: value, child: Text(value));
                                      }).toList();
                                    },
                                  ),
                                ),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.none,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.8,
                              child: TextFormField(
                                controller: tcComment,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "Примечание",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    tcSyst.clear();
                    tcDist.clear();
                    tcPulse.clear();
                    tcwellbeing.clear();
                    tcComment.clear();
                  },
                  child: const Text("Отмена"),
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      isNew == 1
                          ? dhpDb.insertData(
                              syst: int.parse(tcSyst.text),
                              dist: int.parse(tcDist.text),
                              pulse: int.parse(
                                  tcPulse.text.isEmpty ? "0" : tcPulse.text),
                              wellbeing: tcwellbeing.text.isEmpty
                                  ? ""
                                  : tcwellbeing.text,
                              comment:
                                  tcComment.text.isEmpty ? "" : tcComment.text,
                              dates: tcDates.text.isEmpty ? "" : tcDates.text,
                              times: tcTimes.text.isEmpty ? "" : tcTimes.text,
                              sort: DateTime.parse(
                                      '${tcDates.text.substring(6, 10)}-${tcDates.text.substring(3, 5)}-${tcDates.text.substring(0, 2)}')
                                  .millisecondsSinceEpoch,
                            )
                          : dhpDb.updateData(
                              id: int.parse(elements?['id']),
                              syst: int.parse(tcSyst.text),
                              dist: int.parse(tcDist.text),
                              pulse: int.parse(
                                  tcPulse.text.isEmpty ? "0" : tcPulse.text),
                              wellbeing: tcwellbeing.text.isEmpty
                                  ? ""
                                  : tcwellbeing.text,
                              comment:
                                  tcComment.text.isEmpty ? "" : tcComment.text,
                              dates: tcDates.text.isEmpty ? "" : tcDates.text,
                              times: tcTimes.text.isEmpty ? "" : tcTimes.text,
                              sort: DateTime.parse(
                                      '${tcDates.text.substring(6, 10)}-${tcDates.text.substring(3, 5)}-${tcDates.text.substring(0, 2)}')
                                  .millisecondsSinceEpoch,
                            );

                      fetchDhp();
                      Navigator.pop(context);
                    }
                  },
                  child: isNew == 1
                      ? const Text("Добавить")
                      : const Text("Сохранить"),
                )
              ],
            ));
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  void showDlgFilter() {
    double width = MediaQuery.of(context).size.width;
    tcFiltDFrom.text = futureFilterDhp?.dfrom ?? "";
    tcFiltDto.text = futureFilterDhp?.dto ?? "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              insetPadding: const EdgeInsets.all(10),
              title: const Text(
                "Какие записи показать?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GroupButton(
                        controller: filterCont,
                        isRadio: true,
                        options: const GroupButtonOptions(
                          groupingType: GroupingType.column,
                        ),
                        buttons: listFilButt,
                        buttonIndexedBuilder: (selected, index, context) {
                          return RadioTile(
                            title: listFilButt[index],
                            selected: filterCont.selectedIndex,
                            index: index,
                            onTap: () {
                              filterCont.selectIndex(index);
                              setState(() {
                                if (index == 3) {
                                  tcFiltDFrom.text = DateFormat('dd.MM.yyyy')
                                      .format(DateTime.now());
                                  tcFiltDto.text = DateFormat('dd.MM.yyyy')
                                      .format(DateTime.now());

                                  isVisiblePeriod = true;
                                } else {
                                  isVisiblePeriod = false;
                                }
                              });
                            },
                          );
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: isVisiblePeriod,
                      child: Form(
                        key: _formKeyFil,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.39,
                              child: TextFormField(
                                controller: tcFiltDFrom,
                                onTap: () => selectDate(tcFiltDFrom),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "От",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: width * 0.39,
                              child: TextFormField(
                                controller: tcFiltDto,
                                onTap: () => selectDate(tcFiltDto),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Center(
                                    child: Text(
                                      "До",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Заполните'
                                        : null,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    dhpFilterDb.updateData(
                      id: filterCont.selectedIndex ?? 0,
                      dfrom: tcFiltDFrom.text.isEmpty ? "" : tcFiltDFrom.text,
                      dto: tcFiltDto.text.isEmpty ? "" : tcFiltDto.text,
                    );

                    fetchDhp();
                    Navigator.pop(context);
                  },
                  child: const Text("Применить"),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DHP: Дневник давления и пульса",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => showDlgFilter(),
              icon: const Icon(Icons.filter_alt_outlined),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(
                futureFilterDhp?.id != 3
                    ? futureFilterDhp?.type ?? ""
                    : "${futureFilterDhp!.type} ${futureFilterDhp!.dfrom} - ${futureFilterDhp!.dto}",
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Dhp>>(
                    future: futureDhp,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.data != null) {
                          final dhps = snapshot.data!;
                          final dhpsMap = Dhp.fetchData(dhps);

                          return dhps.isEmpty
                              ? const Center(
                                  child: Text(
                                  "Нет данных",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                              : GroupedListView<dynamic, String>(
                                  elements: dhpsMap,
                                  groupBy: (dhpsMap) =>
                                      dhpsMap['sort'].toString(),
                                  groupComparator: (value1, value2) =>
                                      value2.compareTo(value1),
                                  itemComparator: (item1, item2) =>
                                      item1['times'].compareTo(item2['dates']),
                                  order: GroupedListOrder.ASC,
                                  useStickyGroupSeparators: true,
                                  groupSeparatorBuilder: (String value) =>
                                      Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 2.0,
                                    ),
                                    child: Text(
                                      value.substring(13, 23),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context, element) {
                                    return GestureDetector(
                                      onTap: () => showDlgData(0, element),
                                      child: Dismissible(
                                        key: Key(element['id']),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Удалить текущую запись?"),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  actions: [
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Отмена"),
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        dhpDb.deleteData(
                                                            int.parse(
                                                                element['id']));
                                                        fetchDhp();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("ОК"),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          color: Colors.red,
                                          margin: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0),
                                          child: const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          elevation: 2.0,
                                          margin: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    4),
                                                            topLeft:
                                                                Radius.circular(
                                                                    4)),
                                                    color: colorFromHex(
                                                        element['dhpcolor']),
                                                  ),
                                                  child: const Column(
                                                    children: [
                                                      Text(""),
                                                      Text(""),
                                                      Text(""),
                                                      Text(""),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          element['times'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                right: 8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  "Давление : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                    "${element['syst']} / ${element['dist']}"),
                                                              ],
                                                            ),
                                                            Text(
                                                              "${element['dhpname']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  "Пульс : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  element['pulse'] ==
                                                                          "0"
                                                                      ? ""
                                                                      : "${element['pulse']}",
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  "Самочуствие : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  "${element['wellbeing']}",
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    4),
                                                            topRight:
                                                                Radius.circular(
                                                                    4)),
                                                    color: colorFromHex(
                                                        element['dhpcolor']),
                                                  ),
                                                  child: const Column(
                                                    children: [
                                                      Text(""),
                                                      Text(""),
                                                      Text(""),
                                                      Text(""),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        } else {
                          return const Center(
                              child: Text(
                            "Ошибка получения данных",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ));
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => showDlgData(1, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RadioTile extends StatelessWidget {
  const RadioTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.index,
    required this.title,
  }) : super(key: key);

  final String title;
  final int index;
  final int? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      leading: Radio<int>(
        groupValue: selected,
        value: index,
        onChanged: (val) {
          onTap();
        },
      ),
    );
  }
}
