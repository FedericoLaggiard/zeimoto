import 'package:zeimoto/models/enums.dart';
import 'package:zeimoto/models/plant.dart';

class SuggestionService {
  List<String> suggestionsFor(Plant plant, DateTime when) {
    final month = when.month;
    final stage = plant.stage;
    final species = plant.species.toLowerCase();
    final s = <String>[];

    final isConifer = species.contains('juniper') || species.contains('pinus') || species.contains('pino');
    final isBroadleaf = !isConifer;

    if (month >= 3 && month <= 5) {
      s.add('Concimazione di ripresa');
      if (stage != WorkStage.mature) s.add('Prima impostazione/legatura rami');
      if (isBroadleaf) s.add('Rinvaso (primavera)');
    }
    if (month >= 6 && month <= 8) {
      s.add('Potature di mantenimento');
      s.add('Pulizia chioma e defogliazione parziale (specie idonee)');
    }
    if (month >= 9 && month <= 10) {
      s.add('Fertilizzazione autunnale');
      if (isConifer) s.add('Lavorazione legna secca (jin/shari)');
    }
    if (month == 2 || month == 11 || month == 12 || month == 1) {
      s.add('Pianifica lavori dell’anno');
      s.add('Controllo parassiti e trattamenti fitosanitari');
    }

    return s;
  }
}
