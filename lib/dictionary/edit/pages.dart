import 'package:flutter/material.dart';

class DictionaryEditPage extends StatelessWidget {
  final String title;

  const DictionaryEditPage({Key key, this.title = 'Add Vocabulary'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          margin: EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              ...List.generate(4, (index) => AspectRatio(
                aspectRatio: 1.0,
                child:  InkResponse(
                    onTap: (){

                    },
                    radius: 90,
                    child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.apps, size: 160,),
                            Text('Test', style: TextStyle(fontSize: 16),)
                          ],
                        )
                    )),
              ))
            ],
          )),
    );
  }
}