import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_do_app/common/utils/app_colors.dart';
import 'package:to_do_app/features/home/controller/home_controller.dart';
import 'package:to_do_app/model/task.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
    required this.homeController,
    this.task,
  });
  final HomeController homeController;
  final Task? task;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  DateTime? selectedDateTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.task != null) {
      selectedDateTime = widget.task!.dateTime;
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      height: 350.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5.r),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.5.r),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (picked != null) {
                    TimeOfDay? pickedTime;
                    if (context.mounted) {
                      pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                    }

                    if (pickedTime != null) {
                      selectedDateTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      setState(() {});
                    }
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.5.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        selectedDateTime == null
                            ? 'Select task date and time'
                            : selectedDateTime
                                .toString()
                                .replaceAll(':00.000', ''),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    return;
                  }
                  final task = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    dateTime: selectedDateTime,
                  );
                  if (widget.task != null) {
                    await widget.homeController.editTask(task, widget.task!);
                  } else {
                    await widget.homeController.addTask(task);
                  }

                  Get.back();
                },
                style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(AppColors.secondaryColor),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 5.h,
                    ),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
