import 'package:aerotec_flutter_app/models/equipment_model.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final EquipmentModel equipment;
  final int index;
  final int link;

  const EquipmentCard({Key? key, required this.equipment, required this.index, this.link = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> filename = equipment.fields['filename']?.split('.') ?? [null];
    String? imageUrl = filename[0];

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: (index == 0) ? BorderSide(color: Theme.of(context).dividerColor) : BorderSide.none,
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, _, __) => EquipmentDetails(id: this.equipment.id)));
        },
        child: ListTile(
          leading: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey,
            ),
            child: ClipOval(
              child: imageUrl == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'N/A',
                          style: TextStyle(height: 1, fontSize: 11, color: Colors.white),
                        ),
                      ],
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/aerotec%2Fequipment%2F${imageUrl.toString()}_200x200.jpeg?alt=media',
                      width: 125,
                      height: 125,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
            ),
          ),
          title: Text('${equipment.fields['name']}'),
          // subtitle: Text('${equipment.length} ${equipment.type} ${equipment.safeWorkingLoad}#'),
          trailing: (link == 1) ? Icon(Icons.navigate_next_sharp) : null,
        ),
      ),
    );
  }
}

// https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/equipment%2F

// ?alt=media&token
