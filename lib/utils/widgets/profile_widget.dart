import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final bool isUser;
  final IconData? iconData;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    this.isUser = false,
    required this.onClicked,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(context),
          isUser
              ? Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(color),
                )
              : const Icon(
                  Icons.person,
                  size: 1,
                  color: Colors.transparent,
                ),
        ],
      ),
    );
  }

  Widget buildImage(context) {
    return CircleAvatar(
      backgroundColor: const Color(0xffdbdbdb),
      radius: MediaQuery.sizeOf(context).width * 0.2,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) {
            if (url.isEmpty) {
              return const Icon(
                Icons.person_rounded,
                size: 50,
                color: Colors.white,
              );
            }
            return Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: const CircularProgressIndicator(),
            );
          },
          errorWidget: (context, url, error) => const Icon(
            Icons.person_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
            onTap: onClicked,
            child: Icon(
              iconData ?? Icons.add_a_photo,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
