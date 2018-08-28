# ConDesignPatterns
Static concurrency design pattern detection and annotation in Java using TXL.

## Requirements

* Python 3.6.5
* TXL

## Usage

Scan all examples under the `examples/` directory against all rules under the `txl/rules/` directory:

```
$ python runall.py
```

Test a specific example against a specific TXL rule:

```
$ txl examples/PROGAM_TO_RUN.java -o out/PROGAM_TO_RUN.java txl/rules/RULE_TO_TEST.txl
```