import 'dart:math';

import 'package:type_state_pattern/entities/post.dart';

class Statics {
  // Predefined list of authors
  static const List<String> authors = [
    'Alice', 'Bob', 'Charlie', //
    'Diana', 'Ethan', 'Farid',
  ];

  // Predefined list of sentences
  static const List<String> sentences = [
    'This is a sample post.',
    'Flutter is an amazing framework for building apps.',
    'I love coding in Dart.',
    'The weather is great today!',
    'Just finished reading a fantastic book.',
    'Looking forward to the weekend.',
    'What a beautiful day!',
    'I am learning new things every day.',
  ];

  // Function to generate the initial list of posts
  static List<Post> generateInitialFeedItems() {
    final random = Random();
    var messageTime = DateTime.now();

    return List.generate(40, (_) {
      // Calculate the dateTime, decreasing by a random interval
      final secondsToSubtract = random.nextInt(16) + 5; // 5 to 20 seconds
      messageTime = messageTime.subtract(Duration(seconds: secondsToSubtract));

      return generatePost(messageTime);
    });
  }

  // Function to generate a random post
  static Post generatePost(DateTime messageTime) {
    final random = Random();

    // Select a random author
    final author = authors[random.nextInt(authors.length)];

    // Generate a random number of sentences (1 to 3)
    final numberOfSentences = random.nextInt(3) + 1;
    final text = List.generate(
      numberOfSentences,
      (index) => sentences[random.nextInt(sentences.length)],
    ).join(' ');

    return Post(author: author, dateTime: messageTime, text: text);
  }
}
