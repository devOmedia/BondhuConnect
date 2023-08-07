import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/user_profile/other_profile_model.dart';

detailsBottomSheet(BuildContext context, Size size, OtherProfileModel profile) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user image
              Center(
                child: DottedBorder(
                  padding: const EdgeInsets.all(8),
                  color: KColors.secondaryColor,
                  borderType: BorderType.Circle,
                  child: Container(
                    height: size.height * 0.15,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      //borderRadius: BorderRadius.circular(12),
                      child:
                          //data.data!.photoUrl != null
                          //? Image.network(data.data!.photoUrl!)
                          // :
                          profile != null
                              ? profile.data!.medium != null
                                  ? const SizedBox()
                                  : SvgPicture.asset(
                                      "assets/logo/kotha_logo_1.svg")
                              : SvgPicture.asset(
                                  "assets/logo/kotha_logo_1.svg"),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  profile.data!.name ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.05,
                  ),
                ),
              ),
              Text(
                "About Me",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AppConstants.getSpace(size.height * 0.02),
              Text(profile.data!.about ?? ""),
              AppConstants.getSpace(size.height * 0.02),
              Text(
                "My Interests",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AppConstants.getSpace(size.height * 0.02),
              if (profile.data!.userInterests != null)
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: size.height * 0.01,
                    crossAxisSpacing: size.width * 0.02,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: profile.data!.userInterests!.length,
                  itemBuilder: (context, index) {
                    return interestCardWidget(
                      profile.data!.userInterests![index].interestOption!.name!,
                      Colors.red,
                    );
                  },
                ),

              AppConstants.getSpace(size.height * 0.02),
              Text(
                "My Photos",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AppConstants.getSpace(size.height * 0.02),
              // SizedBox(
              //   height: size.height * 0.3,
              //   width: size.width * 0.35,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(18.0),
              //     child: Image.asset("assets/images/client.png"),
              //   ),
              // ),
            ],
          ),
        ),
      );
    },
  );
}

Container interestCardWidget(String interest, Color color) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: color,
      border: Border.all(color: KColors.grey),
    ),
    child: Center(
      child: Text(
        interest,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
