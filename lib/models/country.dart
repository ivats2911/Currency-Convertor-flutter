class Country {
  String name;
  String urlFlag;
  String currency;
  Country({
    required this.name,
    required this.urlFlag,
    required this.currency,
  });
}

// data demo
final List<Country> datas = {
  Country(
    name: 'USA',
    urlFlag:
        'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/1200px-Flag_of_the_United_States.svg.png',
    currency: 'USD',
  ),
  Country(
      name: 'EU',
      urlFlag:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/255px-Flag_of_Europe.svg.png',
      currency: 'EUR'),
  Country(
      name: 'ENG',
      urlFlag:
          'https://upload.wikimedia.org/wikipedia/en/thumb/a/ae/Flag_of_the_United_Kingdom.svg/1200px-Flag_of_the_United_Kingdom.svg.png',
      currency: 'GBP'),
} as List<Country>;
