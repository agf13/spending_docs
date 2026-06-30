class TextNormalizer {
  static String removeRomanianDiacritics(String text) {
    if (text.isEmpty) return text;

    const mapping = {
      'ă': 'a',
      'â': 'a',
      'î': 'i',
      'ș': 's',
      'ş': 's',
      'ț': 't',
      'ţ': 't',
      'Ă': 'A',
      'Â': 'A',
      'Î': 'I',
      'Ș': 'S',
      'Ş': 'S',
      'Ț': 'T',
      'Ţ': 'T',
    };

    String normalizedText = text;
    mapping.forEach((diacritic, englishEquivalent) {
      normalizedText = normalizedText.replaceAll(diacritic, englishEquivalent);
    });

    return normalizedText;
  }
}
