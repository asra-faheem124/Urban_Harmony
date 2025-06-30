import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Laptops',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Compare, Sort, Filter bar
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromARGB(255, 184, 183, 183)), // Outer black border
              ),
              child: Row(
                children: [
                  // Compare
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: const Color.fromARGB(255, 184, 183, 183)), // Divider
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.compare_arrows, size: 22, color: Colors.black),
                          SizedBox(width: 6),
                          TextButton(
                            onPressed: (){},
                            child: Text( 'Compare',
                            style: TextStyle(fontSize: 16, color: Colors.black),)
                           
                          ),
                          
                        ],
                      ),
                    ),
                  ),
            
                  // Sort
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: const Color.fromARGB(255, 184, 183, 183)), // Divider
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort, size: 22, color: Colors.black),
                          SizedBox(width: 6),
                         TextButton(
                            onPressed: (){},
                            child: Text( 'Sort',
                            style: TextStyle(fontSize: 16, color: Colors.black),)
                           
                          ),
                        ],
                      ),
                    ),
                  ),
            
                  // Filter
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.filter_list, size: 22, color: Colors.black),
                          SizedBox(width: 6),
                         TextButton(
                            onPressed: (){},
                            child: Text( 'Filter',
                            style: TextStyle(fontSize: 16, color: Colors.black),)
                           
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Placeholder for rest of the body
          const SizedBox(height: 20),
        Card(
          color: Colors.white,
  
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Laptop Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/laptop1.png'), fit: BoxFit.cover),
             
              ), // decoration
            ), // Container (Image)

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Acer Aspire 5 Core i5 10th Gen - (8 GB/512 GB SSD/Windows 10 Ho...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ), // Text (Title)

                  const SizedBox(height: 6),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '4.4',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ), // Row (Rating content)
                      ), // Container (Rating box)

                      const SizedBox(width: 6),

                      const Text(
                        '(130)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ), // Text (Reviews)
                    ],
                  ), // Row (Rating)

                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    children: const [
                      Text(
                        '₹53,990',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ), // Text (Current Price)

                      SizedBox(width: 8),

                      Text(
                        '₹69,949',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ), // Text (Original Price)

                      SizedBox(width: 6),

                      Text(
                        '10% off',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Text (Discount)
                    ],
                  ), // Row (Price)

                  const SizedBox(height: 6),

                  // Offer Row
                  Row(
                    children: const [
                      Icon(Icons.local_offer, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Upto ₹14,850 Off on Exchange No Cost EMI',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), // Expanded (Offer Text)
                    ],
                  ), // Row (Offer)
                ],
              ), // Column (Details)
            ), // Expanded (Right Side)
          ],
        ), // Row (Main)
      ), // Padding
    ),
     const SizedBox(height: 20),
        Card(
          color: Colors.white,
  
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Laptop Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/laptop1.png'), fit: BoxFit.cover),
             
              ), // decoration
            ), // Container (Image)

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Acer Aspire 5 Core i5 10th Gen - (8 GB/512 GB SSD/Windows 10 Ho...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ), // Text (Title)

                  const SizedBox(height: 6),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '4.4',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ), // Row (Rating content)
                      ), // Container (Rating box)

                      const SizedBox(width: 6),

                      const Text(
                        '(130)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ), // Text (Reviews)
                    ],
                  ), // Row (Rating)

                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    children: const [
                      Text(
                        '₹53,990',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ), // Text (Current Price)

                      SizedBox(width: 8),

                      Text(
                        '₹69,949',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ), // Text (Original Price)

                      SizedBox(width: 6),

                      Text(
                        '10% off',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Text (Discount)
                    ],
                  ), // Row (Price)

                  const SizedBox(height: 6),

                  // Offer Row
                  Row(
                    children: const [
                      Icon(Icons.local_offer, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Upto ₹14,850 Off on Exchange No Cost EMI',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), // Expanded (Offer Text)
                    ],
                  ), // Row (Offer)
                ],
              ), // Column (Details)
            ), // Expanded (Right Side)
          ],
        ), // Row (Main)
      ), // Padding
    ),
     const SizedBox(height: 20),
        Card(
          color: Colors.white,
  
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Laptop Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/laptop1.png'), fit: BoxFit.cover),
             
              ), // decoration
            ), // Container (Image)

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Acer Aspire 5 Core i5 10th Gen - (8 GB/512 GB SSD/Windows 10 Ho...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ), // Text (Title)

                  const SizedBox(height: 6),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '4.4',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ), // Row (Rating content)
                      ), // Container (Rating box)

                      const SizedBox(width: 6),

                      const Text(
                        '(130)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ), // Text (Reviews)
                    ],
                  ), // Row (Rating)

                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    children: const [
                      Text(
                        '₹53,990',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ), // Text (Current Price)

                      SizedBox(width: 8),

                      Text(
                        '₹69,949',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ), // Text (Original Price)

                      SizedBox(width: 6),

                      Text(
                        '10% off',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Text (Discount)
                    ],
                  ), // Row (Price)

                  const SizedBox(height: 6),

                  // Offer Row
                  Row(
                    children: const [
                      Icon(Icons.local_offer, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Upto ₹14,850 Off on Exchange No Cost EMI',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), // Expanded (Offer Text)
                    ],
                  ), // Row (Offer)
                ],
              ), // Column (Details)
            ), // Expanded (Right Side)
          ],
        ), // Row (Main)
      ), // Padding
    )
,
 const SizedBox(height: 20),
        Card(
          color: Colors.white,
  
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Laptop Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/laptop1.png'), fit: BoxFit.cover),
             
              ), // decoration
            ), // Container (Image)

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Acer Aspire 5 Core i5 10th Gen - (8 GB/512 GB SSD/Windows 10 Ho...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ), // Text (Title)

                  const SizedBox(height: 6),

                  // Rating Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '4.4',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ), // Row (Rating content)
                      ), // Container (Rating box)

                      const SizedBox(width: 6),

                      const Text(
                        '(130)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ), // Text (Reviews)
                    ],
                  ), // Row (Rating)

                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    children: const [
                      Text(
                        '₹53,990',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ), // Text (Current Price)

                      SizedBox(width: 8),

                      Text(
                        '₹69,949',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ), // Text (Original Price)

                      SizedBox(width: 6),

                      Text(
                        '10% off',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Text (Discount)
                    ],
                  ), // Row (Price)

                  const SizedBox(height: 6),

                  // Offer Row
                  Row(
                    children: const [
                      Icon(Icons.local_offer, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Upto ₹14,850 Off on Exchange No Cost EMI',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), // Expanded (Offer Text)
                    ],
                  ), // Row (Offer)
                ],
              ), // Column (Details)
            ), // Expanded (Right Side)
          ],
        ), // Row (Main)
      ), // Padding
    )        ],
      ),
    );
  }
}