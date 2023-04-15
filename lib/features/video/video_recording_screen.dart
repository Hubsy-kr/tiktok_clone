import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/features/video/viedo_preview_screen.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeUrl = '/upload';

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _deniedPermissions = false;
  bool _isSelfieMode = false;

  // 디버그모드 && ios애뮬레이터시 카메라 작동X
  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final AnimationController _progressAnimationController =
      AnimationController(
          vsync: this,
          duration: const Duration(seconds: 10),
          lowerBound: 0.0,
          upperBound: 1.0);

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late FlashMode _flashMode;
  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    // 카메라가 없으면 종료
    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    // iOS를 위함(가끔 영상,음성 싱크가 안맞을때가 있는데 그것을 해결)
    // 안드로이드는 X
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _deniedPermissions = true;
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      // 이러면 일단 화면을 볼수있다
      setState(() {
        _hasPermission = true;
      });
    }

    // User가 어플리케이션을 벗어나면 알려줌, 그러고 다시돌아오면 이 클래스에 알려줌.
    WidgetsBinding.instance.addObserver(this);

    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    // context를 asnyc로 사용하면 발생하는 경고표시위함
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
    // 권한을 요청할때 어플리케이션 앞에 있고 이것을 비활성화취급함. 그래서 오류발생(initialize안됐다고)
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_deniedPermissions)
                    const Text(
                      '권한을 허용해주세요.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  if (!_deniedPermissions)
                    const Text(
                      'Initializing....',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  Gaps.v20,
                  const CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (!_noCamera && _cameraController.value.isInitialized)
                    CameraPreview(
                      _cameraController,
                    ),
                  const Positioned(
                    top: Sizes.size28,
                    left: Sizes.size14,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
                  if (!_noCamera) // 카메라가 initialize되지 않으면 flashMode도 보여지면 안됌
                    Positioned(
                      top: Sizes.size28,
                      right: Sizes.size14,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: _toggleSelfieMode,
                            color: Colors.white,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            onPressed: () => _setFlashMode(FlashMode.off),
                            color: _flashMode == FlashMode.off
                                ? Colors.amber.shade200
                                : Colors.white,
                            icon: const Icon(
                              Icons.flash_off_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            onPressed: () => _setFlashMode(FlashMode.always),
                            color: _flashMode == FlashMode.always
                                ? Colors.amber.shade200
                                : Colors.white,
                            icon: const Icon(
                              Icons.flash_on_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            onPressed: () => _setFlashMode(FlashMode.auto),
                            color: _flashMode == FlashMode.auto
                                ? Colors.amber.shade200
                                : Colors.white,
                            icon: const Icon(
                              Icons.flash_auto_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            onPressed: () => _setFlashMode(FlashMode.torch),
                            color: _flashMode == FlashMode.torch
                                ? Colors.amber.shade200
                                : Colors.white,
                            icon: const Icon(
                              Icons.flashlight_on_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: Sizes.size40,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size14,
                                  height: Sizes.size80 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: _progressAnimationController.value,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: _onPickVideoPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.image,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
