import 'package:flutter/material.dart';

class PlaceDetailCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  PlaceDetailCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available', style: TextStyle(fontWeight: FontWeight.bold),));
                },
              )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  Icon(
                  Icons.place,
                  color: primaryColor,
                ),
                const SizedBox(width: 5),
                Text('2 km', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryColor)),
                ],)
              ],
            )
          ),
        ],
      ),
    );
  }
}
