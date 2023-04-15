import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/video/widgets/video_button.dart';
import 'package:tiktok_clone/features/video/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;

  bool _isPaused = false;
  bool _isMuted = true;
  final Duration _animationDuration = const Duration(milliseconds: 300);

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/video.mp4');
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    _videoPlayerController.addListener(_onVideoChange);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }

    setState(() {});
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVIsibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }

    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTaogglePause();
    }
  }

  void _onTaogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTaogglePause();
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // bottomSheet 사이즈 조절 가능
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        heightFactor: 1,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          child: const VideoComments(),
        ),
      ),
    );

    _onTaogglePause();
  }

  void _onVolumChanged() {
    if (_isMuted) {
      _videoPlayerController.setVolume(0.0);
    } else {
      _videoPlayerController.setVolume(1.0);
    }

    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: _onVIsibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTaogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.scale(
                  scale: _animationController.value,
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                VideoConfig.of(context).autoMute
                    ? FontAwesomeIcons.volumeHigh
                    : FontAwesomeIcons.volumeOff,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@진수',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Text(
                  'This is my house',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onVolumChanged,
                  child: VideoButton(
                    icon: _isMuted
                        ? FontAwesomeIcons.volumeXmark
                        : FontAwesomeIcons.volumeHigh,
                    text: _isMuted ? 'mute' : 'unmute',
                  ),
                ),
                Gaps.v24,
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/46519875?v=4"),
                  child: Text('진수'),
                ),
                Gaps.v24,
                const VideoButton(
                    icon: FontAwesomeIcons.solidHeart, text: '2.9M'),
                Gaps.v24,
                GestureDetector(
                    onTap: () => _onCommentsTap(context),
                    child: const VideoButton(
                        icon: FontAwesomeIcons.solidComment, text: '33.0K')),
                Gaps.v24,
                const VideoButton(icon: FontAwesomeIcons.share, text: 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
