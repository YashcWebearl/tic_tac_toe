import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final bool isFree;
  final bool isPrime;

  const PackageCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.isFree = false,
    this.isPrime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isPrime)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.emoji_events, size: 18, color: Colors.blue),
                  ),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              fontSize: 16,
                            )),

                      ],
                    ),
                    if (!isFree)
                      // Row(
                      //   children: [
                      //     Text(
                      //       '\$22',
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 20,
                      //         fontFamily: 'Inter',
                      //       ),
                      //     ),
                      //     Text('Or'),
                      //     Row(
                      //       children: [
                      //         Image.asset(
                      //           'assets/coin.png', // Replace with your coin asset
                      //           width: 25,
                      //           height: 25,
                      //         ),
                      //         Text(
                      //           price,
                      //           style: const TextStyle(
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 20,
                      //             fontFamily: 'Inter',
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Plain dollar option
                          Text(
                            'Rs 200',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Inter',
                            ),
                          ),

                          // Separator (subtle visual hint of choice)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              width: 3,
                              height: 24,
                              color: Colors.grey.shade300,
                            ),
                          ),

                          // Coin option
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/coin.png',
                                  width: 22,
                                  height: 22,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )


                  ],
                ),
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isFree ? Colors.green : Colors.red,
                      width: 2,
                    ),
                    // color: isFree ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isFree ? "Active" : "Pay Now",
                    style:  TextStyle(
                      color: isFree ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',

                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
