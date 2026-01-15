import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spa_project/core/constants/app_assets.dart';
import 'package:spa_project/core/utils/status_enum.dart';
import 'package:spa_project/features/home/presentation/controller/home_controller.dart';
import 'package:spa_project/features/home/presentation/screens/add_photo_screen.dart';
import 'package:spa_project/features/home/presentation/screens/photo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().randomPhotos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              backgroundColor: Colors.black,
              leadingWidth: double.infinity,
              toolbarHeight: kToolbarHeight + 20.0,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 20.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(AppAssets.images.logo),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 80.0,
                  horizontal: 21.0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      AppAssets.images.searchBg,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 24.0,
                  ),
                  decoration: InputDecoration(
                    hintText: "Поиск",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 26.0),
                      child: SvgPicture.asset(
                        AppAssets.icons.search,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<HomeController>().search(value);
                  },
                ),
              ),
            ),
          ];
        },
        body: Consumer<HomeController>(
          builder: (context, controller, child) {
            if (controller.status == StatusEnum.loading) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (controller.status == StatusEnum.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      "Ошибка загрузки!",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => controller.randomPhotos(),
                      child: Text("Попробовать снова"),
                    ),
                  ],
                ),
              );
            }

            if (controller.status == StatusEnum.success) {
              final list = controller.photo;

              if (list == null || list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Нет фотографий",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Card(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PhotoDetailScreen(photo: item),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: item.id,
                            child: Image.network(
                              item.path,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.title != null)
                                  Text(
                                    item.title!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (item.author != null) ...[
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 4),
                                      Text(
                                        item.author!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (item.likes != null) ...[
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.favorite,
                                          size: 16, color: Colors.red),
                                      SizedBox(width: 4),
                                      Text(
                                        '${item.likes}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16.0,
                ),
                itemCount: list.length,
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPhotoScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Добавить фото',
      ),
    );
  }
}
