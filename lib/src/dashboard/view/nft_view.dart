import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/dashboard/view/attachment_button.dart';
import 'package:vote38/src/dashboard/view_model/create_post_view_model.dart';

class NftView extends StatefulWidget {
  final CreatePostViewModel viewModel;
  const NftView({super.key, required this.viewModel});

  @override
  State<NftView> createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _nftNameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _limitController.dispose();
    _nftNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (context) {
        return reaction(
          (_) => [widget.viewModel.nftName, widget.viewModel.code, widget.viewModel.limit],
          (state) {
            _nftNameController.text = widget.viewModel.nftName;
            _codeController.text = widget.viewModel.code;
            _limitController.text = widget.viewModel.limit;
          },
          fireImmediately: true,
        );
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  'Mint NFT',
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
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Total number of voters: (The total number NFT token in circulation)',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  MoonTextInput(
                    hintText: 'Enter number of voters',
                    controller: _limitController,
                    onChanged: (value) => widget.viewModel.limit = value,
                    activeBorderColor: context.moonColors?.krillin,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NFT token name:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  MoonTextInput(
                    hintText: 'Enter NFT token name',
                    controller: _nftNameController,
                    activeBorderColor: context.moonColors?.krillin,
                    onChanged: (value) => widget.viewModel.nftName = value,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NFT token code:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  MoonTextInput(
                    controller: _codeController,
                    hintText: 'Enter NFT token code (Max 12 characters)',
                    activeBorderColor: context.moonColors?.krillin,
                    onChanged: (value) => widget.viewModel.code = value,
                  ),
                  Observer(
                    builder: (context) {
                      if (widget.viewModel.image != null) {
                        return AnimatedAlign(
                          duration: const Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              const Text('Preview'),
                              const SizedBox(height: 15),
                              widget.viewModel.image ?? const SizedBox(),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Change image? ',
                                    style: TextStyle(
                                      color: context.moonColors?.trunks,
                                      fontSize: 16,
                                    ),
                                  ),
                                  MoonButton(
                                    onTap: () async => widget.viewModel.pickNftFileFromGallery(),
                                    backgroundColor: context.moonColors?.krillin,
                                    label: const Text('Select from gallery'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  MoonFilledButton(
                    buttonSize: MoonButtonSize.lg,
                    backgroundColor: context.moonColors?.bulma,
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    label: Text(
                      'Attach NFT',
                      style: context.moonTypography?.heading.text20.copyWith(color: context.moonColors?.gohan),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
