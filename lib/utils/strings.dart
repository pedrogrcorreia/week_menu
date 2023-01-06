class Strings {
  static String getWeekDay(String day) {
    switch (day) {
      case 'MONDAY':
        return 'Segunda-feira';
      case 'TUESDAY':
        return 'Terça-feira';
      case 'WEDNESDAY':
        return 'Quarta-feira';
      case 'THURSDAY':
        return 'Quinta-feira';
      case 'FRIDAY':
        return 'Sexta-feira';
    }
    return '';
  }
}
