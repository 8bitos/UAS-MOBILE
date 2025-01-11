import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatbotsPage extends StatefulWidget {
  const ChatbotsPage({super.key});

  @override
  State<ChatbotsPage> createState() => _ChatbotsPageState();
}

class _ChatbotsPageState extends State<ChatbotsPage> {
  final TextEditingController _userInput = TextEditingController();
  String selectedLanguage = 'en'; // 'en' for English, 'id' for Indonesian

  static const apiKey = "AIzaSyAPhXCuFYyDZqBjS0f6TLwMw33YyFUeq18";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userInput.text;

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    // Prepend a system instruction that restricts the chatbot's responses
    String languagePrompt = selectedLanguage == 'en'
        ? "Please only respond with recipe or food (how to cook, suggestion, tips) related information in English. If the question is not related to recipes, respond with: 'Sorry, I can only talk about recipes.' $message"
        : "Tolong hanya beri informasi terkait resep dan makanan (cara memasak atau rekomendasi, ) dalam bahasa Indonesia. Jika pertanyaannya tidak terkait resep, balas dengan: 'Maaf, saya hanya bisa membahas tentang resep.' $message";

    final content = [Content.text(languagePrompt)];

    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    // Clear the input after sending the message
    _userInput.clear();
  }

  void switchLanguage() {
    setState(() {
      selectedLanguage = selectedLanguage == 'en' ? 'id' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    controller: _userInput,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: const Text('Enter Your Message')),
                  ),
                ),
                const Spacer(),
                IconButton(
                    padding: const EdgeInsets.all(12),
                    iconSize: 30,
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(const CircleBorder())),
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin:
            const EdgeInsets.only(bottom: 80), // Place the button above a bit
        child: FloatingActionButton(
          onPressed: switchLanguage,
          child: selectedLanguage == 'en'
              ? Image.asset('assets/images/united-kingdom.png',
                  width: 30, height: 30) // English flag
              : Image.asset('assets/images/indonesia-flag.png',
                  width: 30, height: 30), // Indonesian flag
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
        color:
            isUser ? Colors.blueAccent : const Color.fromARGB(255, 31, 31, 31),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
            topRight: const Radius.circular(10),
            bottomRight: isUser ? Radius.zero : const Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontSize: 16,
                color: isUser
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 255, 255, 255)),
          ),
          Text(
            date,
            style: TextStyle(
                fontSize: 10,
                color: isUser
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 88, 88, 88)),
          ),
        ],
      ),
    );
  }
}
