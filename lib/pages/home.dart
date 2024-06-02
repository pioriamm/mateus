import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mateus/helps/helper.dart';
import 'package:mateus/models/solicitacoes.dart';
import 'package:mateus/widgets/steper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nsu = TextEditingController();
  final bool _processando = true;
  bool _isOpen = false;
  bool _bemVindo = true;
  bool _registrarTicket = false;
  List<Solicitacoes> tickets = [];
  String? _refEmpresa;
  String? _refCeg;
  String? _adquirente;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool teste = false;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
          child:
              _bemVindo ? wellcome(size, context, teste) : solicitacaoTicket()),
      body: Stack(
        children: [
          corpoSite(context, size),
          menuOpcoes(size),
        ],
      ),
      //chamando a notificacao
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF103239),
            borderRadius: BorderRadius.circular(50),
          ),
          height: 50,
          width: 200,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.report_problem_rounded, color: Colors.white),
              Text(
                'Atendimento ao Cliente',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  solicitacaoTicket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _bemVindo = true;
                  });
                },
                icon: const Icon(Icons.arrow_back)),
            const Text(
              'Solicitações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 60,
        ),
        Expanded(
          child: tickets.isEmpty
              ? const Center(
                  child: SizedBox(
                    width: 250,
                    height: 180,
                    child: Center(child: Text('Nada por aqui!')),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (build, index) {
                    return SizedBox(
                      width: 250,
                      height: tickets[index].expandido == true ? 405 : 80,
                      child: solicitacaoCard(index),
                    );
                  }),
        ),
      ],
    );
  }

  registrarTicket(Size size, BuildContext context, bool teste) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          width: 200,
          child: Image.asset('assets/img/conciliadora.png'),
        ),
        SizedBox(
          height: _registrarTicket ? 5 : 50,
        ),
        _registrarTicket
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Preencha os dados para abertura da solicitação.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Bom dia! \n ${_refEmpresa == null ? 'O que podemos te ajudar hoje?' : '$_refEmpresa \nO que podemos te ajudar hoje?'}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
        //         SizedBox(height: _registrarTicket ? 100 : size.height - 550),
        _registrarTicket
            ? criandoSolicitacao()
            : botaoDrawerTicket(context, titulo: 'Ausência de Vendas',
                Function: () {
                setState(() {
                  _registrarTicket = true;
                });
              }),
        botaoDrawerTicket(context, titulo: 'Consultar Tickets', Function: () {
          setState(() {
            _bemVindo = false;
            _registrarTicket = false;
          });
        }),
      ],
    );
  }

  wellcome(Size size, BuildContext context, bool teste) {
    return _registrarTicket
        ? criandoSolicitacao()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: Image.asset('assets/img/conciliadora.png'),
              ),
              SizedBox(
                height: _registrarTicket ? 5 : 50,
              ),
              _registrarTicket
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Preencha os dados para abertura da solicitação.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Bom dia! \n ${_refEmpresa == null ? 'O que podemos te ajudar hoje?' : '$_refEmpresa \nO que podemos te ajudar hoje?'}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
              //         SizedBox(height: _registrarTicket ? 100 : size.height - 550),
              botaoDrawerTicket(context, titulo: 'Ausência de Vendas',
                  Function: () {
                setState(() => _registrarTicket = true);
              }),
              botaoDrawerTicket(context, titulo: 'Consultar Tickets',
                  Function: () {
                setState(() {
                  _bemVindo = false;
                });
              }),
            ],
          );
  }

  corpoSite(BuildContext context, Size size) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: SizedBox(
              width: size.width,
              child: Row(
                children: [
                  seletorEmpresa(size),
                  seletorRefCeg(size),
                  calendario(size),
                  botaoAplicar(context),
                  tickets.isNotEmpty
                      ? Badge(
                          backgroundColor: Colors.red,
                          largeSize: 15,
                          label: Text(
                              "${tickets.where((ticket) => ticket.status == 1).length}"),
                          isLabelVisible: true,
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(seconds: 20),
                            curve: Curves.ease,
                            child: IconButton(
                              onPressed: () async {
                                await ticketExpiration(context);
                              },
                              icon: const Icon(Icons.bookmark),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    _bemVindo = true;
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.bookmark_add,
                    color: Color(0xFFC8D300),
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFF103239),
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.question_mark_outlined,
                      color: Color(0xFF103239))),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Color(0xFF103239))),
              IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                  )),
            ],
          ),
          tituloPagina(),
          gridCards(size),
          const SizedBox(
            height: 50,
          ),
          cabecalhoExportarBotoes(size, context),
          _refEmpresa != null
              ? gridVendas(context)
              : const Expanded(
                  child: Center(
                    child: Text("Selecione uma empresa"),
                  ),
                ),
          linhaRodape(size)
        ],
      ),
    );
  }

  menuOpcoes(Size size) {
    return Positioned(
      top: 0,
      child: MouseRegion(
        onEnter: (on) {
          setState(() {
            _isOpen = true;
          });
        },
        onExit: (ex) {
          setState(() {
            _isOpen = false;
          });
        },
        child: AnimatedContainer(
          color: Colors.white,
          height: size.height,
          curve: Curves.easeInOut,
          width: _isOpen ? 200 : 45,
          duration: const Duration(milliseconds: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isOpen
                  ? SizedBox(
                      width: 200,
                      height: 45,
                      child: Image.asset('assets/img/conciliadora.png'),
                    )
                  : SizedBox(
                      width: 45,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/img/logo.png'),
                      ),
                    ),
              const SizedBox(height: 50),
              iconeLateral(
                  icone: Icons.pie_chart_rounded,
                  titulo: 'DashBoard',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.search_rounded,
                  titulo: 'Venda',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.credit_card_outlined,
                  titulo: 'Pagamento',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.attach_money_sharp,
                  titulo: 'Taxa',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.calculate,
                  titulo: 'Administrativo',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.food_bank_rounded,
                  titulo: 'Banco',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.edit, titulo: 'Cadastro', isopen: _isOpen),
              iconeLateral(
                  icone: Icons.insert_link_rounded,
                  titulo: 'Integração',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.cloud_upload,
                  titulo: 'Upload de Arquivo',
                  isopen: _isOpen),
              iconeLateral(
                  icone: Icons.chat_bubble,
                  titulo: 'Comercial',
                  isopen: _isOpen),
            ],
          ),
        ),
      ),
    );
  }

  iconeLateral(
      {required IconData icone, required String titulo, required bool isopen}) {
    return _isOpen
        ? SizedBox(
            width: 200,
            height: 45,
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      icone,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: Icon(
                icone,
                color: Colors.grey.shade400,
              ),
            ),
          );
  }

  gridCards(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            card(
              size: size,
              titulo: 'Vendas Brutas',
              quantidade: 1000,
              valor: 3000,
            ),
            card(
              size: size,
              titulo: 'Taxa',
              quantidade: 1000,
              valor: 1000,
            ),
            card(
              size: size,
              titulo: 'Vendas Liquidas',
              quantidade: 1000,
              valor: 2000,
            ),
          ],
        ),
        Row(
          children: [
            card(
              size: size,
              titulo: 'Débitos',
              quantidade: 1,
              valor: 35,
            ),
            card(
              size: size,
              titulo: 'Rejeitados',
              quantidade: 0,
              valor: 0,
            ),
            card(
                size: size,
                titulo: 'Total Liquidas',
                quantidade: 1001,
                valor: 1965),
          ],
        ),
      ],
    );
  }

  tituloPagina() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      height: 60,
      child: const Text(
        "Vendas Operadoras",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  cabecalhoExportarBotoes(Size size, BuildContext context) {
    return Container(
      width: size.width,
      height: 50,
      padding: const EdgeInsets.only(right: 10, left: 10),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Arraste o cabeçalho de uma coluna aqui para agrupar'),
          const Expanded(child: SizedBox()),
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: Icon(Icons.rule)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cleaning_services_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.print)),
          IconButton(onPressed: () {}, icon: Icon(Icons.storage)),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }

  gridVendas(BuildContext context) {
    return Expanded(
        child: Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: DataTable2(
          columnSpacing: 5,
          horizontalMargin: 5,
          minWidth: 900,
          columns: Helper.titulos
              .map(
                (titulo) => DataColumn2(
                  label: Text(
                    overflow: TextOverflow.fade,
                    titulo,
                    style: TextStyle(fontSize: 9),
                  ),
                  size: ColumnSize.S,
                ),
              )
              .toList(),
          rows: Helper.transacoes
              .map(
                (valor) => DataRow(
                  cells: Helper.titulos
                      .map(
                        (transacao) => DataCell(
                          Text(
                            overflow: TextOverflow.fade,
                            '${valor[transacao]}',
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList()),
    ));
  }

  linhaRodape(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      child: Column(
        children: [
          Container(
            height: 3,
            color: Color(0xFFC8D300),
          )
        ],
      ),
    );
  }

  seletorRefCeg(Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
          borderRadius: BorderRadius.circular(5)),
      height: 40,
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        underline: Container(),
        iconEnabledColor: Colors.white,
        borderRadius: BorderRadius.circular(5),
        hint: const Text(
          'Empresa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        value: _refCeg,
        items: <String>['Empresa', 'Grupo'].map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _refCeg = newValue;
          });
        },
      ),
    );
  }

  seletorEmpresa(Size size) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
          borderRadius: BorderRadius.circular(5)),
      height: 40,
      width: 300,
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        underline: Container(),
        iconEnabledColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        hint: const Text('Selecione uma empresa...'),
        value: _refEmpresa,
        items: <String>['3568 - Mcdonald\'s BIG'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _refEmpresa = newValue;
          });
        },
      ),
    );
  }

  botaoAplicar(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white),
              Text(
                '  Aplicar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  botaoDrawerTicket(BuildContext context,
      {required String titulo, required Function() Function}) {
    return GestureDetector(
      onTap: Function,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  calendario(Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          Text(
            '${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
            style: const TextStyle(fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  solicitacaoCard(int i) {
    var size = 25.0;
    return Card(
      surfaceTintColor:
          tickets[i].status == 1 ? Colors.yellow.shade50 : Colors.green.shade50,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (valor) {
                  setState(() {
                    tickets[i].expandido = valor;
                  });
                },
                title: SizedBox(
                  height: size,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nº: ${tickets[i].ticket}',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 80,
                        child: tickets[i].status == 1
                            ? Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: LoadingAnimationWidget.beat(
                                  color: Colors.amberAccent,
                                  size: 20,
                                ),
                              )
                            : Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: LoadingAnimationWidget.beat(
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                children: [
                  SizedBox(
                    height: size,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Empresa'),
                        Text(
                          _refEmpresa ?? '',
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Data Ini',
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Adquirente',
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            _adquirente!,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('NSU'),
                        SizedBox(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            tickets[i].nsu,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: size + 180,
                      child: const Steper(),
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

  criandoSolicitacao() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 60,
              child: Image.asset('assets/img/conciliadora.png'),
            ),
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Acesse os serviços de conciliação mais avançados e recursos exclusivos da Conciliadora.\n',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('NSU'),
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller: nsu,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Adquirente',
                  ),
                  DropdownButton(
                    iconSize: 0,
                    alignment: AlignmentDirectional.centerEnd,
                    underline: const Spacer(),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    hint: Text('Selecione'),
                    value: _adquirente,
                    items: [
                      'Cielo',
                      'Alelo',
                      'Ifood',
                      'Mercado Pago',
                      'Stone',
                    ].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                        onTap: () {},
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _adquirente = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Empresa'),
                  Text(_refEmpresa ?? ''),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Data Ini',
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Data Fin',
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: nsu.value.text.isEmpty
                      ? null
                      : () {
                          criarticketMonitoramento();
                          nsu.clear();
                          _bemVindo = false;
                          _registrarTicket = false;
                        },
                  child: const Text('Registrar'),
                ),
                FilledButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    setState(() {
                      // _bemVindo = true;
                      _registrarTicket = false;
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container card(
      {required size,
      required String titulo,
      required int valor,
      required int quantidade}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      height: 100,
      width: (size.width / 3) - 19,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo),
              Text("$quantidade Registros"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                NumberFormat("R\$ #,##0.00", "pt_BR").format(valor),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  void criarticketMonitoramento() {
    Random random = Random();
    setState(() {
      tickets.add(Solicitacoes(
        nsu.text,
        DateFormat('dd/MM/yyyy').format(DateTime.now()),
        DateFormat('dd/MM/yyyy').format(DateTime.now()),
        _refEmpresa!,
        '$_adquirente',
        1,
        random.nextInt(4) + 400,
        false,
      ));
    });
  }

  ticketExpiration(context) {
    var random = Random();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        tickets[random.nextInt(tickets.length)].status = 2;
      });
    });

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sua Solicitação foi atualizada'),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tickets[random.nextInt(tickets.length)].nsu),
                Text(tickets[random.nextInt(tickets.length)].datainicial),
                Text(tickets[random.nextInt(tickets.length)].datafinal),
                Text(tickets[random.nextInt(tickets.length)].empresa),
                const Text('Finalizado'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                // Adicione a ação do botão OK aqui
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
