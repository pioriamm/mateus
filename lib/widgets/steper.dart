import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Steper extends StatelessWidget {
  const Steper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            steps(
              passo: 'Criando um indicador \nde Monitoramento',
              statusAndamento: 0,
            ),
            separador(),
            steps(
              passo: 'Localizando Arquivos \nLocaliza Estabelecimento',
              statusAndamento: 0,
            ),
            separador(),
            steps(
              passo: 'Localizando Arquivos \nem Localiza Desconhecido',
              statusAndamento: 0,
            ),
            separador(),
            steps(
              passo: 'Procurando na Fila \nde Processamento',
              statusAndamento: 0,
            ),
            separador(),
            steps(
              passo: 'Transação no Sistema',
              statusAndamento: 1,
            ),
            separador(),
            steps(
              passo: 'Ticket Solicitado',
              statusAndamento: 2,
            ),
          ],
        ),
      ),
    );
  }

  separador() {
    return Container(
        height: 30,
        padding: const EdgeInsets.only(left: 25),
        child: Container(
          width: 3,
          color: Colors.grey,
        ));
  }

  steps({required String passo, required int statusAndamento}) {
    return GestureDetector(
      onTap: () async {
        var url = 'https://suporte.conciliadora.com.br/Ticket/Edit/309332';
        if (await canLaunchUrl(url as Uri)) {
          await launchUrl(url as Uri);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getStatusColor(statusAndamento),
              child: Icon(
                _getStatusIcon(statusAndamento),
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passo,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _statusDescription(statusAndamento),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusDescription(int status) {
    switch (status) {
      case 0:
        return 'Finalizado';
      case 1:
        return 'Em andamento';
      case 2:
        return 'Aberto Chamado ';
      default:
        return 'Finalizado';
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.check;
      case 1:
        return Icons.report_problem_outlined;
      case 2:
        return Icons.support_agent_rounded;
      default:
        return Icons.check;
    }
  }
}
