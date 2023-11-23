import 'package:flutter/material.dart';

class ExpansionText extends StatefulWidget {
  final String title;
  final dynamic content;
  const ExpansionText({super.key, required this.title, required this.content});

  @override
  State<ExpansionText> createState() => _ExpansionTextState();
}

class _ExpansionTextState extends State<ExpansionText> {
  bool _isTextExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            _isTextExpanded = !isExpanded;
          });
        },
        animationDuration: const Duration(milliseconds: 600),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
            headerBuilder: (_, isExpanded) => Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30,
              ),
              child: Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: (widget.content is Widget)
                ? widget.content
                : Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(widget.content),
                  ),
            isExpanded: _isTextExpanded,
          )
        ],
      ),
    );
  }
}
