typedef bool TestFunction();

class Rule {
  TestFunction test;
  String message;

  Rule(this.test, this.message);
}

class Validator {
  final List<Rule> _rules;

  Validator(this._rules);

  String? test() {
    try {
      final error = _rules.firstWhere((rule) => validate(rule));
      return error.message;
    } catch (e) {
      return null;
    }
  }

  bool validate(Rule params) {
    return params.test.call();
  }
}
