import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Chat App',
            home: ChatScreen(),
        );
    }
}

class ChatScreen extends StatefulWidget {
    @override
    State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
    final TextEditingController _textController = TextEditingController();
    final List<String> _messages = [];
    IO.Socket socket;

    @override
    void initState() {
        super.initState();
        socket = IO.io('http://localhost:3000');
        socket.on('chat message', (msg) {
            setState(() {
                _messages.add(msg);
            });
        });
    }

    void _handleSubmitted(String text) {
        _textController.clear();
        socket.emit('chat message', text);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Chat App'),
            ),
            body: Column(
                children: <Widget>[
                    Flexible(
                        child: ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            reverse: true,
                            itemCount: _messages.length,
                            itemBuilder: (BuildContext context, int index) {
                                return Text(_messages[index]);
                            },
                        ),
                    ),
                    Divider(height: 1.0),
                    Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        child: _buildTextComposer(),
                    ),
                ],
            ),
        );
    }

    Widget _buildTextComposer() {
        return IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    children: <Widget>[
                        Flexible(
                            child: TextField(
                                controller: _textController,
                                onSubmitted: _handleSubmitted,
                                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
                            ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => _handleSubmitted(_textController.text),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
