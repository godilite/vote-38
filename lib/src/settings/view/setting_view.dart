import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool switchValue = false;
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
              Row(
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
                    value: switchValue,
                    switchSize: MoonSwitchSize.sm,
                    activeTrackColor: context.moonColors!.krillin,
                    inactiveTrackColor: context.moonColors!.krillin10,
                    activeTrackWidget: const Icon(MoonIcons.other_moon_24_regular),
                    inactiveTrackWidget: const Icon(MoonIcons.other_sun_24_regular),
                    onChanged: (bool newValue) => setState(() => switchValue = newValue),
                  ),
                ],
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
