import 'dart:math';

List<Map<String, dynamic>> getSuggestPlan() {
  final List<Map<String, dynamic>> placeDetails = [
    {
      "planName": "Let's go SIAM!",
      "startTime": "15:51",
      "startDate": "30/9/2024",
      "category": ["cafe", "art_gallery"],
      "numberOfPlaces": 3,
      "planID": "f208ec79-eba5-481c-bdef-a0d02a614fd6",
      "selectedPlaces": {
        "ChIJS69KQhyf4jARWKn666Gkah0": {
          "id": "ChIJS69KQhyf4jARWKn666Gkah0",
          "displayName": "LV The Place Bangkok - Le Café Louis Vuitton",
          "primaryType": "cafe",
          "shortFormattedAddress":
              "496 Gaysorn Amarin, Unit GF-S01-B, Ground Floor, 502 Thanon Phloen Chit, Khwaeng Lumphini, Pathum Wan",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqE-MIhSEpFHUD561OKwfh_51X-5tlQtAWd7s_3q-3iEHCnEGK4h22fqZq2WS0yU8P72qwi5P9E5nmlAA4xOqlLHJpKWc_ghhcs=s4800-w500",
          "time": "3:51 PM"
        },
        "ChIJbe25_-ef4jARV-5TlH5efNw": {
          "id": "ChIJbe25_-ef4jARV-5TlH5efNw",
          "displayName": "good goods at Central World",
          "primaryType": "store",
          "shortFormattedAddress":
              "centralwOrld, ชั้นที่ 1 โซน D, D125, Thanon Ratchadamri, Khwaeng Pathum Wan, Pathum Wan",
          "photosUrl":
              "https://tourist.centralgroup.com/glide/storage/highlight/2022/08/20220803-cover.jpeg?h=350&fit=max&fm=jpg&t=1726499055",
          "time": "4:51 PM"
        },
        "ChIJfWxvUM2e4jARCxWWp4sC0B4": {
          "id": "ChIJfWxvUM2e4jARCxWWp4sC0B4",
          "displayName": "Bangkok Art and Culture Centre",
          "primaryType": "art_gallery",
          "shortFormattedAddress":
              "939 Rama I Rd, Khwaeng Wang Mai, Pathum Wan",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqExw01F9R2TtOqTa6mXrqFhmzRd1e_P9ZIswAIRYqnSpHQT_8R5FXtpJFCK-4kmOMSRhuVMfh1XxnY625URXwPgZ4PHqGiunxk=s4800-w500",
          "time": "5:51 PM"
        }
      }
    },
    {
      "planName": "Eating at ChinaTown",
      "startTime": "05:00",
      "startDate": "5/10/2024",
      "category": ["restaurant"],
      "numberOfPlaces": 5,
      "planID": "bfa97373-b9f5-4fd9-bd3a-be2af48c78c7",
      "selectedPlaces": {
        "ChIJ3Sbd0P6Z4jARdVP-cMH6PmY": {
          "id": "ChIJ3Sbd0P6Z4jARdVP-cMH6PmY",
          "displayName": "On Lok Yun",
          "primaryType": "breakfast_restaurant",
          "shortFormattedAddress":
              "72 Charoen Krung Road, Khwaeng Wang Burapha Phirom, Khet Phra Nakhon",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqEnf9gbm1HZ6kxOFka0drgAbAEuv6zzQaZqR0hn4LZ3DdgYB3_t6OvsBtnaLITkVMNWPwRaDiEK8wd8QoQbYfUVpp0Uj9tiw8g=s4800-w500",
          "time": "5:00 AM"
        },
        "ChIJ1TKQhxmZ4jAR0wOe8ro3msA": {
          "id": "ChIJ1TKQhxmZ4jAR0wOe8ro3msA",
          "displayName": "CQK Mala Hotpot สามย่าน - บรรทัดทอง",
          "primaryType": "restaurant",
          "shortFormattedAddress":
              "1818 ถนน บรรทัดทอง Khwaeng Rong Muang, Pathum Wan",
          "photosUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIg6rZ2dYf8QZysovGsdRkujcnzEn-1x5UZA&s",
          "time": "6:00 AM"
        },
        "ChIJFVMU6y6Z4jARfM273-HwetM": {
          "id": "ChIJFVMU6y6Z4jARfM273-HwetM",
          "displayName": "Jeh O Chula",
          "primaryType": "thai_restaurant",
          "shortFormattedAddress":
              "113 ซอย จรัสเมือง Khwaeng Rong Muang, Pathum Wan",
          "photosUrl":
              "https://s3.ap-southeast-1.amazonaws.com/foodnote.guide/wp-content/uploads/2017/08/10011600/25600806-Red-03456-1024x683.jpg",
          "time": "7:00 AM"
        },
        "ChIJcQ8J1TCZ4jARRBaANjybQI0": {
          "id": "ChIJcQ8J1TCZ4jARRBaANjybQI0",
          "displayName": "Chula 50 Kitchen",
          "primaryType": "thai_restaurant",
          "shortFormattedAddress":
              "262 ซ. จุฬาลงกรณ์ 50 Khwaeng Wang Mai, Pathum Wan",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqF-f_6UnBgsMrOzKJ-w4w0Z5jJHitBfZw6IBBz_-H24eZmBXE3JBqLQg1B-zZlkLxqZ5WjTiCAO8l4mDbyZcOK20LRZUV-qdSo=s4800-w500",
          "time": "8:00 AM"
        },
        "ChIJl-fumtGY4jARTrlCA7w6pgI": {
          "id": "ChIJl-fumtGY4jARTrlCA7w6pgI",
          "displayName": "Somboon Seafood",
          "primaryType": "seafood_restaurant",
          "shortFormattedAddress":
              "169 / 7-12 Surawong Rd, Khwaeng Suriya Wong, Khet Bang Rak",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqHF_iGKk_cmPUaHchLrrj5IBONTcn0deWvpsCd8pNMHyJBWPlXVVJICMlNPwcB0AKtjPme2ZMdw4cIzJPDvkZTX-_8CuRAg2aI=s4800-w500",
          "time": "9:00 AM"
        }
      }
    },
    {
      "planName": "Thonglor",
      "startTime": "12:00",
      "startDate": "15/10/2024",
      "category": ["restaurant", "cafe", "park", "museum", "store"],
      "numberOfPlaces": 4,
      "planID": "d2485d5e-bc44-4814-9417-1f4e4c532812",
      "selectedPlaces": {
        "ChIJTUsNVjOf4jARkGF5xIeIJCY": {
          "id": "ChIJTUsNVjOf4jARkGF5xIeIJCY",
          "displayName": "Here Hai เฮียให้",
          "primaryType": "seafood_restaurant",
          "shortFormattedAddress":
              "112, 1 Thanon Ekkamai, Khwaeng Khlong Tan Nuea, Watthana",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqHyiXpwtrGFs7MSQINd0FFae5s0a0P_Bz1GpcQHjtlr2Soruv3XAdXayYgqiyQIdj3IDWvPAN4s1vtuWRPWj9BJlKbT3vf2KdQ=s4800-w500",
          "time": "3:00 PM"
        },
        "ChIJq94J_q2f4jARPqrdRxqs9Qg": {
          "id": "ChIJAyjSgBef4jARDsY_DiAnHIk",
          "displayName": "Big C Extra Rama IV",
          "primaryType": "supermarket",
          "shortFormattedAddress":
              "2929 Thanon Rama IV, Khwaeng Khlong Tan, Khet Khlong Toei",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqHit5h2Tm3paA6xBhpFzGDGUQ9NGCWbC3F-AbDDo8Ws_Z1UK1vqIry1EiezoCzW7JAnwoGrOf6PdqZtAJuCWyrjSJ10eERBHGo=s4800-w500",
          "time": "12:00 PM"
        },
        "ChIJFYJ6q7ef4jARBeF4ZjmUEHk": {
          "id": "ChIJFYJ6q7ef4jARBeF4ZjmUEHk",
          "displayName": "IKEA Sukhumvit",
          "primaryType": "furniture_store",
          "shortFormattedAddress":
              "3rd floor, Emsphere, Sukhumvit Rd, Khwaeng Khlong Tan, Khet Khlong Toei",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqERJO3_gWQbQbC1Ls6rstAbCJHDMpDOpS3LL8i9DoQ0KzkrQRvHFQ7CClsgTIdW_oS5imiirYYab76fNlaqmhNtOhBEZIUw0AI=s4800-w500",
          "time": "1:00 PM"
        },
        "ChIJuWuZbh6f4jAReZMEm2xxgzM": {
          "id": "ChIJuWuZbh6f4jAReZMEm2xxgzM",
          "displayName": "Terminal 21 Asok",
          "primaryType": "shopping_mall",
          "shortFormattedAddress":
              "88 ซอย สุขุมวิท 19, Soi Sukhumvit 19, Khwaeng Khlong Toei Nuea, Watthana",
          "photosUrl":
              "https://lh3.googleusercontent.com/places/ANXAkqHDXKkPWUgv7XwpCLcb73yJL4MEANlHnDAEc9uvofkMYl7Ck11Tb9SekMyEXI2z-46iig0jKlW1cU3jGyZw6TFxafX6DdvEQ2I=s4800-w500",
          "time": "2:00 PM"
        },
      }
    },
  ];

  return placeDetails;
}
