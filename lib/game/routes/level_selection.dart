import 'package:flutter/material.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key, this.onLevelSelected, this.onBackPressed});

  static const id = 'LevelSelecion';

  final ValueChanged<int>? onLevelSelected;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Level Select',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 50,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return OutlinedButton(
                    onPressed: () => onLevelSelected?.call(index + 1),
                    child: Text('Level ${index + 1}'),
                  );
                },
                itemCount: 4,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 100),
              ),
            ),
            const SizedBox(height: 5),
            IconButton(
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
