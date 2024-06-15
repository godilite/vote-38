import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/common/post_view/post_view.dart';
import 'package:vote38/src/dashboard/view_model/dashboard_view_model.dart';
import 'package:vote38/src/navigation/nav_paths.dart';
import 'package:vote38/src/navigation/navigator.dart';

class DashboardView extends StatefulWidget {
  final DashboardViewModel viewModel;
  const DashboardView({super.key, required this.viewModel});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Row(
              children: [
                const Text(
                  'My posts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                MoonOutlinedButton(
                  buttonSize: MoonButtonSize.sm,
                  onTap: () => context.pushToStack(NavPaths.createpost.route()),
                  label: const Icon(CupertinoIcons.add),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Observer(
                    builder: (_) => widget.viewModel.posts.isEmpty
                        ? _EmptyView()
                        : ListView.separated(
                            itemCount: widget.viewModel.posts.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final post = widget.viewModel.posts[index];

                              return SizedBox(
                                height: 230,
                                child: CaptionBox(
                                  postId: post.postId,
                                  nftCid: post.nftCid,
                                  date: post.createdAt.toDateString(),
                                  hideVoteButton: true,
                                  post: post,
                                  backgroundColor: context.moonColors?.krillin,
                                  text: post.question,
                                ),
                              );
                            },
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

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Icon(
            MoonIcons.files_folder_open_32_regular,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create your first post',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          MoonOutlinedButton(
            buttonSize: MoonButtonSize.sm,
            onTap: () => context.pushToStack(NavPaths.createpost.route()),
            label: const Text('Create post'),
          ),
        ],
      ),
    );
  }
}
