import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/mapper/post_view_mapper.dart';
import 'package:vote38/src/common/post_view/view_model/post_view_model.dart';

class ResultView extends StatefulWidget {
  final PostViewModel viewModel;

  const ResultView({super.key, required this.viewModel});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  List<String> get columnNames => widget.viewModel.columns;

  MoonTableHeader _generateTableHeader() {
    return MoonTableHeader(
      columns: List.generate(
        columnNames.length,
        (int index) => MoonTableColumn(
          cell: Text(columnNames[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Text(
                'Voting results',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              MoonOutlinedButton(
                buttonSize: MoonButtonSize.sm,
                onTap: () => Navigator.of(context).pop(),
                label: const Icon(CupertinoIcons.arrow_left),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        body: Observer(
          builder: (_) {
            final rowList = widget.viewModel.rows
                .map(
                  (OptionData row) => MoonTableRow(
                    cells: [
                      Text(row.name),
                      Text(row.votes),
                    ],
                  ),
                )
                .toList();
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: MoonTable(
                  columnsCount: columnNames.length,
                  width: 500,
                  rowSize: MoonTableRowSize.sm,
                  tablePadding: const EdgeInsets.symmetric(horizontal: 16),
                  header: _generateTableHeader(),
                  rows: rowList,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
