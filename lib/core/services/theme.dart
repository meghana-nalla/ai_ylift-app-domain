import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;



  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280754718),
      surfaceTint: Color(4284767576),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282991166),
      onPrimaryContainer: Color(4293122258),
      secondary: Color(4284636760),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4293978594),
      onSecondaryContainer: Color(4283452487),
      tertiary: Color(4285160528),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290291352),
      onTertiaryContainer: Color(4280753427),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294834423),
      onSurface: Color(4280032027),
      onSurfaceVariant: Color(4282664776),
      outline: Color(4285823096),
      outlineVariant: Color(4291086279),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inversePrimary: Color(4291806399),
      primaryFixed: Color(4293648602),
      onPrimaryFixed: Color(4280294167),
      primaryFixedDim: Color(4291806399),
      onPrimaryFixedVariant: Color(4283188545),
      secondaryFixed: Color(4293452250),
      onSecondaryFixed: Color(4280163095),
      secondaryFixedDim: Color(4291610047),
      onSecondaryFixedVariant: Color(4283057729),
      tertiaryFixed: Color(4294172623),
      onTertiaryFixed: Color(4280490512),
      tertiaryFixedDim: Color(4292264884),
      onTertiaryFixedVariant: Color(4283515961),
      surfaceDim: Color(0xffddd9d8),
      surfaceBright: Color(4294834423),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650406),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280754718),
      surfaceTint: Color(4284767576),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282991166),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282794557),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286084206),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283253045),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286673509),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294834423),
      onSurface: Color(4280032027),
      onSurfaceVariant: Color(4282401604),
      outline: Color(4284244064),
      outlineVariant: Color(4286086012),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inversePrimary: Color(4291806399),
      primaryFixed: Color(4286280558),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284635990),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286084206),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284439382),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286673509),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284963149),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729304),
      surfaceBright: Color(4294834423),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650406),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280754718),
      surfaceTint: Color(4284767576),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282991166),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280623646),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282794557),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281016342),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283253045),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294834423),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280362277),
      outline: Color(4282401604),
      outlineVariant: Color(4282401604),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inversePrimary: Color(4294306532),
      primaryFixed: Color(4282925629),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281412648),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282794557),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281281576),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283253045),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281740064),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729304),
      surfaceBright: Color(4294834423),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650406),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4291806399),
      surfaceTint: Color(4291806399),
      onPrimary: Color(4281675563),
      primaryContainer: Color(4281346598),
      onPrimaryContainer: Color(4290753968),
      secondary: Color(4294967295),
      onSecondary: Color(4281544747),
      secondaryContainer: Color(4292531148),
      onSecondaryContainer: Color(4282531642),
      tertiary: Color(4292264884),
      onTertiary: Color(4282002980),
      tertiaryContainer: Color(4288976006),
      onTertiaryContainer: Color(4278452480),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279505683),
      onSurface: Color(4293255905),
      onSurfaceVariant: Color(4291086279),
      outline: Color(4287533458),
      outlineVariant: Color(4282664776),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inversePrimary: Color(4284767576),
      primaryFixed: Color(4293648602),
      onPrimaryFixed: Color(4280294167),
      primaryFixedDim: Color(4291806399),
      onPrimaryFixedVariant: Color(4283188545),
      secondaryFixed: Color(4293452250),
      onSecondaryFixed: Color(4280163095),
      secondaryFixedDim: Color(4291610047),
      onSecondaryFixedVariant: Color(4283057729),
      tertiaryFixed: Color(4294172623),
      onTertiaryFixed: Color(4280490512),
      tertiaryFixedDim: Color(4292264884),
      onTertiaryFixedVariant: Color(4283515961),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4281018921),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292069827),
      surfaceTint: Color(4291806399),
      onPrimary: Color(4279899410),
      primaryContainer: Color(4288188298),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294967295),
      onSecondary: Color(4281544747),
      secondaryContainer: Color(4292531148),
      onSecondaryContainer: Color(4280426267),
      tertiary: Color(4292528056),
      onTertiary: Color(4280161291),
      tertiaryContainer: Color(4288976006),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279505683),
      onSurface: Color(4294900473),
      onSurfaceVariant: Color(4291349452),
      outline: Color(4288717732),
      outlineVariant: Color(4286612612),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inversePrimary: Color(4283254594),
      primaryFixed: Color(4293648602),
      onPrimaryFixed: Color(4279570445),
      primaryFixedDim: Color(4291806399),
      onPrimaryFixedVariant: Color(4282070321),
      secondaryFixed: Color(4293452250),
      onSecondaryFixed: Color(4279439629),
      secondaryFixedDim: Color(4291610047),
      onSecondaryFixedVariant: Color(4281939505),
      tertiaryFixed: Color(4294172623),
      onTertiaryFixed: Color(4279766791),
      tertiaryFixedDim: Color(4292264884),
      onTertiaryFixedVariant: Color(4282397737),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4281018921),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294966008),
      surfaceTint: Color(4291806399),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4292069827),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294967295),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4292531148),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966008),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4292528056),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279505683),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294573052),
      outline: Color(4291349452),
      outlineVariant: Color(4291349452),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inversePrimary: Color(4281280805),
      primaryFixed: Color(4293977567),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4292069827),
      onPrimaryFixedVariant: Color(4279899410),
      secondaryFixed: Color(4293781215),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291873475),
      onSecondaryFixedVariant: Color(4279768594),
      tertiaryFixed: Color(4294435796),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4292528056),
      onTertiaryFixedVariant: Color(4280161291),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4281018921),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(4294758323),
    value: Color(4294758323),
    light: ColorFamily(
      color: Color(4286076737),
      onColor: Color(4294967295),
      colorContainer: Color(4294956475),
      onColorContainer: Color(4284235306),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4286076737),
      onColor: Color(4294967295),
      colorContainer: Color(4294956475),
      onColorContainer: Color(4284235306),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4286076737),
      onColor: Color(4294967295),
      colorContainer: Color(4294956475),
      onColorContainer: Color(4284235306),
    ),
    dark: ColorFamily(
      color: Color(4294967295),
      onColor: Color(4282722839),
      colorContainer: Color(4294495152),
      onColorContainer: Color(4283840805),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4294967295),
      onColor: Color(4282722839),
      colorContainer: Color(4294495152),
      onColorContainer: Color(4283840805),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4294967295),
      onColor: Color(4282722839),
      colorContainer: Color(4294495152),
      onColorContainer: Color(4283840805),
    ),
  );

  /// Custom Color 2
  static const customColor2 = ExtendedColor(
    seed: Color(4288392610),
    value: Color(4288392610),
    light: ColorFamily(
      color: Color(4283523673),
      onColor: Color(4294967295),
      colorContainer: Color(4289116333),
      onColorContainer: Color(4279970595),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4283523673),
      onColor: Color(4294967295),
      colorContainer: Color(4289116333),
      onColorContainer: Color(4279970595),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4283523673),
      onColor: Color(4294967295),
      colorContainer: Color(4289116333),
      onColorContainer: Color(4279970595),
    ),
    dark: ColorFamily(
      color: Color(4290563779),
      onColor: Color(4280562732),
      colorContainer: Color(4287931803),
      onColorContainer: Color(4278786065),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4290563779),
      onColor: Color(4280562732),
      colorContainer: Color(4287931803),
      onColorContainer: Color(4278786065),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4290563779),
      onColor: Color(4280562732),
      colorContainer: Color(4287931803),
      onColorContainer: Color(4278786065),
    ),
  );

  /// Custom Color 3
  static const customColor3 = ExtendedColor(
    seed: Color(4293435810),
    value: Color(4293435810),
    light: ColorFamily(
      color: Color(4287057488),
      onColor: Color(4294967295),
      colorContainer: Color(4294159019),
      onColorContainer: Color(4283375907),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4287057488),
      onColor: Color(4294967295),
      colorContainer: Color(4294159019),
      onColorContainer: Color(4283375907),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4287057488),
      onColor: Color(4294967295),
      colorContainer: Color(4294159019),
      onColorContainer: Color(4283375907),
    ),
    dark: ColorFamily(
      color: Color(4294953674),
      onColor: Color(4283507236),
      colorContainer: Color(4292975516),
      onColorContainer: Color(4282323991),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4294953674),
      onColor: Color(4283507236),
      colorContainer: Color(4292975516),
      onColorContainer: Color(4282323991),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4294953674),
      onColor: Color(4283507236),
      colorContainer: Color(4292975516),
      onColorContainer: Color(4282323991),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    customColor1,
    customColor2,
    customColor3,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
