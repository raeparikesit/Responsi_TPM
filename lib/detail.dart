import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class Agent {
  final String imageUrl;
  final String role;
  final String displayName;
  final String description;
  final List<Ability> abilities;

  Agent({
    required this.imageUrl,
    required this.role,
    required this.displayName,
    required this.description,
    required this.abilities,
  });
}

class Ability {
  final String name;
  final String description;

  Ability({required this.name, required this.description});
}

class Detail extends StatelessWidget {
  final Agent agent;

  Detail({required this.agent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(agent.displayName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (agent.imageUrl.isNotEmpty)
              Image.network(
                agent.imageUrl,
                width: double.infinity,
              ),
            SizedBox(height: 16.0),
            Text(
              'Role: ${agent.role}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${agent.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Abilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: agent.abilities.length,
              itemBuilder: (context, index) {
                final ability = agent.abilities[index];
                return ListTile(
                  title: Text(ability.name),
                  subtitle: Text(ability.description),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
