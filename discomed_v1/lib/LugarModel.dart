import 'package:flutter/material.dart';

class Local{
  var _id_local;
  var _local;

  Local(this._id_local, this._local);

  get local => _local;

  set local(value) {
    _local = value;
  }

  get id_local => _id_local;

  set id_local(value) {
    _id_local = value;
  }

  @override
  String toString() {
    return 'Local{_id_local: $_id_local, _local: $_local}';
  }
}