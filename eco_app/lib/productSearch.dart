import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProductSearchPage extends StatefulWidget {
  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  TextEditingController barCodeController = TextEditingController();
  String barcode = ""; 
  final OpenFoodFactsApi openFoodFactsApi = OpenFoodFactsApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter Demo'),
      //   forceMaterialTransparency: true,
      // ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://thumbs.dreamstime.com/b/clean-energy-2789959.jpg?w=360',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Sustainable Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0), // Add some spacing
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: barCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Product Barcode',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20.0), // Add some spacing
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Get the text from the controller and update the barcode
                  barcode = barCodeController.text;
                });
              },
              child: Text("GO"),
            ),// Add some spacing
            if (barcode.isNotEmpty)
              FutureBuilder(
                future: openFoodFactsApi.getProductInfo(barcode),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final productData = snapshot.data as Map<String, dynamic>;
                    final productName = productData['product']['product_name'];
                    final ecoScore = productData['product']['ecoscore_score'];
                    final String ecoScoreGrade = productData['product']['ecoscore_grade'];

                    return Column(
                      children: [
                        Text(
                          'Stock Name:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          productName,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ), 
                        Text(
                          'Eco-Score:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Impact of the product: ${ecoScoreGrade.toUpperCase()} (Score:$ecoScore/100)',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.network("https://static.openfoodfacts.org/images/misc/ecoscore-impact-environnemental.png"),
                        InkWell(
                          onTap: () => launchUrl(Uri.parse('https://world.openfoodfacts.org/eco-score-the-environmental-impact-of-food-products')),
                          child: Text(
                            'Know More about Eco-Score',
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                          ),
                        )
                      ],
                    );
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

class OpenFoodFactsApi {
  final String baseUrl = 'https://world.openfoodfacts.org/api/v0/product/';

  Future<Map<String, dynamic>> getProductInfo(String barcode) async {
    final response = await http.get(Uri.parse('$baseUrl$barcode.json'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Handle errors here
      throw Exception('Failed to load product information');
    }
  }
}
