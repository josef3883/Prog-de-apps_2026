class FormateadorMoneda {
  const FormateadorMoneda();

  String formatear(int importeCentimos) {
    final esNegativo = importeCentimos < 0;
    final digitos = importeCentimos.abs().toString().padLeft(3, '0');
    final posicionDecimal = digitos.length - 2;
    final unidades = digitos.substring(0, posicionDecimal);
    final centimos = digitos.substring(posicionDecimal);

    return '${esNegativo ? '-' : ''}$unidades.$centimos';
  }
}
