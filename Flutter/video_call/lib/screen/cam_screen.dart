import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine; //아고라 엔진을 저장할 변수
  int? uid; //내 ID
  int? otherUid; //상대방 ID

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if (engine == null) {
      //엔진이 정의되지 않았으면 새로 정의해기
      engine = createAgoraRtcEngine();

      //아고라 엔진을 초기화
      await engine!.initialize(
          //초기화할 때 사용할 설정을 제공한다.
          RtcEngineContext(
        //미리 저장해둔 APP ID를 입력
        appId: APP_ID,

        //라이브 동영상 송출에 최적화
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      engine!.registerEventHandler(
          //아고라 엔진에서 받을 수 있는 이벤트 값들 등록
          RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          //채널 접속에 성공했을 때 실행
          print('채널에 입장했습니다. uid : ${connection.localUid}');

          setState(() {
            this.uid = connection.localUid;
          });
        },
        onLeaveChannel: (connection, stats) {
          // 채널 퇴장했을 떄
          print("채널 퇴장");
          setState(() {
            uid = null;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          //다른 사용자가 접속했을 때 실행
          print('상대가 채널에 입장했습니다. uid : ${remoteUid}');
          setState(() {
            otherUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          //다른 사용자가 채널을 나갔을 때 실행
          print('상대가 채널에서 나갔습니다. uid $uid');
          setState(() {
            otherUid = null;
          });
        },
      ));

      //엔진으로 영상을 송출하겠다고 설정
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo(); //동영상 기능을 활성화
      await engine!.startPreview(); //카메라를 이용해 동영상을 화면에 실행한다.
      //채널 들어가기
      await engine!.joinChannel(
          token: TEMP_TOKEN,
          channelId: CHANNEL_NAME,
          uid: 0,
          options: ChannelMediaOptions());
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  renderMainView(), //상대방이 찍은 화면
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: Colors.grey,
                      height: 160,
                      width: 120,
                      child: renderSubView(),
                    ),
                  )
                ],
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text("채널 나가기"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //내 핸드폰이 찍는 화면 렌더링
  Widget renderSubView() {
    if (uid != null) {
      //AgoraVideoView 위젯을 사용하면
      //동영상을 화면에 보여주는 위젯을 구연할 수 있다.
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,

          //VideoCanvas에 내 0dmf dlqfurgotj so dudtkddmf qhduwnsek.
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      //아직 내가 채널에 접속하지 않았따면
      //로딩 화면을 보여준다.
      return CircularProgressIndicator();
    }
  }

  //상대 핸드폰이 찍는 화면 렌더링
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
          controller: VideoViewController.remote(
              rtcEngine: engine!,
              canvas: VideoCanvas(uid: otherUid),
              connection: const RtcConnection(channelId: CHANNEL_NAME)));
    } else {
      return Center(
        child: const Text(
          "다른 사용자가 입장할 때까지 대기해주세요",
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
