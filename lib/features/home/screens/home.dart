import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_do_app/common/utils/app_colors.dart';
import 'package:to_do_app/common/utils/assets.dart';
import 'package:to_do_app/common/widgets/custom_bottom_sheet.dart';
import 'package:to_do_app/features/home/controller/home_controller.dart';
import 'package:to_do_app/model/task.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text(
          'Your tasks',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      floatingActionButton: IconButton(
        iconSize: 30.r,
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (context) {
              return CustomBottomSheet(
                homeController: homeController,
              );
            },
          );
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            AppColors.secondaryColor,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          child: Obx(() {
            return homeController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondaryColor,
                    ),
                  )
                : homeController.tasks.isEmpty
                    ? Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'There\'s no tasks',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30.sp,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 50.w,
                            bottom: 140.h,
                            child: Text(
                              'You can add tasks now',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 50.w,
                            bottom: 50.h,
                            child: Transform.rotate(
                              angle: math.pi / 4,
                              child: Image.asset(
                                AppAssets.arrowImage,
                                height: 80.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: homeController.tasks.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: Colors.grey,
                              );
                            },
                            itemBuilder: (context, index) {
                              Task task = homeController.tasks[index];
                              return GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          task.title,
                                        ),
                                        content: Text(
                                          task.description!.isNotEmpty
                                              ? task.description ??
                                                  'No description'
                                              : 'No description',
                                        ),
                                        actions: [
                                          task.dateTime == null
                                              ? const SizedBox()
                                              : Text.rich(
                                                  TextSpan(
                                                      text: 'Due Date: ',
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: task.dateTime
                                                              .toString()
                                                              .replaceAll(
                                                                  ':00.000',
                                                                  ''),
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Dismissible(
                                  key: GlobalKey(),
                                  onDismissed: (direction) {
                                    homeController.deleteTask(task);
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5.h,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5.h,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      // borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            task.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              builder: (context) {
                                                return CustomBottomSheet(
                                                  homeController:
                                                      homeController,
                                                  task: task,
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          homeController.tasks.length == 1 &&
                                  homeController.isFirstTime.isTrue
                              ? Positioned(
                                  top: 60.h,
                                  child: Transform.rotate(
                                    angle: math.pi * (1.3),
                                    child: Image.asset(
                                      AppAssets.arrowImage,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          homeController.tasks.length == 1 &&
                                  homeController.isFirstTime.isTrue
                              ? Positioned(
                                  top: 140.h,
                                  left: 20.w,
                                  child: Text(
                                    'Swipe to delete task',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      );
          }),
        ),
      ),
    );
  }
}
