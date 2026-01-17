import 'package:flutter/material.dart';

import 'home.dart';

class SelectedStore extends StatelessWidget {
  const SelectedStore({
    super.key,
    required this.store,
  });

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        store.name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
      ),
      subtitle: Text(
        'Sliver Monthly - 0/3000 - Exp: ${DateTime.now()}',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () => BlocProvider.of<AppBloc>(context).add(
          NavigateToStoreListScreen(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.switch_right,
              size: 20.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              'Switch Store',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
