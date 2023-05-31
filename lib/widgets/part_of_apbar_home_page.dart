part of './../pages/home_page.dart';

//sadece özelleştirilmiş home page için kullanılabilir part of app bar

class PartOfHomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PartOfHomePageAppBar({super.key, required this.drawerController});
  final ZoomDrawerController drawerController;
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: appBarButton(
        () {
          drawerController.toggle?.call();
        },
        IconPath.menu_list.iconPath(),
        context,
      ),
      trailing: [
        appBarButton(
          () {
            Navigator.of(context).pushNamed("/searchPage");
          },
          IconPath.search.iconPath(),
          context,
        ),
      ],
      title: Image.asset(
        Util.isDarkMode(context) ? LogoPath.png_logo_1_dark.iconPath() : LogoPath.png_logo_1_day.iconPath(),
        width: 300.w,
        fit: BoxFit.contain,
      ),
      // search icon
    );
  }

  Widget appBarButton(void Function()? onPressed, String iconPath, BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        height: Style.defaullIconHeight,
        color: context.iconThemeContext().color,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
