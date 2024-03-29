import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/common_sheet.dart';

class SearchSheet extends HookConsumerWidget {
  const SearchSheet({
    Key? key,
    required this.searchSheetHeight,
    this.onSearchBarTap,
  }) : super(key: key);

  final double searchSheetHeight;
  final Function()? onSearchBarTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonSheet(
      sheetHeight: searchSheetHeight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Hey there',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onSearchBarTap,
              child: const SearchBar(),
            ),
            //   const SizedBox(height: 22),
            //   const AddFavouriteLocation(
            //     iconData: Icons.home,
            //     location: 'Home',
            //     locationDesc: 'Your residential address',
            //   ),
            //   const SizedBox(height: 16),
            //   const AddFavouriteLocation(
            //     iconData: Icons.work,
            //     location: 'Work',
            //     locationDesc: 'Your office address',
            //   ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RideColors.grey,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,
              0.7,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: const <Widget>[
            Icon(
              Icons.search,
              color: RideColors.primaryColor,
            ),
            SizedBox(width: 10),
            Text(
              'Where are you going?',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddFavouriteLocation extends StatelessWidget {
  const AddFavouriteLocation(
      {Key? key,
      required this.iconData,
      required this.location,
      required this.locationDesc})
      : super(key: key);

  final IconData iconData;
  final String location;
  final String locationDesc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          color: const Color(0xFFadadad),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Add $location'),
            const SizedBox(height: 3),
            Text(
              locationDesc,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFadadad),
              ),
            ),
          ],
        )
      ],
    );
  }
}
