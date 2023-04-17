import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/video/view_models/timeline_vm.dart';
import 'package:tiktok_clone/features/video/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();
  int _itemCount = 4;

  final Duration _scrollDuration = const Duration(milliseconds: 200);
  final Curve _scrollCurve = Curves.linear;

  @override
  void initState() {
    super.initState();
  }

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );

    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onVideoFinished() {
    return;
    _pageController.nextPage(duration: _scrollDuration, curve: _scrollCurve);
  }

  Future<void> _onRefresh() {
    return Future.delayed(const Duration(
      seconds: 5,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos: $error',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          data: (videos) => RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 50,
            edgeOffset: 20,
            child: PageView.builder(
              controller: _pageController,
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.sm,
                  ),
                  child: VideoPost(
                      onVideoFinished: _onVideoFinished, index: index)),
            ),
          ),
        );
  }
}
