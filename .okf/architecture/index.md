# Architecture

How the Schematron rule set is structured, compiled, and packaged.

* [Schematron rule layering](./schematron-layering.md) - The three-layer design that separates rule metadata from rule logic — base schema, concrete pattern, abstract pattern.
* [XSL function libraries](./xsl-function-libraries.md) - The versioned custom ma:-namespace XSLT function libraries every rule's logic is built from.
* [Compilation and execution pipeline](./compilation-pipeline.md) - How a Schematron rule becomes runnable XSLT and produces an SVRL validation report.
* [Multiversion implementation plan](./multiversion-plan.md) - Ordered steps to make scripts, CI and the release support several NLCS++ versions, with what is done and what remains.
* [Rule catalog](./rule-catalog.md) - The per-version NLCSValidatieRegels.xml, its shared XSD (including the `laatstGewijzigd` version field) and the XSL that renders the HTML docs.
* [Build and release](./build-and-release.md) - How the scope-checked schema, config, and docs are packaged into the versioned deliverable consumers actually use.
