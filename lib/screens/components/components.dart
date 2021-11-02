import 'components_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:aerotec_flutter_app/models/components_model.dart';
import 'package:aerotec_flutter_app/providers/components_provider.dart';
class ComponentsScreen extends StatefulWidget {
  @override
  _ComponentsScreen createState() => _ComponentsScreen();
}

class _ComponentsScreen extends State<ComponentsScreen> {
  late ComponentsProvider componentsProvider;

  @override
  void initState() {
    super.initState();
    componentsProvider = Provider.of<ComponentsProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        componentsProvider.subData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ComponentsProvider componentsProvider = Provider.of<ComponentsProvider>(context);
    return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[300],
                  width: double.infinity,
                  child: Text(
                    'Components',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: componentsProvider.componentsProvider.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(height: 20, thickness: 2, indent: 1),
                    itemBuilder: (_, int index) {
                      final ComponentsModel component =
                          componentsProvider.componentsProvider[index];
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          title: Text('${component.name}'),
                          subtitle: Text('- Component info here -'),
                          leading: Icon(Icons.info_sharp, color: Colors.blue),
                          trailing: Icon(Icons.navigate_next_sharp),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ComponentsDetails(
                                componentId: component.id,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if(componentsProvider.isLoading) LoadingOverlay()
          ],
        ),
      );
  }
}
