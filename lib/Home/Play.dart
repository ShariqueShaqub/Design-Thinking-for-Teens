import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoPlayScreen extends StatefulWidget {
  final String folder;
  const VideoPlayScreen({super.key, required this.folder});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  VideoPlayerController? _controller;
  late Client client;
  late Storage storage;

  final Map<String, String> flutterVideos = {
    "What is Design Thinking": "67d7ce26000d3520ae8a",
    "Empathize": "67d7ce9d003ac9672d11",
    "Define": "67d7ceb000105e38c7b8",
    "Ideate": "67d7ceb8003ae649eb81",
    "Prototype": "67d7cec800034d71269b",
    "Test": "67d7cecf00125a2cdb53",
  };

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject("67d037a100204739d319");
    storage = Storage(client);
    fetchVideoUrl();
  }

  Future<void> fetchVideoUrl() async {
    try {
      String? fileId = flutterVideos[widget.folder];
      if (fileId == null) return;

      final Uint8List response = await storage.getFileView(
        bucketId: '67d039f800168f252c0c',
        fileId: fileId,
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/video.mp4');
      await file.writeAsBytes(response);

      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _controller!.addListener(_videoListener);
        });
    } catch (e) {
      print("Error fetching video: $e");
    }
  }

  void _videoListener() {
    if (_controller != null &&
        _controller!.value.position >= _controller!.value.duration) {
      markVideoAsCompleted(widget.folder);
    }
  }

  Future<void> markVideoAsCompleted(String moduleName) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection("users")
        .doc(uid)
        .collection("completedModules")
        .doc(moduleName)
        .set({"name": moduleName});
    await firestore
        .collection("users")
        .doc(uid)
        .collection("ongoingModules")
        .doc(moduleName)
        .delete();

    print("Video marked as completed!");
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Text(
            widget.folder,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          if (_controller != null && _controller!.value.isInitialized)
            _buildVideoPlayer()
          else
            _buildLoadingIndicator(),
          _buildPlaybackControls(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                FullScreenVideo(controller: _controller!),
                      ),
                    ),
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.fullscreen, color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 5),
              Text(
                "Video is loading...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.replay_10, size: 30, color: Colors.grey),
              onPressed:
                  () => _controller?.seekTo(
                    _controller!.value.position - Duration(seconds: 10),
                  ),
            ),
            IconButton(
              icon: Icon(
                _controller != null && _controller!.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 50,
                color: Colors.green,
              ),
              onPressed:
                  () => setState(
                    () =>
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play(),
                  ),
            ),
            IconButton(
              icon: Icon(Icons.forward_10, size: 30, color: Colors.grey),
              onPressed:
                  () => _controller?.seekTo(
                    _controller!.value.position + Duration(seconds: 10),
                  ),
            ),
          ],
        ),
        if (_controller != null && _controller!.value.isInitialized)
          Padding(
            padding: const EdgeInsets.all(10),
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.green,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black26,
              ),
            ),
          ),
      ],
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController controller;
  const FullScreenVideo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GestureDetector(
          onTap:
              () =>
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play(),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
