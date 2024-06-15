import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/services/model/account.dart';
import 'package:vote38/src/settings/viewmodel/setting_view_model.dart';

class SettingView extends StatefulWidget {
  final SettingViewModel viewModel;
  const SettingView({super.key, required this.viewModel});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  void initState() {
    unawaited(widget.viewModel.loadAccount());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Observer(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.viewModel.account?.accountId != null)
                            RandomAvatar(widget.viewModel.account!.accountId, width: 100),
                          MoonChip(
                            backgroundColor: context.moonColors!.krillin10,
                            leading: const Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            label: Text(
                              widget.viewModel.account?.numSponsored.toString() ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            widget.viewModel.account?.accountId.truncate(15) ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          MoonButton(
                            onTap: () async =>
                                await _copyToClipboard(context, widget.viewModel.account?.accountId ?? ''),
                            label: const Icon(MoonIcons.files_copy_32_regular),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 25),
                      const Text('Assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      for (final tag
                          in widget.viewModel.account?.balances.where((element) => element.assetType != 'native') ??
                              <VoteBalance>[])
                        Row(
                          children: [
                            MoonChip(
                              backgroundColor: context.moonColors!.krillin10,
                              leading: Text(
                                tag.assetCode ?? 'XLM',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              label: Text(
                                tag.balance,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const Spacer(),
                            MoonButton(
                              backgroundColor: context.moonColors!.roshi,
                              onTap: () async => launchUrlString(
                                'https://stellar.expert/explorer/testnet/asset/${tag.assetCode}-${tag.assetIssuer ?? ''}',
                              ),
                              label: const Text('View in Explorer'),
                            ),
                          ],
                        ),
                      const Divider(),
                      const SizedBox(height: 25),
                      const Text('My NFTs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
              Observer(
                builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      MoonSwitch(
                        value: widget.viewModel.isDarkMode,
                        switchSize: MoonSwitchSize.sm,
                        activeTrackColor: context.moonColors!.krillin,
                        inactiveTrackColor: context.moonColors!.krillin10,
                        activeTrackWidget: const Icon(MoonIcons.other_moon_24_regular),
                        inactiveTrackWidget: const Icon(MoonIcons.other_sun_24_regular),
                        onChanged: (bool newValue) => setState(() => widget.viewModel.isDarkMode = newValue),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Network',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  DropDownMenu(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton(
                    onPressed: () {},
                    child: const Text('English'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    MoonToast.show(
      // ignore: use_build_context_synchronously
      context,
      label: const Text('Copied to clipboard'),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  bool _showMenu = false;
  String _buttonName = "Testnet";

  final String _groupId = "group1";

  @override
  Widget build(BuildContext context) {
    return MoonDropdown(
      backgroundColor: context.moonColors!.beerus,
      show: _showMenu,
      groupId: _groupId,
      constrainWidthToChild: true,
      onTapOutside: () => setState(() {
        _showMenu = false;
      }),
      content: Column(
        children: [
          MoonMenuItem(
            onTap: () => setState(() {
              _showMenu = false;
              _buttonName = "Testnet";
            }),
            label: const Text("Testnet"),
          ),
          MoonMenuItem(
            onTap: () => setState(() {
              _showMenu = false;
              _buttonName = "Mainnet";
            }),
            label: const Text("Mainnet"),
          ),
        ],
      ),
      child: MoonFilledButton(
        width: 120,
        backgroundColor: context.moonColors!.krillin,
        onTap: () => setState(() => _showMenu = !_showMenu),
        label: Text(_buttonName),
      ),
    );
  }
}
