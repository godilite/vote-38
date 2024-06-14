import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/common/post_view/post_view.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';
import 'package:vote38/src/timeline/view_model/timeline_view_model.dart';

class TimelineView extends StatelessWidget {
  final TimelineViewModel viewModel;

  const TimelineView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Row(
              children: [
                const Text(
                  'Timeline',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                MoonOutlinedButton(
                  buttonSize: MoonButtonSize.sm,
                  onTap: () => context.pushToStack(NavPaths.search.route()),
                  label: const Icon(CupertinoIcons.search),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Observer(
              builder: (context) {
                return ListView.separated(
                  itemCount: viewModel.posts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final post = viewModel.posts[index];
                    return SizedBox(
                      height: 230,
                      child: CaptionBox(
                        text: post.question,
                        post: post,
                        date: post.createdAt.toDateString(),
                        postId: post.postId,
                        nftCid: post.nftCid,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
