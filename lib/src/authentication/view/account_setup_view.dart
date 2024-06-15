import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/authentication/view_model/account_setup_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class AccountSetupView extends StatelessWidget {
  final AccountSetupViewModel viewModel;
  const AccountSetupView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Observer(
          builder: (_) {
            final state = viewModel.accountSetupState;
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: (state is AccountSetupSuccess)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              child: Text(
                                "Account setup complete",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.moonColors?.roshi,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Align(
                              child: Text(
                                'You can now start voting on the platform.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.moonColors?.krillin,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Account ID: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            MoonMenuItem(
                              label: Text(state.accountId, style: TextStyle(color: context.moonColors?.trunks)),
                              trailing: Icon(MoonIcons.files_clipboard_32_regular, color: context.moonColors?.trunks),
                              onTap: () async => _copyToClipboard(context, state.secretKey),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Secret key: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            MoonMenuItem(
                              label: Text(state.secretKey, style: TextStyle(color: context.moonColors?.trunks)),
                              trailing: Icon(MoonIcons.files_clipboard_32_regular, color: context.moonColors?.trunks),
                              onTap: () async => _copyToClipboard(context, state.secretKey),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(MoonIcons.generic_alarm_32_regular, color: context.moonColors?.dodoria),
                                const SizedBox(width: 8),
                                Text(
                                  'Keep your secret key safe.',
                                  style: TextStyle(
                                    color: context.moonColors?.dodoria,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Text(
                              "Let's set up your account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.moonColors?.roshi,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 100),
                            Text(
                              'Choose a network',
                              textAlign: TextAlign.center,
                              style: context.moonTypography?.heading.text16.copyWith(
                                color: context.moonColors?.krillin,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropDownMenu(
                              onTapButton: () {
                                viewModel.showMenu = !viewModel.showMenu;
                              },
                              onTapOutside: () {
                                viewModel.showMenu = false;
                              },
                              showMenu: viewModel.showMenu,
                              onItemSelected: (value) {
                                viewModel.selectedNetwork = value;
                                viewModel.showMenu = false;
                              },
                              buttonName: viewModel.selectedNetwork,
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Observer(
          builder: (context) {
            final state = viewModel.accountSetupState;

            return (state is AccountSetupSuccess)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MoonButton(
                          isFullWidth: true,
                          backgroundColor: context.moonColors?.roshi,
                          textColor: context.moonColors?.gohan,
                          onTap: () {
                            context.pushClearStack(NavPaths.splash.route());
                          },
                          label: const Text('Continue'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        switch (viewModel.accountSetupState) {
                          AccountSetupFailed() => Text(
                              'Failed to setup account. Please try again.',
                              style: TextStyle(
                                color: context.moonColors?.chichi,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          AccountSetupLoading() => Text(
                              'Setting up account...',
                              style: TextStyle(
                                color: context.moonColors?.krillin,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          _ => const SizedBox(),
                        },
                        MoonButton(
                          isFullWidth: true,
                          backgroundColor: context.moonColors?.roshi,
                          textColor: context.moonColors?.gohan,
                          onTap: () async {
                            if (viewModel.accountSetupState case AccountSetupInitial()) {
                              await viewModel.startSetup();
                            }
                          },
                          label: switch (viewModel.accountSetupState) {
                            AccountSetupInitial() => const Text('Start setup'),
                            AccountSetupLoading() => MoonCircularLoader(
                                circularLoaderSize: MoonCircularLoaderSize.xs,
                                color: context.moonColors!.gohan,
                              ),
                            AccountSetupSuccess() => const Text('Setup complete'),
                            AccountSetupFailed() => const Text('Try again'),
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class DropDownMenu extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onTapButton;
  final void Function()? onTapOutside;
  final void Function(String)? onItemSelected;
  final bool showMenu;
  final String buttonName;

  const DropDownMenu({
    super.key,
    this.onTap,
    this.onTapOutside,
    this.onItemSelected,
    this.onTapButton,
    this.showMenu = false,
    this.buttonName = 'Testnet',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoonDropdown(
          show: showMenu,
          groupId: 'network',
          borderColor: context.moonColors!.trunks,
          constrainWidthToChild: true,
          onTapOutside: onTapOutside,
          content: Column(
            children: [
              MoonMenuItem(
                onTap: () => onItemSelected?.call('Testnet'),
                label: const Text("Testnet"),
              ),
              MoonMenuItem(
                onTap: () => onItemSelected?.call('Mainnet'),
                label: const Text("Mainnet"),
              ),
            ],
          ),
          child: MoonButton(
            isFullWidth: true,
            showBorder: true,
            borderWidth: 2,
            borderColor: context.moonColors!.beerus,
            onTap: onTapButton,
            label: Text(buttonName),
            trailing: Icon(
              showMenu ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: context.moonColors?.krillin,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          buttonName == "Testnet"
              ? 'Testnet is a test network that allows you to test the platform without using real money.'
              : 'Mainnet is the main network where you can use real money to vote.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.moonColors?.trunks,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You can switch between networks at any time in settings.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.moonColors?.trunks,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Future<void> _copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  MoonToast.show(
    // ignore: use_build_context_synchronously
    context,
    isPersistent: false,
    label: const Text('Copied to clipboard'),
  );
}
