# ConDesignPatterns
Static concurrency design pattern detection and annotation in Java using TXL.

## Requirements

* Python 3.6.5
* TXL

## Usage

### 1.

Scan all examples under the `examples/` directory against all rules under the `txl/rules/` directory:

```
$ python runall.py
```

> The `-o` flag can be used to run the TXL rules against the original program examples, taken from "Patterns in Java - Volume 1".

### 2.

Test a specific example against a specific TXL rule:

```
$ txl ./examples/PROGAM_TO_RUN.java -o ./examples/out/PROGAM_TO_RUN.java txl/rules/RULE_TO_TEST.txl
```