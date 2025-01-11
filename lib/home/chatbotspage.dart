import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

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

  final dio = Dio(); // Dio instance for API calls
  final String apiUrl = "http://localhost:8000/api/recipes"; // Your backend URL

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

  Future<void> _fetchRecommendations() async {
    try {
      final response = await dio.get(apiUrl); // Use Dio to fetch data
      if (response.statusCode == 200) {
        final data = response.data;
        // Assuming the data contains a list of recipes
        final recipes =
            data['data']; // Adjust according to your response structure

        if (recipes.isNotEmpty) {
          setState(() {
            _messages.add(Message(
                isUser: false,
                message: "Here are some recipe suggestions:",
                date: DateTime.now()));
            // Loop through the recipes and display them as Cards
            for (var recipe in recipes) {
              _messages.add(Message(
                  isUser: false,
                  message:
                      "Recipe: ${recipe['name']}\nIngredients: ${recipe['ingredients']}",
                  date: DateTime.now(),
                  isCard: true)); // Flag the message to display it as a card
            }
          });
        } else {
          setState(() {
            _messages.add(Message(
                isUser: false,
                message:
                    "Sorry, I couldn't find any recommendations at the moment.",
                date: DateTime.now()));
          });
        }
      } else {
        setState(() {
          _messages.add(Message(
              isUser: false,
              message:
                  "Error fetching recommendations. Please try again later.",
              date: DateTime.now()));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(
            isUser: false,
            message:
                "An error occurred while fetching recommendations. Please try again later.",
            date: DateTime.now()));
      });
    }
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
                return message.isCard
                    ? _buildRecipeCard(message.message)
                    : Messages(
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

  // Method to build the recipe card
  Widget _buildRecipeCard(String recipeDetails) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipeDetails,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("View Recipe"),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  final bool isCard;

  Message(
      {required this.isUser,
      required this.message,
      required this.date,
      this.isCard = false});
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

  List<TextSpan> _parseBoldText(String text) {
    List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*'); // Regex to find **bold** text

    int start = 0;
    var matches = regex.allMatches(text);

    for (var match in matches) {
      // Add normal text before the bold section
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(
              fontSize: 16, color: isUser ? Colors.white : Colors.white),
        ));
      }
      // Add bold text
      spans.add(TextSpan(
        text: match.group(1), // Extract the bold part
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isUser ? Colors.white : Colors.white),
      ));
      start = match.end;
    }

    // Add any remaining normal text after the last match
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
            fontSize: 16, color: isUser ? Colors.white : Colors.white),
      ));
    }

    return spans;
  }

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
          RichText(
            text: TextSpan(
              children: _parseBoldText(message),
            ),
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
