import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TtoRow {
  final String label;
  final String value;
  final ValueType type;

  const TtoRow({required this.label, required this.value, required this.type});
}

enum ValueType { bitcoin, satoshi, usd, date }

class TtoTable extends StatelessWidget {
  final List<TtoRow> rows;

  const TtoTable(this.rows, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: rows.map((row) => buildRow(row)).toList(),
    );
  }

  TableRow buildRow(TtoRow row) {
    Widget valueChild;
    const fontSize = 20.0;
    switch (row.type) {
      case ValueType.bitcoin:
        valueChild = Text.rich(TextSpan(
          style: const TextStyle(fontSize: fontSize, wordSpacing: 10),
          children: [
            TextSpan(
              text: row.value,
              style: const TextStyle(color: Colors.black, fontSize: fontSize),
            ),
            const WidgetSpan(child: SizedBox(width: 2)), // space between text and icons
            const WidgetSpan(child: Icon(FontAwesomeIcons.bitcoin))
          ],
        ));
        break;
      case ValueType.satoshi:
        valueChild = Text.rich(TextSpan(
          style: const TextStyle(fontSize: fontSize, wordSpacing: 10),
          children: [
            TextSpan(
              text: row.value,
              style: const TextStyle(color: Colors.black, fontSize: fontSize),
            ),
            const WidgetSpan(child: SizedBox(width: 2)), // space between text and icons
            WidgetSpan(
                child: SvgPicture.asset(
              "assets/satoshi_regular_black.svg",
              height: 24,
              color: Colors.black,
            ))
          ],
        ));
        break;
      case ValueType.usd:
        valueChild = Text(row.value + ' \$', style: const TextStyle(fontSize: fontSize));
        break;
      case ValueType.date:
        valueChild = Text.rich(TextSpan(
          style: const TextStyle(fontSize: fontSize, wordSpacing: 10),
          children: [
            TextSpan(
              text: row.value,
              style: const TextStyle(color: Colors.black, fontSize: fontSize),
            ),
          ],
        ));
        break;
    }

    return TableRow(children: [
      // Table Row do not yet support a height attribute, hence we need to use the SizedBox
      // workaround. see also https://github.com/flutter/flutter/issues/36936
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(row.label, style: const TextStyle(fontSize: fontSize)),
        const SizedBox(height: 15, width: 0)
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Wrap(
          children: [valueChild],
        )
      ]),
    ]);
  }
}
