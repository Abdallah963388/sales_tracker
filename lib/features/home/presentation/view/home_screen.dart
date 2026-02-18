import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/home/presentation/widget/custom_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<ClientModel> clients = [
    ClientModel(
      id: 1,
      name: 'Ahmad Ali',
      placeName: 'Shop 1',
      area: 'Cairo',
      email: 'ahmad@example.com',
      phone: '01012345678',
      details: 'Electronics shop',
    ),
    ClientModel(
      id: 2,
      name: 'Sara Mohamed',
      placeName: 'Shop 2',
      area: 'Giza',
      email: 'sara@example.com',
      phone: '01087654321',
      details: 'Clothes store',
    ),
    ClientModel(
      id: 3,
      name: 'Ali Hassan',
      placeName: 'Shop 3',
      area: 'Alexandria',
      email: 'ali@example.com',
      phone: '01011223344',
      details: 'Bookstore',
    ),
    ClientModel(
      id: 4,
      name: 'Abdallah Jamal',
      placeName: 'Shop 4',
      area: 'Mynia',
      email: 'abdallah@example.com',
      phone: '01011223344',
      details: 'Mobile store',
    ),
    ClientModel(
      id: 5,
      name: 'Ahmed Mahmoud',
      placeName: 'Shop 5',
      area: 'Aswan',
      email: 'a@example.com',
      phone: '01011223344',
      details: 'Shoes store',
    ),
  ];

  final List<ClientModel> visits = [
    ClientModel(
      id: 1,
      name: 'Visit 1',
      placeName: 'Shop 1',
      area: 'Cairo',
      email: '',
      phone: '',
      details: '',
      visitDetails: 'Discussed new products',
    ),
    ClientModel(
      id: 2,
      name: 'Visit 2',
      placeName: 'Shop 2',
      area: 'Giza',
      email: '',
      phone: '',
      details: '',
      visitDetails: 'Check stock',
    ),
    ClientModel(
      id: 3,
      name: 'Visit 3',
      placeName: 'Shop 3',
      area: 'Alexandria',
      email: '',
      phone: '',
      details: '',
      visitDetails: 'Follow up on order',
    ),
    ClientModel(
      id: 4,
      name: 'Visit 4',
      placeName: 'Shop 4',
      area: 'Tanta',
      email: '',
      phone: '',
      details: '',
      visitDetails: 'Product demonstration',
    ),
    ClientModel(
      id: 5,
      name: 'Visit 5',
      placeName: 'Shop 5',
      area: 'Mansoura',
      email: '',
      phone: '',
      details: '',
      visitDetails: 'Discuss pricing',
    ),
  ];

  List<ClientModel> get topThreeClients => clients.take(3).toList();
  List<ClientModel> get topThreeVisits => visits.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الصفحة الرئيسية',
      ),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.blackColor.withAlpha(100),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عدد العملاء',
                            style: AppTextStyle.style14W500.copyWith(
                              color: AppColors.blackColor.withAlpha(150),
                            ),
                          ),
                          Text(clients.length.toString()),
                        ],
                      ),
                    ),
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.blackColor.withAlpha(100),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عدد الزيارات',
                            style: AppTextStyle.style14W500.copyWith(
                              color: AppColors.blackColor.withAlpha(150),
                            ),
                          ),
                          Text(visits.length.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            8.verticalSpace,
            Row(
              children: [
                CustomWidget(
                  onTap: () => context.pushNamed(AppRoutes.addClientsScreen),
                  text: 'إضافة عملاء',
                ),
                8.horizontalSpace,
                CustomWidget(
                  onTap: () => context.pushNamed(AppRoutes.addVisitsScreen),
                  text: 'إضافة زيارات',
                ),
              ],
            ),
            // 8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'العملاء',
                    style: AppTextStyle.style14W900.copyWith(
                      color: AppColors.blackColor.withAlpha(150),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'عرض الكل',
                      style: AppTextStyle.style14W500.copyWith(
                        color: AppColors.blackColor.withAlpha(150),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(
                        AppRoutes.clientsScreen,
                        extra: clients,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topThreeClients.length,
                itemBuilder: (context, index) {
                  final client = topThreeClients[index];
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.clientsDetailsScreen,
                        extra: client,
                      );
                    },
                    child: ListTile(
                      title: Text(client.name),
                      subtitle: Text(client.phone),
                    ),
                  );
                },
              ),
            ),

            // 8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الزيارات',
                    style: AppTextStyle.style14W900.copyWith(
                      color: AppColors.blackColor.withAlpha(150),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'عرض الكل',
                      style: AppTextStyle.style14W500.copyWith(
                        color: AppColors.blackColor.withAlpha(150),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(AppRoutes.visitsScreen, extra: visits);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topThreeVisits.length,
                itemBuilder: (context, index) {
                  final visit = topThreeVisits[index];
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.visitsDetailsScreen,
                        extra: visit,
                      );
                    },
                    child: ListTile(
                      title: Text(visit.name),
                      subtitle: Text(visit.visitDetails ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}









// BlocBuilder<ProductCubit, ProductStates>(
//         builder: (context, state) {
//           if (state is ProductLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ProductSuccess) {
//             return ListView.builder(
//               itemCount: state.products.length,
//               itemBuilder: (context, index) {
//                 final product = state.products[index];
//                 return ListTile(
//                   title: Text(product.name),
//                   subtitle: Text('Price: ${product.price}'),
//                 );
//               },
//             );
//           }

//           if (state is ProductFailed) {
//             return Center(child: Text(state.message));
//           }

//           return const SizedBox();
//         },
//       ),





 // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<ProductCubit>().addProduct(
      //       ProductModel(
      //         id: 0,
      //         name: 'New Product',
      //         price: 150,
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),