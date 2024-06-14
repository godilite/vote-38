import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
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
    return Scaffold(
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
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: widget.viewModel.nftMeta!.url,
                                  imageBuilder: (context, imageProvider) => ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
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
                                          color: context.moonColors?.whis,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            result.name,
                                            style: TextStyle(
                                              color: context.moonColors?.goten,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'RedHatText',
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  result.votes,
                                                  style: context.moonTypography?.heading.text18
                                                      .copyWith(color: context.moonColors?.roshi),
                                                ),
                                                const SizedBox(width: 10),
                                                MoonButton(
                                                  buttonSize: MoonButtonSize.sm,
                                                  backgroundColor: context.moonColors?.chichi,
                                                  onTap: () async {
                                                    await widget.viewModel.vote(result.accountId);
                                                  },
                                                  label: Text(
                                                    'Vote',
                                                    style: TextStyle(
                                                      color: context.moonColors?.gohan,
                                                      fontSize: 14,
                                                      fontFamily: 'RedHatText',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: context.moonColors?.roshi,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Text(
                                    'Total votes cast',
                                    style: TextStyle(
                                      color: context.moonColors?.popo,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RedHatText',
                                    ),
                                  ),
                                  trailing: Text(
                                    widget.viewModel.totalVotes.ceil().toString(),
                                    style: context.moonTypography?.heading.text18,
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
                              if (widget.viewModel.voteStatus != VoteStatus.owner)
                                MoonFilledButton(
                                  buttonSize: MoonButtonSize.sm,
                                  backgroundColor: context.moonColors?.roshi,
                                  onTap: () async {
                                    switch (widget.viewModel.voteStatus) {
                                      case VoteStatus.restricted:
                                        await widget.viewModel.requestVotingToken();
                                      case VoteStatus.canVote:
                                      case VoteStatus.alreadyVoted:
                                      case VoteStatus.requestedToken:
                                      default:
                                    }
                                  },
                                  label: Text(
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
    );
  }
}
