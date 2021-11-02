import 'package:aerotec_flutter_app/models/components_model.dart';
import 'package:aerotec_flutter_app/providers/components_provider.dart';
import 'package:aerotec_flutter_app/screens/components/components_form.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentsDetails extends StatelessWidget {
  final String componentId;
  ComponentsDetails({ required this.componentId });

  @override
  Widget build(BuildContext context) {
    final ComponentsProvider componentsProvider = Provider.of<ComponentsProvider>(context);
    final ComponentsModel component = componentsProvider.componentsProvider.singleWhere((element) => element.id == componentId);

    return Scaffold(
      appBar: AppBar(
        title: Text('${component.name}'),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(component.name),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ComponentsForm(
                          component: component,
                          formType: 'edit',
                        ),
                      ),
                    ),
                    child: Container(
                      width: 90,
                      child: Center(child: Text('Edit')),
                    ),
                  ),
                ],
              ),
              if(componentsProvider.isLoading) LoadingOverlay()
            ],
          ),
        ),
      ),
    );
  }
}
