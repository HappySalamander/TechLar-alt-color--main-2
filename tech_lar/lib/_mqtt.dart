import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';

class MqttService{
  final MqttServerClient _client = MqttServerClient('mqtt.eclipseprojects.io', 'flutter_client');
  final StreamController<String> _messageStreamController = StreamController<String>();

  Stream<String> get messagesStream => _messageStreamController.stream;

  void initializeMqttClient() {
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.logging(on: true);

    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMess;
  }

  Future<void> connect() async {
    try {
      await _client.connect();
    } catch (e) {
      print('Erro ao conectar: $e');
      rethrow;
    }

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      _messageStreamController.add(message);
    });
  }

  void disconnect() {
    _client.disconnect();
    _messageStreamController.close();
  }

  void publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void _onConnected() {
    print('Conectado ao Broker MQTT');
    _client.subscribe('test/topic', MqttQos.atMostOnce);
  }

  void _onDisconnected() {
    print('Desconectado do Broker MQTT');
  }

  void _onSubscribed(String topic) {
    print('Inscrito no tópico: $topic');
  }

  void dispose() {
    _messageStreamController.close();
  }
}