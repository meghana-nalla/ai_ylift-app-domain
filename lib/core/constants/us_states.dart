// import 'package:collection/collection.dart';
//
// enum USState {
//   alabama('Alabama', 'AL'),
//   alaska('Alaska', 'AK'),
//   arizona('Arizona', 'AZ'),
//   arkansas('Arkansas', 'AR'),
//   california('California', 'CA'),
//   colorado('Colorado', 'CO'),
//   connecticut('Connecticut', 'CT'),
//   delaware('Delaware', 'DE'),
//   districtOfColumbia('District of Columbia', 'DC'),
//   florida('Florida', 'FL'),
//   georgia('Georgia', 'GA'),
//   hawaii('Hawaii', 'HI'),
//   idaho('Idaho', 'ID'),
//   illinois('Illinois', 'IL'),
//   indiana('Indiana', 'IN'),
//   iowa('Iowa', 'IA'),
//   kansas('Kansas', 'KS'),
//   kentucky('Kentucky', 'KY'),
//   louisiana('Louisiana', 'LA'),
//   maine('Maine', 'ME'),
//   maryland('Maryland', 'MD'),
//   massachusetts('Massachusetts', 'MA'),
//   michigan('Michigan', 'MI'),
//   minnesota('Minnesota', 'MN'),
//   mississippi('Mississippi', 'MS'),
//   missouri('Missouri', 'MO'),
//   montana('Montana', 'MT'),
//   nebraska('Nebraska', 'NE'),
//   nevada('Nevada', 'NV'),
//   newHampshire('New Hampshire', 'NH'),
//   newJersey('New Jersey', 'NJ'),
//   newMexico('New Mexico', 'NM'),
//   newYork('New York', 'NY'),
//   northCarolina('North Carolina', 'NC'),
//   northDakota('North Dakota', 'ND'),
//   ohio('Ohio', 'OH'),
//   oklahoma('Oklahoma', 'OK'),
//   oregon('Oregon', 'OR'),
//   pennsylvania('Pennsylvania', 'PA'),
//   rhodeIsland('Rhode Island', 'RI'),
//   southCarolina('South Carolina', 'SC'),
//   southDakota('South Dakota', 'SD'),
//   tennessee('Tennessee', 'TN'),
//   texas('Texas', 'TX'),
//   utah('Utah', 'UT'),
//   vermont('Vermont', 'VT'),
//   virginia('Virginia', 'VA'),
//   washington('Washington', 'WA'),
//   westVirginia('West Virginia', 'WV'),
//   wisconsin('Wisconsin', 'WI'),
//   wyoming('Wyoming', 'WY');
//
//   final String label;
//   final String code;
//
//   const USState(this.label, this.code);
//
//   static USState byCode(String stateCode) {
//     return USState.values.firstWhere((usState) => usState.code == stateCode);
//   }
//
//   static USState? fromJson(String value){
//     return USState.values.firstWhereOrNull((state){
//       value = value.toLowerCase();
//       if(state.name.toLowerCase() == value) return true;
//       if(state.label.toLowerCase() == value) return true;
//       if(state.code.toLowerCase() == value) return true;
//       return false;
//     });
//   }
// }
