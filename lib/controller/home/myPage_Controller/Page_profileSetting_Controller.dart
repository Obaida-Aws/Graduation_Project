//PageProfileSettingsController
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

class PageProfileSettingsController extends GetxController {
  // for the profile image
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;
LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

  void updateProfileImage(
      String base64String, String imageName, String imageExt) {
    profileImageBytes.value = base64String;
    profileImageBytesName.value = imageName;
    profileImageExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }

// for cover image
  final RxString coverImageBytes = ''.obs;
  final RxString coverImageBytesName = ''.obs;
  final RxString coverImageExt = ''.obs;

  void updateCoverImage(
      String base64String, String imageName, String imageExt) {
    coverImageBytes.value = base64String;
    coverImageBytesName.value = imageName;
    coverImageExt.value = imageExt;
    update();
  }

  // for dropDown country
  final RxBool isTextFieldEnabled11 = false.obs;
  final RxString country = ''.obs;
  final List<String> countryList = [
    "Palestine",
    "United States",
    "Canada",
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and/or Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Cape Verde",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling) Islands",
    "Colombia",
    "Comoros",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Croatia (Hrvatska)",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor",
    "Ecudaor",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands (Malvinas)",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "France, Metropolitan",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard and Mc Donald Islands",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran (Islamic Republic of)",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Ivory Coast",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, Democratic People's Republic of",
    "Korea, Republic of",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libyan Arab Jamahiriya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova, Republic of",
    "Monaco",
    "Mongolia",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfork Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russian Federation",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia South Sandwich Islands",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "St. Helena",
    "St. Pierre and Miquelon",
    "Sudan",
    "Suriname",
    "Svalbarn and Jan Mayen Islands",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States minor outlying islands",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City State",
    "Venezuela",
    "Vietnam",
    "Virigan Islands (British)",
    "Virgin Islands (U.S.)",
    "Wallis and Futuna Islands",
    "Western Sahara",
    "Yemen",
    "Yugoslavia",
    "Zaire",
    "Zambia",
    "Zimbabwe"
  ];

  RxBool isTextFieldEnabled = false.obs;
  RxString textFieldText = ''.obs;
// second textfiled
  RxBool isTextFieldEnabled2 = false.obs;
  RxString textFieldText2 = ''.obs;
  // third textfiled
  RxBool isTextFieldEnabled3 = false.obs;
  RxString textFieldText3 = ''.obs;
  // four textfiled
  // five textfiled

  // six textfiled
  RxBool isTextFieldEnabled6 = false.obs;
  RxString textFieldText6 = ''.obs;
  // seven textfiled
  RxBool isTextFieldEnabled7 = false.obs;
  RxString textFieldText7 = ''.obs;
  postSaveChanges(
    pageId,
      profileImageBytes,
      profileImageBytesName,
      profileImageExt,
      coverImageBytes,
      coverImageBytesName,
      coverImageExt) async {
    var url = "$urlStarter/user/editPageInfo";

    Map<String, dynamic> jsonData = {
      "pageId": pageId,
      "name": (isTextFieldEnabled == true) ? textFieldText.trim() : null,
      "specialty": (isTextFieldEnabled2 == true) ? textFieldText2.trim() : null,
      "address": (isTextFieldEnabled3 == true) ? textFieldText3.trim() : null,
      "country": (isTextFieldEnabled11 == true) ? country.trim() : null,
      "contactInfo": (isTextFieldEnabled6 == true) ? textFieldText6.trim() : null,
      "description": (isTextFieldEnabled7 == true) ? textFieldText7.trim() : null,
      "profileImageBytes": profileImageBytes,
      "profileImageBytesName": profileImageBytesName,
      "profileImageExt": profileImageExt,
      "coverImageBytes": coverImageBytes,
      "coverImageBytesName": coverImageBytesName,
      "coverImageExt": coverImageExt,
    };
    String jsonString = jsonEncode(jsonData);
    int contentLength = utf8.encode(jsonString).length;
    var responce = await http.post(Uri.parse(url), body: jsonString, headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  SaveChanges(
    pageId,
      profileImageBytes,
      profileImageBytesName,
      profileImageExt,
      coverImageBytes,
      coverImageBytesName,
      coverImageExt
) async {
    var res = await postSaveChanges(
      pageId,
        profileImageBytes,
        profileImageBytesName,
        profileImageExt,
        coverImageBytes,
        coverImageBytesName,
        coverImageExt
);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      SaveChanges(
        pageId,
          profileImageBytes,
          profileImageBytesName,
          profileImageExt,
          coverImageBytes,
          coverImageBytesName,
          coverImageExt
 );
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if (res.statusCode == 409 || res.statusCode == 500) {
      return res.statusCode.toString() + ":" + resbody['message'];
    } else if (res.statusCode == 200) {
      Get.offNamed(AppRoute.homescreen);
      isTextFieldEnabled.value = false;
      isTextFieldEnabled2.value = false;
      isTextFieldEnabled3.value = false;
      isTextFieldEnabled6.value = false;
      isTextFieldEnabled7.value = false;
      isTextFieldEnabled11.value = false;
    }
  }
}
