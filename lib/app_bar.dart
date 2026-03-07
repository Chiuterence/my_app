import 'package:flutter/material.dart';

AppBar buildAppBar({String? loggedInUser, VoidCallback? onLogout}) {
  return AppBar(
    title: const Text('Demo App'),
    centerTitle: true,
    backgroundColor: Colors.white,
    actions: [
      if (loggedInUser != null && onLogout != null)
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle_outlined),
          tooltip: loggedInUser,
          onSelected: (value) {
            if (value == 'logout') onLogout();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              enabled: false,
              child: Text(
                loggedInUser,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Log Out'),
                ],
              ),
            ),
          ],
        ),
    ],
  );
}
