import 'dart:math';

List<Map<String, String>> getRandomizedPlaces(int numberOfPlaces) {
  final random = Random();
  final List<Map<String, String>> placeDetails = [
    {
      'imageUrl':
          'https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1200,h_630/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/hpfkrhkwxohgg8tdq9xe/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%94%E0%B9%87%E0%B8%AD%E0%B8%81%20%E0%B8%AD%E0%B8%B4%E0%B8%99%20%E0%B8%97%E0%B8%B2%E0%B8%A7%E0%B8%99%E0%B9%8C%20(Dog%20In%20Town)%20%E0%B9%83%E0%B8%99%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B9%80%E0%B8%AD%E0%B8%81%E0%B8%A1%E0%B8%B1%E0%B8%A2%20(Ekkamai)%20%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%99%E0%B8%AD%E0%B8%B2%E0%B8%A3%E0%B8%B5%E0%B8%A2%E0%B9%8C%20(Ari).jpg',
      'title': 'Dog in Town Cafe',
      'subtitle': 'Popular | Cafe | Food and Drink',
    },
    {
      'imageUrl':
          'https://partyspacedesign.com/wp-content/uploads/2020/12/660D67D7-56B3-4513-ADB8-8F8D4F78F993.jpeg',
      'title': 'NANA Coffee Roasters',
      'subtitle': 'Cafe | Food and Drink',
    },
    {
      'imageUrl':
          'https://thethaiger.com/th/wp-content/uploads/2023/04/1-5.png',
      'title': 'Vinyl Museum',
      'subtitle': 'Museum',
    },
    {
      'imageUrl':
          'https://asianitinerary.com/wp-content/uploads/2023/03/76a579eae9477daabbb397e3d6eeb142.jpeg',
      'title': 'Bangkok Art and Culture Centre',
      'subtitle': 'Art | Museum',
    },
    {
      'imageUrl':
          'https://ik.imagekit.io/tvlk/blog/2018/06/siam-800x450.jpg?tr=dpr-2,w-675',
      'title': 'Iconsiam',
      'subtitle': 'Popular | Shopping',
    },
    {
      'imageUrl':
          'https://ik.imagekit.io/tvlk/blog/2018/06/%E0%B9%80%E0%B8%AD%E0%B9%80%E0%B8%8A%E0%B8%B5%E0%B8%A2%E0%B8%97%E0%B8%B5%E0%B8%84-800x534.jpg?tr=dpr-2,w-675',
      'title': 'Asiatique The Riverfront',
      'subtitle': 'Popular | Shopping',
    },
    // Add more details as needed
  ];

  return List.generate(
      numberOfPlaces, (_) => placeDetails[random.nextInt(placeDetails.length)]);
}
