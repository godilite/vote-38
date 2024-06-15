import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:measure_size/measure_size.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/common/post_box_painter.dart';
import 'package:vote38/src/common/post_view/view_model/post_view_model.dart';
import 'package:vote38/src/di/di.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';
import 'package:vote38/src/services/post_service.dart';

class CaptionBox extends StatefulWidget {
  final String text;
  final String date;
  final Color? backgroundColor;
  final bool hideVoteButton;
  final String postId;
  final String nftCid;
  final Post post;

  const CaptionBox({
    required this.text,
    required this.date,
    this.backgroundColor,
    required this.postId,
    required this.nftCid,
    required this.post,
    this.hideVoteButton = false,
  });

  @override
  State<CaptionBox> createState() => _CaptionBoxState();
}

class _CaptionBoxState extends State<CaptionBox> {
  late PostViewModel viewModel;

  @override
  void initState() {
    viewModel = PostViewModel(
      widget.postId,
      widget.nftCid,
      getIt<PostService>(),
      getIt(),
      widget.post,
      getIt(),
      getIt(),
    );
    unawaited(viewModel.init());
    super.initState();
  }

  Size bubbleSize = Size.zero;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, _) {
        return InkWell(
          onTap: () {
            context.pushToStack(
              NavPaths.postDetail.route(extra: viewModel),
            );
          },
          child: Stack(
            children: [
              MeasureSize(
                onChange: (size) {
                  setState(() {
                    bubbleSize = size;
                  });
                },
                child: CustomPaint(
                  painter: PostBoxPainter(
                    widget.text,
                    backgroundColor: widget.backgroundColor ?? context.moonColors!.krillin,
                    textColor: context.moonColors!.popo,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (context) {
                  return Positioned(
                    bottom: 5,
                    height: bubbleSize.height * 0.35,
                    width: bubbleSize.width / 3.9,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        context.pushToStack(
                          NavPaths.resultView.route(extra: viewModel),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: context.moonColors!.trunks),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.totalVotes.ceil().toString(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            const Icon(
                              MoonIcons.chart_bar_alternative_32_light,
                              size: 26,
                            ),
                            const Text(
                              'view results',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 30,
                left: 10,
                child: Column(
                  children: [
                    Observer(
                      builder: (context) {
                        return Wrap(
                          spacing: 4,
                          children: [
                            if (viewModel.voteStatus != VoteStatus.owner)
                              MoonChip(
                                chipSize: MoonChipSize.sm,
                                backgroundColor: context.moonColors?.roshi,
                                label: Text(
                                  switch (viewModel.voteStatus) {
                                    VoteStatus.canVote => 'Eligible',
                                    VoteStatus.alreadyVoted => 'Voted',
                                    VoteStatus.requestedToken => 'Requesting token',
                                    VoteStatus.restricted => 'Join to vote',
                                    _ => 'Loading...',
                                  },
                                  style: TextStyle(
                                    color: context.moonColors?.gohan,
                                    fontSize: 14,
                                    fontFamily: 'RedHatText',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else if (viewModel.requestsToVote.isNotEmpty)
                              MoonFilledButton(
                                buttonSize: MoonButtonSize.sm,
                                backgroundColor: context.moonColors?.roshi,
                                onTap: () => context.pushToStack(NavPaths.voters.route(extra: viewModel)),
                                label: Text(
                                  'Incoming voter request',
                                  style: TextStyle(
                                    color: context.moonColors?.gohan,
                                    fontSize: 14,
                                    fontFamily: 'RedHatText',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: context.moonColors?.chichi,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    viewModel.requestsToVote.length.toString(),
                                    style: TextStyle(
                                      color: context.moonColors?.beerus,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            MoonFilledButton(
                              backgroundColor: context.moonColors?.roshi,
                              buttonSize: MoonButtonSize.sm,
                              onTap: () async {
                                await showNftToken(context);
                              },
                              label: SvgPicture.asset(
                                'assets/images/nft-sign.svg',
                                fit: BoxFit.cover,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      color: context.moonColors?.bulma,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showNftToken(BuildContext context) async {
    await showMoonModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      height: 400,
      builder: (context) {
        return NftTokenView(nftMeta: viewModel.nftMeta);
      },
    );
  }
}

class NftTokenView extends StatelessWidget {
  final NftMeta? nftMeta;
  const NftTokenView({super.key, required this.nftMeta});
  @override
  Widget build(BuildContext context) {
    if (nftMeta == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.moonColors?.krillin,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nftMeta!.name,
            style: TextStyle(
              color: context.moonColors?.bulma,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nftMeta!.description,
            style: TextStyle(
              color: context.moonColors?.bulma,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CachedNetworkImage(imageUrl: nftMeta!.url, fit: BoxFit.cover),
          Text(
            'Token code: ${nftMeta!.code}',
            style: TextStyle(
              color: context.moonColors?.bulma,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
