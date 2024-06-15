import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/common/post_view/view_model/post_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class PostDetailPage extends StatefulWidget {
  final PostViewModel viewModel;

  const PostDetailPage({super.key, required this.viewModel});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    unawaited(widget.viewModel.getResults());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (context) {
        return reaction(
          (_) => widget.viewModel.castVoteStatus,
          (state) async {
            if (widget.viewModel.castVoteStatus == CastVoteStatus.success) {
              widget.viewModel.voteStatus = VoteStatus.alreadyVoted;
              toastification.show(
                type: ToastificationType.success,
                title: const Text('Vote cast successfully'),
              );
              await widget.viewModel.getResults();
            }
          },
          fireImmediately: true,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Poll details', style: context.moonTypography?.heading.text24),
        ),
        body: CustomScrollView(
          slivers: [
            SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: context.moonColors?.beerus,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.viewModel.nftMeta!.url,
                                    imageBuilder: (context, imageProvider) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  widget.viewModel.post.question,
                                  style: context.moonTypography?.heading.text24.copyWith(
                                    color: context.moonColors!.bulma,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Observer(
                                  builder: (context) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                                      itemCount: widget.viewModel.rows.length,
                                      itemBuilder: (context, index) {
                                        final result = widget.viewModel.rows[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: context.moonColors?.krillin60,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              MoonAccordion<Widget>(
                                                accordionSize: MoonAccordionSize.lg,
                                                label: Row(
                                                  children: [
                                                    Text(
                                                      result.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'RedHatText',
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      result.votes,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'RedHatText',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                children: result.data.map((e) {
                                                  return ListTile(
                                                    title: Text(
                                                      e.key,
                                                      style: TextStyle(
                                                        color: context.moonColors?.bulma,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'RedHatText',
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      e.value,
                                                      style: TextStyle(
                                                        color: context.moonColors?.bulma,
                                                        fontSize: 14,
                                                        fontFamily: 'RedHatText',
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              if (widget.viewModel.voteStatus != VoteStatus.owner &&
                                                  widget.viewModel.voteStatus == VoteStatus.canVote)
                                                Positioned(
                                                  right: 40,
                                                  top: 4,
                                                  child: SizedBox(
                                                    width: 70,
                                                    child: MoonButton(
                                                      buttonSize: MoonButtonSize.md,
                                                      isFullWidth: true,
                                                      backgroundColor: context.moonColors?.chichi,
                                                      onTap: () async {
                                                        if (widget.viewModel.castVoteStatus == CastVoteStatus.loading) {
                                                          return;
                                                        }
                                                        await _showConfirmModal(context, result.accountId);
                                                      },
                                                      label: widget.viewModel.castVoteStatus == CastVoteStatus.loading
                                                          ? CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                context.moonColors!.gohan,
                                                              ),
                                                              strokeWidth: 2,
                                                            )
                                                          : Text(
                                                              'Vote',
                                                              style: TextStyle(
                                                                color: context.moonColors?.gohan,
                                                                fontSize: 14,
                                                                fontFamily: 'RedHatText',
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: context.moonColors?.roshi,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Total votes cast',
                                      style: context.moonTypography?.caption.text18,
                                    ),
                                    trailing: Text(
                                      widget.viewModel.totalVotes.ceil().toString(),
                                      style: context.moonTypography?.caption.text20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (widget.viewModel.voteStatus == VoteStatus.restricted)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'You need to have a minimum of 1 ${widget.viewModel.nftMeta?.code} to participate in this vote',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'RedHatText',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Observer(
                          builder: (context) {
                            return Wrap(
                              children: [
                                if (widget.viewModel.voteStatus != VoteStatus.owner &&
                                    widget.viewModel.voteStatus != VoteStatus.canVote)
                                  MoonFilledButton(
                                    buttonSize: MoonButtonSize.lg,
                                    backgroundColor: context.moonColors?.roshi,
                                    onTap: () async {
                                      switch (widget.viewModel.voteStatus) {
                                        case VoteStatus.restricted:
                                          await widget.viewModel.requestVotingToken();
                                        case VoteStatus.alreadyVoted:
                                        case VoteStatus.requestedToken:
                                        default:
                                      }
                                    },
                                    label: widget.viewModel.voteStatus == VoteStatus.alreadyVoted
                                        ? const Icon(MoonIcons.generic_check_rounded_32_regular)
                                        : Text(
                                            switch (widget.viewModel.voteStatus) {
                                              VoteStatus.canVote => 'Vote',
                                              VoteStatus.alreadyVoted => 'Voted',
                                              VoteStatus.requestedToken => 'Requesting token',
                                              VoteStatus.restricted => 'Request token',
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
                                else if (widget.viewModel.requestsToVote.isNotEmpty)
                                  MoonFilledButton(
                                    buttonSize: MoonButtonSize.lg,
                                    backgroundColor: context.moonColors?.roshi,
                                    onTap: () => context.pushToStack(NavPaths.voters.route(extra: widget.viewModel)),
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
                                        widget.viewModel.requestsToVote.length.toString(),
                                        style: TextStyle(
                                          color: context.moonColors?.beerus,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        if (widget.viewModel.post.imageLink.isNotEmpty)
                          ListTile(
                            title: Text('Campaign photo', style: context.moonTypography?.heading.text14),
                            subtitle: Text(
                              widget.viewModel.post.imageLink,
                              style: TextStyle(
                                color: context.moonColors?.roshi,
                                fontSize: 14,
                                fontFamily: 'RedHatText',
                              ),
                            ),
                            onTap: () async => launchUrl(Uri.parse(widget.viewModel.post.imageLink)),
                          ),
                        if (widget.viewModel.post.webLink.isNotEmpty)
                          ListTile(
                            title: Text('Website', style: context.moonTypography?.heading.text14),
                            subtitle: Text(
                              widget.viewModel.post.webLink,
                              style: TextStyle(
                                color: context.moonColors?.roshi,
                                fontSize: 14,
                                fontFamily: 'RedHatText',
                              ),
                            ),
                            onTap: () async => launchUrl(Uri.parse(widget.viewModel.post.webLink)),
                          ),
                        if (widget.viewModel.post.videoLink.isNotEmpty)
                          ListTile(
                            title: const Icon(MoonIcons.media_video_32_regular),
                            onTap: () async => launchUrl(Uri.parse(widget.viewModel.post.videoLink)),
                          ),
                        ListTile(
                          title: Text(
                            'NFT name',
                            style: context.moonTypography?.heading.text14,
                          ),
                          subtitle: Text(
                            widget.viewModel.nftMeta?.name ?? '',
                            style: TextStyle(
                              color: context.moonColors?.bulma,
                              fontSize: 14,
                              fontFamily: 'RedHatText',
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('NFT Asset code', style: context.moonTypography?.heading.text14),
                          subtitle: Text(
                            widget.viewModel.nftMeta?.code ?? '',
                            style: TextStyle(
                              color: context.moonColors?.bulma,
                              fontSize: 14,
                              fontFamily: 'RedHatText',
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Created At', style: context.moonTypography?.heading.text14),
                          subtitle: Text(
                            widget.viewModel.post.createdAt.toDateString(),
                            style: TextStyle(
                              color: context.moonColors?.bulma,
                              fontSize: 14,
                              fontFamily: 'RedHatText',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmModal(BuildContext context, String accountId) {
    return showMoonModal<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.moonColors?.gohan,
          title: Text('Confirming Voting Request', style: context.moonTypography?.heading.text20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to vote for this option?',
                style: TextStyle(fontSize: 16, color: context.moonColors?.trunks),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'This action will cost ',
                  children: [
                    TextSpan(
                      text: '${widget.viewModel.nftMeta?.code}',
                      style: context.moonTypography?.heading.text18,
                    ),
                  ],
                  style: TextStyle(fontSize: 16, color: context.moonColors?.bulma),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 16,
                  color: context.moonColors?.chichi,
                ),
              ),
            ],
          ),
          actions: [
            MoonOutlinedButton(
              onTap: () => Navigator.of(context).pop(),
              borderColor: context.moonColors?.roshi,
              label: Text(
                'Cancel',
                style: TextStyle(
                  color: context.moonColors?.bulma,
                  fontSize: 14,
                  fontFamily: 'RedHatText',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            MoonFilledButton(
              backgroundColor: context.moonColors?.chichi,
              onTap: () {
                unawaited(widget.viewModel.vote(accountId));
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              label: Text(
                'Confirm',
                style: TextStyle(
                  color: context.moonColors?.bulma,
                  fontSize: 14,
                  fontFamily: 'RedHatText',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
