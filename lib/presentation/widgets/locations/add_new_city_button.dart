import 'package:blur/blur.dart';
import 'package:d_button/d_button.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_forecast/commons/extension.dart';

class AddNewCityButton extends StatefulWidget {
  const AddNewCityButton({super.key, required this.onAdd});
  final void Function(String cityName, String imagePath) onAdd;

  @override
  State<AddNewCityButton> createState() => _AddNewCityButtonState();
}

class _AddNewCityButtonState extends State<AddNewCityButton> {
  final TextEditingController edtCity = TextEditingController();
  final Rx<XFile> cityImage = XFile('').obs;

  pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      cityImage.value = xFile;
    }
  }

  showModal() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DInput(
              controller: edtCity,
              radius: BorderRadius.circular(16),
              hint: 'Type city name',
              autofocus: true,
            ),
            DView.height(),
            Row(
              children: [
                DButtonBorder(
                  borderColor: Colors.blueGrey,
                  width: 120,
                  height: 46,
                  radius: 16,
                  onClick: () => pickImage(),
                  child: const Text('Add Image'),
                ),
                DView.width(),
                Expanded(
                  child: Obx(() {
                    String initName = cityImage.value.name;
                    return Text(
                      initName == '' ? 'No Image' : initName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                )
              ],
            ),
            DView.height(),
            DButtonElevation(
              height: 46,
              radius: 16,
              onClick: () {
                if (edtCity.text == '') return;
                widget.onAdd(
                  edtCity.text.capitalEachWord,
                  cityImage.value.path,
                );
                edtCity.text = '';
                cityImage.value = XFile('');
              },
              mainColor: Theme.of(context).primaryColor,
              child: const Text(
                'Add City',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DButtonFlat(
      mainColor: Colors.transparent,
      height: 46,
      onClick: () => showModal(),
      radius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle_outlined,
            color: Colors.white,
          ),
          DView.width(8),
          const Text(
            'Add New City',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    ).frosted(
      blur: 2,
      borderRadius: BorderRadius.circular(16),
      frostColor: Colors.blueGrey,
      frostOpacity: 0.5,
    );
  }
}
