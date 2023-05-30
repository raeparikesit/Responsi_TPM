import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<dynamic> agents = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch agents data without uuid
    final agentsUrl = Uri.parse('https://valorant-api.com/v1/agents');
    final agentsResponse = await http.get(agentsUrl);

    if (agentsResponse.statusCode == 200) {
      setState(() {
        agents = jsonDecode(agentsResponse.body)['data'];
      });
    } else {
      print('Failed to fetch agents data.');
    }

    // Fetch agent data with uuid
    final uuid = 'your_uuid_here';
    final agentUrl = Uri.parse('https://valorant-api.com/v1/agents/$uuid');
    final agentResponse = await http.get(agentUrl);

    if (agentResponse.statusCode == 200) {
      final agentData = jsonDecode(agentResponse.body)['data'];
      // Do something with the agent data
      print(agentData);
    } else {
      print('Failed to fetch agent data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: agents.length,
        itemBuilder: (BuildContext context, int index) {
          final cartoon = agents[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    agents: cartoon,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(cartoon['fullPortrait']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    cartoon['displayName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final dynamic agents;

  DetailPage({required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                agents['fullPortrait'],
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                agents['displayName'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'displayName: ${agents['displayName']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'title: ${agents['title']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'description: ${agents['description']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'developerName: ${agents['developerName']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'background: ${agents['background']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
