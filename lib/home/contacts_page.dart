import 'package:flutter/material.dart';

import '../constants.dart' show AppColors, AppStyles, Constants;
import '../modal/contacts.dart' show Contact, ContactsPageData;

class _ContactItem extends StatelessWidget {
  _ContactItem({
    @required this.avatar,
    @required this.title,
    this.groupTitle,
    this.onPressed,
  });

  final String avatar;
  final String title;
  final String groupTitle;
  final VoidCallback onPressed;

  static const double MARGIN_VERTICAL = 10.0;
  static const double GROUP_TITLE_HEIGHT = 24.0;

  bool get _isAvatarFromNet {
    return this.avatar.startsWith('http') || this.avatar.startsWith('https');
  }

  static double _height(bool hasGroupTitle) {
    final _buttonHeight = MARGIN_VERTICAL *2 + Constants.ContactAvatarSize + Constants.DividerWidth;
    if(hasGroupTitle) {
      return _buttonHeight + GROUP_TITLE_HEIGHT;
    }
    return _buttonHeight;
  }

  @override
  Widget build(BuildContext context) {
    // 左边的图标
    Widget _avatarIcon;
    if(_isAvatarFromNet) {
      _avatarIcon = Image.network(
        avatar,
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    } else {
      _avatarIcon = Image.asset(
        avatar,
        width: Constants.ContactAvatarSize,
        height: Constants.ContactAvatarSize,
      );
    }

    // 列表项主题部分
    Widget _button = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: MARGIN_VERTICAL),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: Constants.DividerWidth, 
          color: const Color(AppColors.DividerColor)),
        )
      ),
      child: Row(
        children: <Widget>[
          _avatarIcon,
          SizedBox(width: 10.0),
          Text(title),
        ],
      ),
    );

    // 分组标签
    Widget _itemBody;
    if(this.groupTitle != null) {
      _itemBody = Column(
        children: <Widget>[
          Container(
            height: GROUP_TITLE_HEIGHT,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
            color: const Color(AppColors.ContactGroupTitleBg),
            alignment: Alignment.centerLeft,
            child: Text(this.groupTitle, style: AppStyles.GroupTitleItemTextStyle),
          ),
          _button,
        ],
      );
    }else {
      _itemBody = _button;
    }

    return _itemBody;
  }
}

const INDEX_BAR_WORDS = [
  "↑", "☆",
  "A", "B", "C", "D", "E", "F", "G",
  "H", "I", "J", "K", "L", "M", "N",
  "O", "P", "Q", "R", "S", "T", "U",
  "V", "W", "X", "Y", "Z"
];

class ContactsPages extends StatefulWidget {
  Color _indexBarBg = Colors.transparent;
  String _currentLetter = '';

  @override
  _ContactsPagesState createState() => _ContactsPagesState();
}

class _ContactsPagesState extends State<ContactsPages> {
  ScrollController _scrollController;
  final ContactsPageData data = ContactsPageData.mock();
  final List<Contact> _contacts = [];
  final List<_ContactItem> _functionButtons = [
    _ContactItem(
      avatar: 'assets/images/ic_new_friend.png',
      title: '新的朋友',
      onPressed: () { print('添加新朋友。'); },
    ),
    _ContactItem(
      avatar: 'assets/images/ic_group_chat.png',
      title: '群聊',
      onPressed: () { print('点击了群聊。'); },
    ),
    _ContactItem(
      avatar: 'assets/images/ic_tag.png',
      title: '标签',
      onPressed: () { print('标签'); },
    ),
    _ContactItem(
      avatar: 'assets/images/ic_public_account.png',
      title: '公众号',
      onPressed: () { print('添加公众号。'); },
    ),
  ];
  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  @override
  void initState() {
    super.initState();
    _contacts..addAll(data.contacts)..addAll(data.contacts)..addAll(data.contacts);
    _contacts.sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    _scrollController = new ScrollController();
    // 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    var _totalPos = _functionButtons.length * _ContactItem._height(false);
    for (var i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if(i > 0 && _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        _hasGroupTitle = false;
      }
      if(_hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = _totalPos;
      }
      _totalPos += _ContactItem._height(_hasGroupTitle);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();    
    super.dispose();
  }

  String _getLetters(BuildContext context, double tileHeight, Offset globalPos) {
    RenderBox _box = context.findRenderObject();
    var local = _box.globalToLocal(globalPos);
    int index = (local.dy ~/ tileHeight).clamp(0, INDEX_BAR_WORDS.length - 1);
    return INDEX_BAR_WORDS[index];
  }

  void _jumpToIndex(String letter) {
    if(_letterPosMap.isNotEmpty) {
      final _pos = _letterPosMap[letter];
      if(_pos != null) {
          _scrollController.animateTo(_pos, 
            curve: Curves.easeOut, duration: Duration(milliseconds: 200));
      }
    }
  }

  Widget _buildIndexBar(BuildContext context, BoxConstraints constraints) {
    final List<Widget> _letters =INDEX_BAR_WORDS.map((String word) {
      return Expanded(
        child: Text(word),
      );
    }).toList();

    final double _totalHeight = constraints.biggest.height;
    final double _tileHeight = _totalHeight / _letters.length;
    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        setState(() {
          widget._indexBarBg = Colors.black26;
          widget._currentLetter = _getLetters(context, _tileHeight, details.globalPosition);
          _jumpToIndex(widget._currentLetter);
        });
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          widget._indexBarBg = Colors.transparent;
          widget._currentLetter = null;
        });
      },
      onVerticalDragCancel: () {
        setState(() {
          widget._indexBarBg = Colors.transparent;
          widget._currentLetter = null;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          widget._indexBarBg = Colors.black26;
          widget._currentLetter = _getLetters(context, _tileHeight, details.globalPosition);
          _jumpToIndex(widget._currentLetter);
        });
      },
      child: Column(
        children: _letters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _body = [
      ListView.builder(
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if(index < _functionButtons.length) {
            return _functionButtons[index];
          }
          int _contactIndex = index - _functionButtons.length;
          bool _isGroupTitle = true;
          Contact _contact = _contacts[_contactIndex];
          if(_contactIndex >=1 && _contact.nameIndex == _contacts[_contactIndex - 1].nameIndex) {
            _isGroupTitle = false;
          }
          return _ContactItem(
            avatar: _contact.avatar, 
            title: _contact.name, 
            groupTitle: _isGroupTitle ? _contact.nameIndex : null
          );
        },
        itemCount: _contacts.length + _functionButtons.length,
      ),
      Positioned(
        width: Constants.IndexBarWidth,
        right: 0.0,
        top: 0.0,
        bottom: 0.0,
        child: Container(
          color: widget._indexBarBg,
          child: LayoutBuilder(
            builder: _buildIndexBar,
          ),
        )
      ),
    ];
    if(widget._currentLetter != null && widget._currentLetter.isNotEmpty) {
      _body.add(
        Center(
          child: Container(
            width: Constants.IndexLetterBoxSize,
            height: Constants.IndexLetterBoxSize,
            decoration: BoxDecoration(
              color: AppColors.IndexLetterBoxBg,
              borderRadius: BorderRadius.all(Radius.circular(Constants.IndexLetterBoxRadius)),
            ),
            child: Center(
              child: Text(widget._currentLetter, style: AppStyles.IndexLetterBoxTextStyle),
            )
          ),
        )
      );
    }
    return Stack(
      children: _body,
    );
  }
}