import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/shared_widgets/custom_dropdown_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/request_service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';

class RequestServiceView extends StatefulWidget {
  const RequestServiceView({required this.projectQuestions, super.key});
  final List<String> projectQuestions;
  @override
  State<RequestServiceView> createState() => _RequestServiceViewState();
}

class _RequestServiceViewState extends State<RequestServiceView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedService;

  late List<TextEditingController> _answersControllers;

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(const FetchServicesEvent());

    _answersControllers = List.generate(
      widget.projectQuestions.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    for (final controller in _answersControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.serviceRequestDetails),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: BlocConsumer<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is SendRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.requestSentSuccess), //state.message
                backgroundColor: AppColors.successColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is SendRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.messageSendFailed), //state.message
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.basicInformation, style: AppTextStyle.style16W700),
                  10.verticalSpace,
                  _buildTextField(
                    controller: _nameController,
                    label: s.name,
                    icon: Icons.person,
                  ),
                  10.verticalSpace,
                  _buildTextField(
                    controller: _phoneController,
                    label: s.phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  10.verticalSpace,
                  _buildTextField(
                    controller: _emailController,
                    label: s.email,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  10.verticalSpace,
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      if (state is ServiceLoaded) {
                        final services = state.services;

                        return CustomDropdownButtonFormField<String>(
                          value: _selectedService,
                          hintText: s.selectService,
                          prefix: const Icon(
                            Icons.work,
                            color: AppColors.primaryColor,
                          ),
                          items: services.map((service) {
                            return DropdownMenuItem<String>(
                              value: service.name,
                              child: Text(service.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedService = value);
                          },
                          validator: (value) =>
                              value == null ? s.serviceMustBeSelected : null,
                        );
                      }

                      return const LoadingWidget();
                    },
                  ),

                  Divider(height: 40.h, thickness: 1.5.r),

                  Text(s.projectDetails, style: AppTextStyle.style16W700),
                  10.verticalSpace,

                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.projectQuestions.length,
                    separatorBuilder: (context, index) => 16.verticalSpace,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${widget.projectQuestions[index]}',
                            style: AppTextStyle.style14W400.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.verticalSpace,
                          CustomPrimaryTextfield(
                            controller: _answersControllers[index],
                            maxLines: 3,
                            text: s.writeYourAnswerHere,

                            validator: (value) {
                              if (index == 0 &&
                                  (value == null || value.isEmpty)) {
                                return s.thisFieldIsRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  30.verticalSpace,

                  if (state is SendRequestLoading)
                    SizedBox(height: 30.r, child: const LoadingWidget())
                  else
                    CustomPrimaryButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final fullMessage = StringBuffer()
                            ..writeln('\n ${s.order}\n');

                          for (
                            var i = 0;
                            i < widget.projectQuestions.length;
                            i++
                          ) {
                            if (_answersControllers[i].text.isNotEmpty) {
                              fullMessage
                                ..writeln(
                                  '${s.questionShort}: ${widget.projectQuestions[i]}',
                                )
                                ..writeln(
                                  '${s.answerShort}: ${_answersControllers[i].text}',
                                )
                                ..writeln('\n');
                            }
                          }

                          final request = RequestServiceModel(
                            name: _nameController.text,
                            phoneNumber: _phoneController.text,
                            email: _emailController.text,
                            serviceName: _selectedService ?? '',

                            messageText: fullMessage.toString(),
                          );

                          context.read<ServiceBloc>().add(
                            SendRequestServiceEvent(requestModel: request),
                          );
                        }
                      },
                      text: s.sendRequest,
                    ),
                  30.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return CustomPrimaryTextfield(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: (value) => value!.isEmpty ? S.of(context)!.required : null,

      text: label,
      prefix: Icon(icon, color: AppColors.primaryColor),
    );
  }
}
