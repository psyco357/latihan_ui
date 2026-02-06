import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../auth/controllers/auth_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 80),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer(
                    builder: (context, authProvider, child) {
                      final username = 'Guest';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Namaste!!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            username,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle notification button press
                  },
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.notifications,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
