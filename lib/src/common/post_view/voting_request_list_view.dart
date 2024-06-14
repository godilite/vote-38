import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moon_design/moon_design.dart';
import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/common/post_view/view_model/post_view_model.dart';

class VotingRequestListView extends StatelessWidget {
  final PostViewModel viewModel;
  const VotingRequestListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Observer(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  title: Text('Voting Requests', style: context.moonTypography!.heading.text24),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Select All', style: TextStyle(fontSize: 16)),
                        MoonCheckbox(
                          value: viewModel.isSelectAll,
                          activeColor: context.moonColors!.roshi,
                          onChanged: (value) {
                            viewModel.selectAll();
                          },
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final request = viewModel.requestsToVote[index];

                      final id = index + 1;
                      return ListTile(
                        isThreeLine: true,
                        leading: Text(id.toString(), style: context.moonTypography!.heading.text20),
                        title: Text(request.voterId.truncate(8), style: context.moonTypography!.heading.text20),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Post ID: ${request.postId.truncate(7)}',
                              style: context.moonTypography!.body.text16,
                            ),
                            const SizedBox(width: 10),
                            Text('Time: ${request.time.toDateString()}', style: context.moonTypography!.body.text14),
                          ],
                        ),
                        trailing: Observer(
                          builder: (context) {
                            final selectedItems = viewModel.selectedOptions;

                            return MoonCheckbox(
                              activeColor: context.moonColors!.roshi,
                              value: selectedItems.contains(request.voterId),
                              onChanged: (value) => viewModel.onSelected(request.voterId),
                            );
                          },
                        ),
                      );
                    },
                    childCount: viewModel.requestsToVote.length,
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: MoonButton(
          backgroundColor: context.moonColors!.roshi,
          onTap: () async {
            await showConfirmModal(context);
          },
          leading: const Icon(MoonIcons.files_save_32_regular),
          label: Text('Confirm', style: context.moonTypography!.heading.text16),
        ),
      ),
    );
  }

  Future<void> showConfirmModal(BuildContext context) {
    return showMoonModal<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.moonColors!.gohan,
          title: Text('Confirming Voting Request', style: context.moonTypography!.heading.text20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to confirm this voting request?',
                style: TextStyle(fontSize: 16, color: context.moonColors!.trunks),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'This will send a total of ',
                  children: [
                    TextSpan(
                      text: '${viewModel.selectedOptions.length} ${viewModel.nftMeta?.code}',
                      style: context.moonTypography!.heading.text18,
                    ),
                    TextSpan(text: ' voting tokens to ${viewModel.selectedOptions.length} selected voters.'),
                  ],
                  style: TextStyle(fontSize: 16, color: context.moonColors!.bulma),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 16,
                  color: context.moonColors!.chichi,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: context.moonColors!.chichi,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.confirmVoters();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
