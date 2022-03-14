import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/widgets/empty_content.dart';

class MainMenu extends HookConsumerWidget {
  const MainMenu({
    Key? key,
    this.onReset,
    this.onRevealKey,
  }) : super(key: key);

  final GestureTapCallback? onReset;
  final GestureTapCallback? onRevealKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 300,
      child: Drawer(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const HeaderSection(),
            const SizedBox(height: 5),
            ListTile(
              title: const Text('Wallet'),
              subtitle: const Text('View Account Balance and Holdings'),
              leading: const Icon(Icons.wallet_membership),
              onTap: () => context.go('/passenger/wallet'),
            ),
            const SizedBox(height: 5),
            const Divider(height: 1, color: Color(0xffe2e2e2), thickness: 1),
            ListTile(
              title: const Text('Private key'),
              subtitle: const Text('Reveal your private key'),
              leading: const Icon(Icons.vpn_key),
              onTap: onRevealKey,
            ),
            ListTile(
              title: const Text('Reset wallet'),
              subtitle: const Text('Wipe all wallet data'),
              leading: const Icon(
                Icons.warning,
                color: Colors.orange,
              ),
              onTap: onReset,
            ),
            ListTile(
              title: const Text('Drive with Ride'),
              leading: const Icon(Icons.drive_eta),
              onTap: () => context.go('/apply_driver'),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends HookConsumerWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return SizedBox(
      height: 250,
      child: DrawerHeader(
        child: auth.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (errorMsg) => EmptyContent(
            title: 'Something went wrong',
            message: errorMsg ?? '',
          ),
          unAuthenticated: () => const EmptyContent(
            title: 'Sorry, you\'ve been logged out',
            message: '',
          ),
          authenticated: (accountData) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: SvgPicture.string(
                  Jdenticon.toSvg(accountData.publicKey),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                accountData.publicKey,
                style: const TextStyle(fontSize: 12, fontFamily: 'Brand-Bold'),
              ),
              // if (accountData.accountType == AccountType.admin)
              //   ListTile(
              //     title: const Text('Admin Panel'),
              //     subtitle: const Text('Ride Administration'),
              //     leading: const Icon(Icons.admin_panel_settings),
              //     onTap: () => context.go('/admin'),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
