import 'package:flutter/material.dart';


class GalleryItem {
  final String imageUrl;
  final String description;

  GalleryItem({required this.imageUrl, required this.description});
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample gallery items that resemble what's shown in the shared image
    final List<GalleryItem> galleryItems = [
      GalleryItem(
        imageUrl: 'https://via.placeholder.com/400x300',
        description: 'A young boy playing soccer on a green field',
      ),
      GalleryItem(
        imageUrl: 'https://via.placeholder.com/400x300',
        description: 'A medieval painting depicting horsemen in battle',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: galleryItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          galleryItems[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          galleryItems[index].description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}