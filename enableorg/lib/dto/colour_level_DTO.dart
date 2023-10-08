import 'dart:ui';

class GroupsByColourAndLevelDTO {
  final List<ColourLevelListDTO> coloursGroups;
  GroupsByColourAndLevelDTO({required this.coloursGroups});
}

class ColourLevelListDTO {
  final List<ColourLevelDTO> colourLevelList;
  ColourLevelListDTO({required this.colourLevelList});
}

class ColourLevelDTO {
  final int level;
  final Color color;

  ColourLevelDTO({required this.level, required this.color});
}
