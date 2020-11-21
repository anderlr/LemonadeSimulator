import 'package:flutter/material.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MaterialApp(title: "Lemonade Stand", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _currentAction = "Começar";
  String _resetAction = "Reiniciar";
  String _infoText = "Aperte Começar para abrir a barraca!";
  bool _actionTrigger = false;
  int _price = 25;
  int _clients = 50; //aleatorizar
  double _score = 0;
  int _clientsSum = 0;
  int _profit = 0;
  int _day = 1;
  double w;
  double h;

  int gerarClientes() {
    int _max = 100 - _price * 2;
    //melhor caso de vendas em 12 dias para 25 centavos
    //melhor caso de vendas em 8 dias para 25 centavos
    //melhor caso de vendas em 12 dias para 40 centavos
    // Melhor caso: 100/preço(double) / maximo no dia(2* preço(int) = 8)
    //Melhor caso: [100/preço(0.25) / maximo no dia(2* preço(25) ]= 8)
    //consegui 13 aleatoriamente
    var _rng = new Random();
    return (_rng.nextInt(_max)); //numero aleatoria de 0 até MAX
    //return _max;
  }

  void _resetShop() {
    setState(() {
      _currentAction = "Começar";
      _resetAction = "Reiniciar";
      _infoText = "Aperte Começar para abrir a barraca!";
      _actionTrigger = false;
      _price = 25;
      _clients = 50; //aleatorizar
      //double _clientMod;
      _clientsSum = 0;
      _profit = 0;
      _day = 0;
      _score = 0;
    });
  }

  void _changeAction() {
    setState(() {
      if (_score >= 100) {
        _infoText = "Você atingiu a meta em $_day dias!!";
        _actionTrigger = false;
        _currentAction = "Fim de jogo";
      } else {
        if (_actionTrigger == false) {
          _day++;
          _infoText = "Ajuste o preço do copo de limonada";
          _currentAction = "Vender";
          _actionTrigger = true;
        } else {
          startShop();
          _actionTrigger = false;
          _infoText = "Você vendeu para: $_clients pessoas hoje!";
          _currentAction = "Proximo dia!";
        }
      }
    });
  }

  void startShop() {
    setState(() {
      _profit += _clients * _price;
      _clients = gerarClientes();
      _clientsSum += _clients;
      _score = _profit / 100;
      if (_score > 100) _score = 100;
    });
  }

  void _changePrice(value) {
    setState(() {
      if (_price + value <= 40 && _price + value >= 10) _price += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    //h 683.429
    //w 411.429

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "images/lemonade_stand.png",
            fit: BoxFit.fill,
            alignment: Alignment.center,
            height: h,
            width: w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                //color: Colors.black,
                padding:
                    EdgeInsets.fromLTRB(0.778 * w, 0.250 * h, 0, 0.0365 * h),
                child: Text("$_price ¢",
                    style: TextStyle(
                        fontSize: 30,
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0.176 * h, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: 0.607 * w,
                      height: 0.0366 * h,
                      child: LinearPercentIndicator(
                        center: Text("Meta(100): $_score%",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 20)),
                        width: 0.607 * w,
                        lineHeight: 0.0366 * h,
                        percent: _score / 100, // obtendo porcentagem
                        backgroundColor: Colors.grey,
                        progressColor: Colors.green,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          0.0243 * w, 0.0146 * h, 0.0243 * w, 0.0146 * h),
                      child: Text("Dia $_day",
                          style: TextStyle(
                              fontSize: 30,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      alignment: Alignment.center,
                    ),
                    Row(
                      key: UniqueKey(),
                      mainAxisAlignment: MainAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0.0243 * w, 0.0146 * h, 0.0243 * w, 0.0146 * h),
                        ),
                        FlatButton(
                          color: Colors.red,
                          child: Text(
                            "- 5 ¢",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                          onPressed: () {
                            _changePrice(-5);
                          },
                        ),
                        FlatButton(
                          color: Colors.green,
                          child: Text(
                            "+ 5 ¢",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                          onPressed: () {
                            _changePrice(5);
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          0.0243 * w, 0.0146 * h, 0.0243 * w, 0.0146 * h),
                      alignment: Alignment.bottomCenter,
                      child: Text("$_infoText",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              fontSize: 20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () {
                              _changeAction();
                            },
                            child: Text(
                              "$_currentAction",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            color: Colors.white),
                        FlatButton(
                            onPressed: () {
                              _resetShop();
                            },
                            child: Text(
                              "$_resetAction",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            color: Colors.blue),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0.0146 * h),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          "Caixa: ${_profit / 100} Reais\nLimonadas Servidas: $_clientsSum",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w800,
                              color: Colors.green[800],
                              fontStyle: FontStyle.normal,
                              fontSize: 25)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
