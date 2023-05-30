import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Agent {
  final String name;
  final String imageUrl;

  Agent({required this.name, required this.imageUrl});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Agent>> _agentsFuture;

  @override
  void initState() {
    super.initState();
    _agentsFuture = _fetchAgents();
  }

  Future<List<Agent>> _fetchAgents() async {
    final response = await http.get(Uri.https('valorant-api.com', 'v1/agents'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Agent> agents = [];
      for (var agent in data['data']) {
        String name = agent['displayName'];
        String imageUrl = agent['fullPortrait'] == null
            ? "https://media.valorant-api.com/agents/e370fa57-4757-3604-3648-499e1f642d3f/fullportrait.png"
            : agent['fullPortrait'];
        agents.add(Agent(name: name, imageUrl: imageUrl));
      }
      return agents;
    } else {
      throw Exception('Failed to fetch agents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Agent>>(
        future: _agentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final agent = snapshot.data?[index];
                return ListTile(
                  leading: agent != null
                      ? Image.network(agent.imageUrl)
                      : SizedBox(),
                  title: agent != null ? Text(agent.name) : SizedBox(),
                  textColor: Colors.white,
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
