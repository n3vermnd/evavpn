import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(EvaVPN());
}

class EvaVPN extends StatelessWidget {
  const EvaVPN({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eva VPN',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Linking(),
    );
  }
}

class Linking extends StatelessWidget {
  final String apiAuthUrl = 'https://eva-network.ru/api/v1/auth';
  const Linking({super.key});

  void _launchTelegram(String authCode) async {
    final String tgUrl = 'https://t.me/eva_network_bot?start=$authCode';
    if (await canLaunch(tgUrl)) {
      await launch(tgUrl);
    } else {
      throw 'Could not launch $tgUrl';
    }
  }

  Future<void> _generateIdAndLaunchTelegram() async {
    try {
      final response = await http.get(Uri.parse(apiAuthUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String generatedId = data['id'];
        _launchTelegram(generatedId);
      } else {
        print('Failed to generate ID: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: _generateIdAndLaunchTelegram,
            child: const Text('Привязать к Telegram')),
      ),
    );
  }
}
