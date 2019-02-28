import 'package:flutter/material.dart';

import '../constants.dart' show AppColors, AppStyles, Constants;
import '../modal/conversation.dart' show Conversation, mockConversation;

class _ConversationItem extends StatelessWidget {
  const _ConversationItem({Key key, this.conversation})
    : assert(conversation != null),
    super(key: key);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    // 根据图片的获取方式i 初始化头像组件
    Widget avatar;
    if (conversation.isAvatarFromNet()) {
      avatar  = Image.network(
        conversation.avatar,
        width: Constants.ConversationSize,
        height: Constants.ConversationSize,
      );
    } else {
      avatar = Image.asset(
        conversation.avatar,
        width: Constants.ConversationSize,
        height: Constants.ConversationSize,
        );
    }

    Widget avatarContainer;
    if (conversation.unreadMsgCount > 0) {
      // 未读消息角标
      Widget unreadMsgCountText = Container(
        width: Constants.UnReadMsgNotifyDotSize,
        height: Constants.UnReadMsgNotifyDotSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.UnReadMsgNotifyDotSize / 2.0),
          color: Color(AppColors.NotifyDotBg)
        ),
        child: Text(conversation.unreadMsgCount.toString(), 
          style:AppStyles.UnreadMsgCountDotStyle),
      );

      avatarContainer =Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          avatar,
          Positioned(
            right: -6.0,
            top: -6.0,
            child: unreadMsgCountText,
          )
        ],
      );
    } else {
      avatarContainer = avatar;
    }

    // 勿扰模式图标
    var _rightArea = <Widget>[
      Text(conversation.updateAt, style: AppStyles.DesStyle),
      SizedBox(height: 10.0,)
    ];
    if(conversation.isMute) {
        _rightArea.add(
          Icon(IconData(
            0xe78b,
            fontFamily: Constants.IconFontFamily,
          ), color: Color(AppColors.ConversationMuteIcon), 
        size: Constants.ConversationMuteIconSize,)
      );
    } else {
      _rightArea.add(
          Icon(IconData(
            0xe78b,
            fontFamily: Constants.IconFontFamily,
          ), color: Colors.transparent, 
        size: Constants.ConversationMuteIconSize,)
      );
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(AppColors.ConversationItemBg),
        border: Border(
          bottom: BorderSide(
            color: Color(AppColors.DividerColor), 
            width: Constants.DividerWidth
          ),
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          avatarContainer,
          Container(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(conversation.title, style: AppStyles.TitleStyle),
                Text(conversation.desc, style: AppStyles.DesStyle)
              ],
            ),
          ),
          Container(width: 10.0),
          Column(
            children: _rightArea,
          )
        ],
      )
    );
  }
}

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _ConversationItem(conversation: mockConversation[index]);
      },
      itemCount: mockConversation.length,
    );
  }
}