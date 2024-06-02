class Solicitacoes {
  final String nsu;
  final int ticket;
  final String datainicial;
  final String datafinal;
  final String empresa;
  final String adquirente;
  int status;
  bool expandido;
  Solicitacoes(this.nsu, this.datainicial, this.datafinal, this.empresa,
      this.adquirente, this.status, this.ticket, this.expandido);
}
