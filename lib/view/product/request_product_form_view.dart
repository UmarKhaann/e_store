import 'dart:io';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/view_model/storage_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/imageProvider.dart';

class RequestProductFormView extends StatefulWidget {
  const RequestProductFormView({Key? key}) : super(key: key);

  @override
  State<RequestProductFormView> createState() => _RequestProductFormViewState();
}

class _RequestProductFormViewState extends State<RequestProductFormView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<ImageProviderFromGallery>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Request Product'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: StorageModel.btnUploadData,
        builder: (context, value, child){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    provider.setImage();
                  },
                  child: Consumer<ImageProviderFromGallery>(
                      builder: (context, imageProviderFromGallery, child) {
                        return Stack(
                          children: [
                            imageProviderFromGallery.image != null
                                ? Image(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                height: height * .2,
                                image: FileImage(File(imageProviderFromGallery.image!.path)))
                                : Image(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                height: height * .2,
                                image: const AssetImage(
                                    'assets/images/defaultImage.jpeg')),
                            imageProviderFromGallery.image != null
                                ? const SizedBox()
                                : Positioned(
                                bottom: height * .01,
                                right: width * .3,
                                child: const Row(
                                  children: [
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
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInputField(hintText: 'Title', controller: _titleController),
                CustomInputField(
                    hintText: 'Price',
                    controller: _priceController,
                    keyboardInputType: TextInputType.phone),
                CustomInputField(
                  hintText: 'Description',
                  controller: _descriptionController,
                  maxLines: 6,
                ),
                Expanded(child: Container()),
                CustomButton(
                    text: 'Post Now',
                    isLoading: StorageModel.btnUploadData.value,
                    onPressed: () {
                      StorageModel.uploadProductToFirebase(
                          context: context,
                          title: _titleController.text,
                          price: _priceController.text,
                          description: _descriptionController.text,
                          uploadType: 'productsRequest'
                      );
                    }),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
