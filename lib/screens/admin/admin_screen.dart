// import 'dart:async';
// import 'dart:html' as html;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   State<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _productPriceController = TextEditingController();
//   final TextEditingController _productDescriptionController =
//       TextEditingController();

//   String? _uploadedImageUrl;
//   String? _selectedImageName;
//   bool _isLoading = false;

//   // Cloudinary credentials
//   final String _cloudinaryCloudName = 'dgppqmq3t'; // Your cloud name
//   final String _cloudinaryUploadPreset = 'ml_default'; // Replace with your actual unsigned upload preset from Cloudinary dashboard

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     _productPriceController.dispose();
//     _productDescriptionController.dispose();
//     super.dispose();
//   }

//   // Pick image from gallery (Web compatible)
//   Future<void> _pickImage() async {
//     try {
//       // Web platform - use HTML file input
//       html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
//         ..accept = 'image/*'
//         ..click();

//       uploadInput.onChange.listen((e) async {
//         final files = uploadInput.files;
//         if (files != null && files.isNotEmpty) {
//           final file = files[0];
//           setState(() {
//             _selectedImageName = file?.name ?? 'image';
//           });

//           // Upload immediately
//           await _uploadImageToCloudinary(file);
//         }
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error picking image: $e');
//     }
//   }

//   // Upload image to Cloudinary
//   Future<bool> _uploadImageToCloudinary(dynamic file) async {
//     if (file == null) {
//       Fluttertoast.showToast(msg: 'Please select an image');
//       return false;
//     }

//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       final uri = Uri.parse(
//           'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload');

//       final request = http.MultipartRequest('POST', uri);
//       request.fields['upload_preset'] = _cloudinaryUploadPreset;

//       // Handle web file upload
//       try {
//         // Read file as array buffer
//         final reader = html.FileReader();
//         final completer = Completer<List<int>>();
        
//         reader.onLoad.listen((_) {
//           final result = reader.result;
//           if (result is List<int>) {
//             completer.complete(result);
//           } else {
//             completer.completeError('Failed to read file');
//           }
//         });
        
//         reader.onError.listen((_) {
//           completer.completeError('Error reading file');
//         });
        
//         reader.readAsArrayBuffer(file);
//         final bytes = await completer.future;

//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: file.name,
//           ),
//         );
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Error reading file: $e');
//         return false;
//       }

//       final response = await request.send();
//       final responseData = await response.stream.toBytes();
//       final responseString = String.fromCharCodes(responseData);

//       if (response.statusCode == 200) {
//         final imageUrl = _extractImageUrl(responseString);
//         if (imageUrl.isNotEmpty) {
//           setState(() {
//             _uploadedImageUrl = imageUrl;
//           });
//           Fluttertoast.showToast(msg: 'Image uploaded successfully!');
//           return true;
//         } else {
//           Fluttertoast.showToast(msg: 'Failed to extract image URL');
//           return false;
//         }
//       } else {
//         // Print the error response for debugging
//         print('Cloudinary Error Response: $responseString');
//         try {
//           final errorJson = jsonDecode(responseString);
//           final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
//           Fluttertoast.showToast(
//               msg: 'Upload failed: $errorMessage');
//         } catch (_) {
//           Fluttertoast.showToast(
//               msg: 'Upload failed: ${response.statusCode}');
//         }
//         return false;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error uploading image: $e');
//       return false;
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Extract image URL from Cloudinary response
//   String _extractImageUrl(String jsonResponse) {
//     try {
//       final json = jsonDecode(jsonResponse);
//       return json['secure_url'] ?? json['url'] ?? '';
//     } catch (e) {
//       print('Error parsing response: $e');
//       return '';
//     }
//   }

//   // Add product with image
//   Future<void> _addProduct() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (_uploadedImageUrl == null) {
//       Fluttertoast.showToast(msg: 'Please upload an image');
//       return;
//     }

//     // Here you can save the product to Firebase or your backend
//     final productData = {
//       'name': _productNameController.text,
//       'price': _productPriceController.text,
//       'description': _productDescriptionController.text,
//       'imageUrl': _uploadedImageUrl,
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     Fluttertoast.showToast(msg: 'Product added: ${productData['name']}');

//     // Reset form
//     _formKey.currentState!.reset();
//     setState(() {
//       _uploadedImageUrl = null;
//       _selectedImageName = null;
//     });
//     _productNameController.clear();
//     _productPriceController.clear();
//     _productDescriptionController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin - Add Product'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Name
//               TextFormField(
//                 controller: _productNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Product Name',
//                   hintText: 'Enter product name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(Icons.shopping_bag),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter product name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Product Price
//               TextFormField(
//                 controller: _productPriceController,
//                 decoration: InputDecoration(
//                   labelText: 'Product Price',
//                   hintText: 'Enter product price',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(Icons.currency_rupee),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter product price';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Product Description
//               TextFormField(
//                 controller: _productDescriptionController,
//                 decoration: InputDecoration(
//                   labelText: 'Product Description',
//                   hintText: 'Enter product description',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   prefixIcon: const Icon(Icons.description),
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter product description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),

//               // Image Section
//               const Text(
//                 'Product Image',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // Image Preview or Placeholder
//               Container(
//                 height: 250,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: _uploadedImageUrl != null
//                     ? Image.network(
//                         _uploadedImageUrl!,
//                         fit: BoxFit.cover,
//                       )
//                     : const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.image, size: 50, color: Colors.grey),
//                             SizedBox(height: 8),
//                             Text('No image uploaded yet'),
//                           ],
//                         ),
//                       ),
//               ),
//               const SizedBox(height: 12),

//               // Pick Image Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.image_search),
//                   label: const Text('Pick Image'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//               if (_selectedImageName != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text('Selected: $_selectedImageName',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ),
//               const SizedBox(height: 24),

//               // Add Product Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _addProduct,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Icon(Icons.add_box),
//                   label: Text(_isLoading ? 'Adding...' : 'Add Product'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ),

//               // Status message
//               if (_uploadedImageUrl != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.check_circle, color: Colors.green),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text('Image uploaded successfully!',
//                               style: TextStyle(color: Colors.green)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
