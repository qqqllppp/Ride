import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ride/app/wallet/widgets/copy_button.dart';

class DisplayMnemonic extends HookWidget {
  const DisplayMnemonic({Key? key, required this.mnemonic, this.onNext})
      : super(key: key);

  final String mnemonic;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                'Get a piece of paper, write down your seed phrase and keep it safe. This is the only way to recover your funds.',
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.all(25),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(mnemonic, textAlign: TextAlign.center),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CopyButton(text: const Text('Copy'), value: mnemonic),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text('Next'),
                    onPressed: onNext,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
