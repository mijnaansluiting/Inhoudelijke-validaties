# Architecture

How the Schematron rule set is structured, compiled, and packaged.

* [Schematron rule layering](./schematron-layering) - The three-layer design that separates rule metadata from rule logic — base schema, concrete pattern, abstract pattern.
* [Shared XSL function libraries](./xsl-function-libraries) - The five custom ma:-namespace XSLT function libraries every rule's logic is built from.
* [Compilation and execution pipeline](./compilation-pipeline) - How a Schematron rule becomes runnable XSLT and produces an SVRL validation report.
* [Build and release](./build-and-release) - How the scope-checked schema, config, and docs are packaged into the versioned deliverable consumers actually use.
