import 'dart:io';

import 'package:e_store/provider/image_provider.dart';
import 'package:e_store/repository/storage_repo.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<bool> isRequest = ValueNotifier(false);

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    final provider =
        Provider.of<ImageProviderFromGallery>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          TextButton(
            onPressed: () {
              StorageRepo.uploadProductToFirebase(
                  context: context,
                  title: _titleController.text,
                  price: _priceController.text,
                  description: _descriptionController.text,
                  isSellingProduct: isRequest);
            },
            child: const Text('Post'),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: isRequest,
          builder: (context, isRequestValue, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text(
                      'Is it a product for sale or request for a product?'),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (isRequest.value) {
                              isRequest.value = !isRequest.value;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: isRequest.value
                                  ? null
                                  : Border.all(
                                      color: Theme.of(context).canvasColor,
                                    ),
                            ),
                            child: const Text('Product'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (!isRequest.value) {
                              isRequest.value = !isRequest.value;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: isRequest.value
                                  ? Border.all(
                                      color: Theme.of(context).canvasColor)
                                  : null,
                            ),
                            child: const Text('Request'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 10,
                    ),
                  const Divider(),
                  if (!isRequest.value) ...[
                    const Text('Upto 3 Photos are allowed'),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      provider.setImageFromCamera();
                                      Navigator.pop(context);
                                    },
                                    title: const Text('Take a photo'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      provider.setImage();
                                      Navigator.pop(context);
                                    },
                                    title: const Text('Pick from gallery'),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    title: const Text('Remove photo'),
                                  ),
                                  ListTile(
                                    onTap: () => Navigator.pop(context),
                                    title: const Text('Cancel'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Consumer<ImageProviderFromGallery>(
                          builder: (context, imageProviderFromGallery, child) {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            imageProviderFromGallery.image != null
                                ? Image(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: height * .15,
                                    image: FileImage(File(
                                        imageProviderFromGallery.image!.path)))
                                : Image(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: height * .15,
                                    image: const AssetImage(
                                        'assets/images/defaultImage.jpeg')),
                            imageProviderFromGallery.image != null
                                ? const SizedBox()
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  )
                          ],
                        );
                      }),
                    ),
                    const Divider(),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isRequest.value)
                    CustomInputField(
                        hintText: 'Title *', controller: _titleController),
                  CustomInputField(
                      hintText: 'Price *',
                      controller: _priceController,
                      keyboardInputType: TextInputType.phone),
                  CustomInputField(
                    hintText: 'Description *',
                    controller: _descriptionController,
                    maxLines: 6,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
