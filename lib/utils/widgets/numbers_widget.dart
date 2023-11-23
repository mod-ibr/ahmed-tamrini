import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/model/user.dart';

class NumbersWidget extends StatelessWidget {
  final User trainer;

  const NumbersWidget({Key? key, required this.trainer}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(
            context,
            '${trainer.price} ${context.locale.languageCode == 'ar' ? "د.ع" : 'IQD'}',
            context.locale.languageCode == 'ar' ? 'السعر' : 'Price',
          ),
          buildDivider(),
          buildButton(
            context,
            (trainer.traineesCount ?? 0).toString(),
            tr('subscribers'),
          ),
          // buildDivider(),
          // buildButton(context, '50', 'Followers'),
        ],
      );

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ],
        ),
      );
}
