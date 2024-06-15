import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/dashboard/view/attachment_button.dart';
import 'package:vote38/src/dashboard/view_model/create_post_view_model.dart';

class EditCandidateView extends StatefulWidget {
  final String id;
  final CreatePostViewModel viewModel;
  const EditCandidateView({super.key, required this.id, required this.viewModel});

  @override
  State<EditCandidateView> createState() => _EditCandidateViewState();
}

class _EditCandidateViewState extends State<EditCandidateView> {
  Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    for (final element in controllers.entries) {
      element.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ReactionBuilder(
        builder: (context) {
          return reaction(
            (_) => widget.viewModel.options[widget.id]?.map((e) => e.value).toList(),
            (state) {
              if (state == null) {
                return;
              }
              for (final element in state) {
                controllers.putIfAbsent(element.key, () => TextEditingController(text: element.value));
              }
            },
            fireImmediately: true,
          );
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  'Poll options',
                  style: context.moonTypography?.heading.text40,
                ),
                const Spacer(),
                AttachmentButton(
                  onTap: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          body: Observer(
            builder: (context) {
              final candidateData = widget.viewModel.options[widget.id];
              if (candidateData == null) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      for (final entry in controllers.entries) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${entry.key.capitalize()}:",
                            textAlign: TextAlign.start,
                            style: context.moonTypography?.heading.text20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MoonTextInput(
                          hintText: entry.key,
                          controller: entry.value,
                          style: context.moonTypography?.body.text20,
                          autofocus: true,
                          activeBorderColor: context.moonColors?.roshi,
                          inactiveBorderColor: context.moonColors?.roshi,
                          trailing: entry.key != 'name'
                              ? IconButton(
                                  icon: const Icon(MoonIcons.generic_delete_32_regular),
                                  onPressed: () async {
                                    await widget.viewModel.deleteOptionProperty(widget.id, entry.key);
                                    controllers.remove(entry.key);
                                    entry.value.dispose();
                                  },
                                )
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (candidateData.length <= 5)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: MoonFilledButton(
                                buttonSize: MoonButtonSize.lg,
                                backgroundColor: context.moonColors?.chichi,
                                onTap: () async {
                                  final data = await modalBuilder(context);
                                  if (data == null) {
                                    return;
                                  }
                                  final key = data['key'] ?? '';
                                  final value = data['value'] ?? '';

                                  await widget.viewModel.updateOrAddAccountData(widget.id, key, value);
                                },
                                label: const Text('Add one more field?'),
                              ),
                            ),
                          MoonFilledButton(
                            buttonSize: MoonButtonSize.lg,
                            backgroundColor: context.moonColors?.krillin,
                            onTap: () async {
                              for (final element in controllers.entries) {
                                final key = element.key;
                                final value = element.value.text;
                                await widget.viewModel.updateOrAddAccountData(widget.id, key, value);
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            },
                            label: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>?> modalBuilder(BuildContext context) {
    return showMoonModal<Map<String, String>?>(
      context: context,
      builder: (BuildContext context) {
        return MoonModal(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 290,
            width: MediaQuery.of(context).size.width - 64,
            child: OptionModal(),
          ),
        );
      },
    );
  }
}

class OptionModal extends StatefulWidget {
  @override
  State<OptionModal> createState() => _OptionModalState();
}

class _OptionModalState extends State<OptionModal> {
  String optionName = '';
  String optionValue = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Property name (e.g. age, party, etc.)'),
          const SizedBox(height: 10),
          MoonTextInput(
            hintText: 'Enter property name',
            activeBorderColor: context.moonColors?.roshi,
            onChanged: (value) {
              setState(() {
                optionName = value;
              });
            },
          ),
          const SizedBox(height: 20),
          const Text('Property value (e.g. 18, Democrat, etc.)'),
          const SizedBox(height: 10),
          MoonTextInput(
            hintText: 'Enter property value',
            activeBorderColor: context.moonColors?.roshi,
            onChanged: (value) {
              setState(() {
                optionValue = value;
              });
            },
          ),
          const SizedBox(height: 20),
          MoonFilledButton(
            buttonSize: MoonButtonSize.lg,
            isFullWidth: true,
            backgroundColor: context.moonColors?.krillin,
            onTap: () {
              Navigator.of(context).pop({'key': optionName, 'value': optionValue});
            },
            label: const Text('Add option'),
          ),
        ],
      ),
    );
  }
}
