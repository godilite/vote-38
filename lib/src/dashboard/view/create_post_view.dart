import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:vote38/src/dashboard/view/attachment_button.dart';
import 'package:vote38/src/dashboard/view_model/create_post_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

enum ModalType { link, video, file }

class CreatePostView extends StatefulWidget {
  final CreatePostViewModel viewModel;
  const CreatePostView({super.key, required this.viewModel});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    createTutorial();
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        widget.viewModel.error = '';
      },
      onClickTarget: (target) {
        widget.viewModel.error = '';
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {
        widget.viewModel.error = '';
      },
      onSkip: () {
        widget.viewModel.error = '';
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    final List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyButton,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Complete NFT setup to post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  final TextEditingController _questionController = TextEditingController();

  Future<String?> modalBuilder(BuildContext context, ModalType type, {String? initialLink}) {
    return showMoonModal<String?>(
      context: context,
      builder: (BuildContext context) {
        return MoonModal(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width - 64,
            child: AttachmentModal(
              type: type,
              initialLink: initialLink ?? '',
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ReactionBuilder(
      builder: (_) {
        return reaction(
          (_) => [widget.viewModel.question, widget.viewModel.error],
          (state) {
            _questionController.text = widget.viewModel.question;
            if (widget.viewModel.error == 'nftimagerequired') {
              showTutorial();
            }
          },
          fireImmediately: true,
        );
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  'New poll',
                  style: context.moonTypography?.heading.text32.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                AttachmentButton(
                  onTap: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          body: Observer(
            builder: (context) {
              final options = widget.viewModel.options.keys.toList();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.moonColors?.krillin,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MoonTextArea(
                            height: 200,
                            borderRadius: BorderRadius.circular(40),
                            hintText: 'Enter your question here',
                            controller: _questionController,
                            textStyle: context.moonTypography?.heading.text32,
                            activeBorderColor: Colors.transparent,
                            inactiveBorderColor: Colors.transparent,
                            hoverBorderColor: Colors.transparent,
                            hintTextColor: context.moonColors?.bulma.withOpacity(0.5),
                            onChanged: (value) {
                              widget.viewModel.question = value;
                            },
                            helperPadding: const EdgeInsets.only(right: 20),
                            helper: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.viewModel.question.length}/70',
                                  textAlign: TextAlign.end,
                                  style: context.moonTypography?.heading.text16,
                                ),
                              ],
                            ),
                            backgroundColor: Colors.transparent,
                            expands: true,
                            maxLength: 70,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                AttachmentButton(
                                  onTap: () async {
                                    final link = await modalBuilder(
                                      context,
                                      ModalType.link,
                                      initialLink: widget.viewModel.webLink,
                                    );
                                    if (link != null) {
                                      widget.viewModel.webLink = link;
                                    }
                                  },
                                  icon: MoonIcons.generic_link_32_regular,
                                ),
                                const SizedBox(width: 20),
                                AttachmentButton(
                                  onTap: () async {
                                    final videoLink = await modalBuilder(
                                      context,
                                      ModalType.video,
                                      initialLink: widget.viewModel.videoLink,
                                    );
                                    if (videoLink != null) {
                                      widget.viewModel.videoLink = videoLink;
                                    }
                                  },
                                  icon: MoonIcons.media_video_32_regular,
                                ),
                                const SizedBox(width: 20),
                                AttachmentButton(
                                  onTap: () async {
                                    final fileLink = await modalBuilder(
                                      context,
                                      ModalType.file,
                                      initialLink: widget.viewModel.imageLink,
                                    );

                                    if (fileLink != null) {
                                      widget.viewModel.imageLink = fileLink;
                                    }
                                  },
                                  icon: MoonIcons.media_photo_32_regular,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          ...options.indexed.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CandidateTile(
                                name: widget.viewModel.options[e.$2]![0].value.value,
                                isLast: e.$1 == options.length - 1,
                                isFirst: e.$1 == 0,
                                onAddMoreOptions: () {
                                  widget.viewModel.generateOptionAccountSeed();
                                },
                                onDelete: () async {
                                  final delete = await showMoonModal<bool>(
                                    context: context,
                                    builder: (context) {
                                      return MoonModal(
                                        borderRadius: BorderRadius.circular(30),
                                        child: const DeleteOptionView(),
                                      );
                                    },
                                  );

                                  if (delete == true) {
                                    await widget.viewModel.deleteOption(e.$2);
                                  }
                                },
                                onEdit: () {
                                  context.pushToStack(NavPaths.candidate.route(extra: e.$2));
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            decoration: BoxDecoration(
              color: context.moonColors?.beerus,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                MoonButton.icon(
                  key: keyButton,
                  onTap: () {
                    context.pushToStack(NavPaths.nftsetup.route());
                  },
                  backgroundColor: context.moonColors?.bulma,
                  icon: SvgPicture.asset('assets/images/nft-sign.svg', width: 30),
                  buttonSize: MoonButtonSize.xl,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MoonButton(
                      onTap: () async {
                        await widget.viewModel.submitPost();
                      },
                      backgroundColor: context.moonColors?.bulma,
                      textColor: context.moonColors?.gohan,
                      // ignore: deprecated_member_use
                      leading: SvgPicture.asset('assets/images/send.svg', color: context.moonColors?.gohan, width: 30),
                      label: Text('Post', style: context.moonTypography?.heading.text24),
                      buttonSize: MoonButtonSize.xl,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteOptionView extends StatelessWidget {
  const DeleteOptionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width - 64,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Deleting option', style: context.moonTypography?.heading.text14),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete this option?',
              style: context.moonTypography?.heading.text14,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MoonButton(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  backgroundColor: context.moonColors?.chichi,
                  textColor: context.moonColors?.gohan,
                  label: Text('Yes', style: context.moonTypography?.heading.text14),
                  buttonSize: MoonButtonSize.md,
                ),
                const SizedBox(width: 20),
                MoonButton(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  backgroundColor: context.moonColors?.krillin,
                  textColor: context.moonColors?.gohan,
                  label: Text('No', style: context.moonTypography?.heading.text14),
                  buttonSize: MoonButtonSize.md,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentModal extends StatefulWidget {
  final ModalType type;
  final String initialLink;
  const AttachmentModal({super.key, required this.type, required this.initialLink});

  @override
  State<AttachmentModal> createState() => _AttachmentModalState();
}

class _AttachmentModalState extends State<AttachmentModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialLink);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.type == ModalType.link ? 'Enter link to your website' : 'Enter a ${widget.type.name} url',
            style: context.moonTypography?.heading.text20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MoonTextInput(
            hintText: 'https://',
            controller: _controller,
            hintTextColor: context.moonColors?.bulma.withOpacity(0.5),
            textColor: context.moonColors?.bulma,
            onChanged: (value) {
              if (value.startsWith('http://') || value.startsWith('https://')) {
                _controller.text = value;
              } else {
                _controller.text = 'https://$value';
              }
            },
            activeBorderColor: context.moonColors?.bulma,
            inactiveBorderColor: context.moonColors?.bulma,
            hoverBorderColor: context.moonColors?.bulma,
            backgroundColor: context.moonColors?.beerus,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: MoonButton(
            onTap: () async {
              if (widget.type == ModalType.video) {
                await _validateVideoUrl(_controller.text).then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link added successfully'),
                      ),
                    );
                    Navigator.of(context).pop(_controller.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The link you entered is not a video link'),
                      ),
                    );
                  }
                });
              } else {
                Navigator.of(context).pop(_controller.text);
              }
            },
            backgroundColor: context.moonColors?.bulma,
            textColor: context.moonColors?.gohan,
            label: Text('Add', style: context.moonTypography?.heading.text24),
            buttonSize: MoonButtonSize.md,
          ),
        ),
      ],
    );
  }
}

Future<bool> _validateVideoUrl(String url) async {
  final isVideo = await checkVideoViaHeaders(url);
  if (!isVideo) {
    return checkVideoInHtml(url);
  }
  return isVideo;
}

Future<bool> checkVideoViaHeaders(String url) async {
  final response = await http.head(Uri.parse(url));
  final contentType = response.headers['content-type'];
  return contentType != null && contentType.startsWith('video');
}

Future<bool> checkVideoInHtml(String url) async {
  final response = await http.get(Uri.parse(url));
  final document = html.parse(response.body);

  // Check for video tags
  if (document.querySelector('video') != null ||
      document.querySelector('iframe') != null ||
      document.querySelector('embed') != null) {
    return true;
  }

  // Check for popular video platform embeds (e.g., YouTube)
  for (final element in document.querySelectorAll('iframe')) {
    final src = element.attributes['src'];
    if (src != null && src.contains('youtube')) {
      return true;
    }
  }

  return false;
}

class CandidateTile extends StatelessWidget {
  final void Function() onEdit;
  final void Function() onAddMoreOptions;
  final void Function() onDelete;
  final bool isLast;
  final bool isFirst;
  final String name;

  const CandidateTile({
    super.key,
    required this.onEdit,
    required this.onAddMoreOptions,
    required this.isLast,
    required this.isFirst,
    required this.name,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      decoration: BoxDecoration(
        color: context.moonColors?.gohan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (isLast)
            MoonButton.icon(
              onTap: onAddMoreOptions,
              icon: const Icon(MoonIcons.controls_plus_32_regular),
              buttonSize: MoonButtonSize.md,
            )
          else
            const SizedBox(
              width: 40,
            ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: context.moonTypography?.heading.text16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MoonButton.icon(
            onTap: onEdit,
            icon: const Icon(MoonIcons.files_add_text_32_regular),
            buttonSize: MoonButtonSize.md,
          ),
          if (!isFirst) ...[
            const SizedBox(width: 6),
            MoonButton.icon(
              onTap: onDelete,
              icon: const Icon(MoonIcons.generic_delete_32_regular),
              buttonSize: MoonButtonSize.md,
            ),
          ],
        ],
      ),
    );
  }
}
