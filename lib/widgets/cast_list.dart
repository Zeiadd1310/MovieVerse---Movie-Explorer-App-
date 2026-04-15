/*import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  const CastList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cast = [
      {'name': 'Matthew McConaughey', 'url': 'https://via.placeholder.com/150'},
      {'name': 'Anne Hathaway', 'url': 'https://via.placeholder.com/150'},
      {'name': 'Jessica Chastain', 'url': 'https://via.placeholder.com/150'},
    ];

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Cast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('See All', style: TextStyle(color: Color(0xFFFFC107), fontSize: 14)),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    CircleAvatar(radius: 30, backgroundImage: NetworkImage(cast[index]['url']!)),
                    const SizedBox(height: 8),
                    Text(cast[index]['name']!.split(' ')[0], style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}*/