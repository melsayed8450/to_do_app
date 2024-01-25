import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/common/utils/app_constants.dart';
import 'package:to_do_app/model/task.dart';

class HomeController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFirstTime = false.obs;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime.value = prefs.getBool(AppConstants.isFirstTime) ?? true;
    isLoading.value = true;
    final box = await Hive.openBox<Task>(AppConstants.tasksHive);
    tasks.value = box.values.toList();
    isLoading.value = false;
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    final box = await Hive.openBox<Task>(AppConstants.tasksHive);
    await box.add(task);
    if (tasks.length > 1 && isFirstTime.isTrue) {
      isFirstTime.value = false;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(AppConstants.isFirstTime, false);
    }
  }

  Future<void> editTask(Task task, Task originalTask) async {
    final index = tasks.indexWhere((element) => originalTask == element);
    tasks[index] = task;
    final box = await Hive.openBox<Task>(AppConstants.tasksHive);
    await box.putAt(index, task);
    if (isFirstTime.isTrue) {
      isFirstTime.value = false;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(AppConstants.isFirstTime, false);
    }
  }

  Future<void> deleteTask(Task task) async {
    final index = tasks.indexWhere((element) => task == element);
    tasks.removeAt(index);
    final box = await Hive.openBox<Task>(AppConstants.tasksHive);
    await box.deleteAt(index);
    if (isFirstTime.isTrue) {
      isFirstTime.value = false;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(AppConstants.isFirstTime, false);
    }
  }

  // final List<Task> tasks = [
  //   Task(
  //     key: GlobalKey(),
  //     title: 'test',
  //     description: 'test',
  //     dateTime: DateTime(2024, 2, 7, 17, 30),
  //   ),
  //   Task(
  //     key: GlobalKey(),
  //     title: 'test',
  //     description: 'test',
  //     dateTime: DateTime(2024, 2, 7, 17, 30),
  //   ),
  // ];
}
