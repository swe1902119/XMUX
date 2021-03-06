import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';
import 'package:xmux/globals.dart';
import 'package:xmux/modules/xmux_api/xmux_api_v2.dart';
import 'package:xmux/redux/redux.dart';

class EPaymentPage extends StatefulWidget {
  EPaymentPage();

  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<EPaymentPage> {
  final passwordController = TextEditingController();
  var _isProcessing = false;

  Future<Null> _handleSave(BuildContext context) async {
    if (passwordController.text.isEmpty) return;

    setState(() => _isProcessing = true);

    var action = UpdateEPaymentRecordsAction(
        auth: XMUXApiAuth(
            campusID: store.state.user.campusId,
            ePaymentPassword: passwordController.text),
        context: context,
        onError: () => setState(() => _isProcessing = false));
    store.dispatch(action);
  }

  Widget _buildLoginPage(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.lock_outline,
            size: 60,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Text(i18n('Tools/EPayment/NeedLogin', ctx)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: i18n('Tools/EPayment/EPaymentPassword', ctx)),
                ),
              ),
              _isProcessing
                  ? SpinKitDoubleBounce(color: Theme.of(context).accentColor)
                  : IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () => _handleSave(ctx),
                    ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    if (store.state.user.ePaymentPassword != null)
      store.dispatch(UpdateEPaymentRecordsAction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n('Tools/EPayment', context)),
      ),
      body: StoreConnector<MainAppState, List<BillingRecord>>(
        converter: (Store<MainAppState> store) =>
            store.state.queryState.ePaymentRecords,
        builder: (ctx, records) => records == null
            ? _buildLoginPage(ctx)
            : ListView.builder(
                reverse: false,
                itemCount: records.length,
                itemBuilder: (_, int index) =>
                    _BillingRecordCard(records[records.length - 1 - index])),
      ),
    );
  }
}

class _BillingRecordCard extends StatelessWidget {
  final BillingRecord paymentData;

  _BillingRecordCard(this.paymentData);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 3, 3),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                paymentData.item,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('MYR:  ${paymentData.amount}'),
                    Text(
                      i18n('Tools/EPayment/Status', context) +
                          (paymentData.isPaid
                              ? i18n('Tools/EPayment/Paid', context)
                              : i18n('Tools/EPayment/Unpaid', context)),
                      style: TextStyle(
                        color: !paymentData.isPaid ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
