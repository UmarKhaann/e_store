import 'dart:io';

import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductSellingFormView extends StatefulWidget {
  const ProductSellingFormView({Key? key}) : super(key: key);

  @override
  State<ProductSellingFormView> createState() => _ProductSellingFormViewState();
}

class _ProductSellingFormViewState extends State<ProductSellingFormView> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  XFile? image;

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                getImage();
              },
              child: Stack(
                children: [
                  image != null
                      ? Image(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: height * .2,
                          image: FileImage(File(image!.path)))
                      : Image(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: height * .2,
                          image: const AssetImage('assets/images/defaultImage.jpeg')),
                  image != null?
                      const SizedBox():
                  Positioned(
                      bottom: height * .01,
                      right: width * .3,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          Text(
                            'Add Images',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInputField(hintText: 'Title', controller: titleController),
            CustomInputField(
                hintText: 'Price',
                controller: priceController,
                keyboardInputType: TextInputType.phone),
            CustomInputField(
                hintText: 'Phone Number',
                controller: phoneController,
                keyboardInputType: TextInputType.phone),
            CustomInputField(
              hintText: 'Description',
              controller: descriptionController,
              maxLines: 6,
            ),
            Expanded(child: Container()),
            Hero(
                tag: 'btn',
                child: CustomButton(text: 'Post Now', onPressed: () {})),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
