# Validation Rules

The full catalog of 37 Schematron content-validation rules (`R.1`–`R.41`;
`R.16`–`R.19` don't exist). Source of truth: `doc/NLCSValidatieRegels.xml`.
Severity of each rule varies by [scope](../domain/scope-severity-model).

## Bestand (file-level)

* [R.1](./R.1) - Checks that an NLCS++ file contains exactly one AprojectReferentie plus at least one actual NLCS object, so no "empty" project can be submitted.
* [R.2](./R.2) - Checks that the NLCS Status values used by objects in the file are consistent with the Tekeningtype declared on the AprojectReferentie.
* [R.35](./R.35) - Checks that a revision drawing file (Tekeningtype DEELREVISIE or EINDREVISIE) contains at least one Amaaiveldhoogte (ground level) object.
* [R.40](./R.40) - Checks that AprojectReferentie has a Volgnummer value when Tekeningtype is DEELREVISIE or EINDREVISIE.

## Geometrie

* [R.3](./R.3) - Checks that every point, line, and area geometry of every NLCS object in the file interacts with the project area of the AprojectReferentie.
* [R.4](./R.4) - Checks that line and area-outline geometries respect the minimum/maximum distance between survey points and do not contain sharp kinks between segments.
* [R.36](./R.36) - Checks that every content asset related to an Amantelbuis (duct) lies within a configurable maximum distance of that duct's line geometry.

## Verplichte waarde (mandatory attributes)

* [R.5](./R.5) - Checks that objects originating from asset registration (Status BESTAAND, REVISIE, or VERWIJDERD) carry a GisId and AssetId, while newly designed objects (Status NIEUW) do not.
* [R.6](./R.6) - Checks that every linear Elec NLCS object has a value for both Inmeetwijze and Nauwkeurigheid.
* [R.7](./R.7) - Checks that MSkabel, LSkabel, and LSmof objects have a value for Subnettype.
* [R.8](./R.8) - Checks that every cable has values for a core set of mandatory attributes, with three additional mandatory attributes for LSkabel.
* [R.9](./R.9) - Checks that the DatumAanleg (installation date) is populated and does not lie in the future for a broad set of electrical network assets.
* [R.10](./R.10) - Checks that every cable joint (mof) has its baseline required attributes populated, with extra attributes required depending on voltage level.
* [R.11](./R.11) - Checks that every low-voltage transfer point (LSoverdrachtspunt) has its required attributes populated.
* [R.12](./R.12) - Checks that every overhead-line transfer point (OVLoverdrachtspunt) has its required attributes populated.
* [R.13](./R.13) - Checks that every medium-voltage transfer point (MSoverdrachtspunt) has its Identificatie (EAN code) attribute populated.
* [R.14](./R.14) - Checks that every station or low-voltage cabinet has its Nummer and Functie attributes populated.
* [R.15](./R.15) - Checks that every conduit (Mantelbuis) has its Materiaal, Diameter, and Thema attributes populated.
* [R.34](./R.34) - Checks that an abandoned cable (Status REVISIE, Bedrijfstoestand VERLATEN) has a value for RedenNietVerwijdering explaining why it was not removed.
* [R.41](./R.41) - Checks that DatumTijdMutatie is populated (and not present) exactly when an NLCS object's Status or Bewerking indicates a mutation, and that it is not a future date.

## Topologie

* [R.20](./R.20) - Checks that Elec point objects are geometrically connected to the correct cable type and do not float unconnected.
* [R.21](./R.21) - Checks that every cable has a valid connected object at both its start and end point.

## Netlogica

* [R.22](./R.22) - Checks that cables connected to each other through a joint belong to the same network layer (discipline).
* [R.23](./R.23) - Checks that cables connected to each other via a joint share the same value for a set of key attributes.

## Inhoud waarde (value content)

* [R.24](./R.24) - Checks that a cable's FaseAanduiding value is consistent with its Uitvoering value.
* [R.25](./R.25) - Checks that cables joined at a mof have a Fase combination that is valid for the number of cables connected.
* [R.26](./R.26) - Checks that the number of cables connected to a joint matches what is expected for the joint's Functie.
* [R.27](./R.27) - Checks that a protection pipe (mantelbuis) nested inside one or more other protection pipes has a smaller diameter than each of them.
* [R.37](./R.37) - Checks that Inmeetwijze on linear electrical assets is either GPS or Tachymeter, except for a separately-validated LSkabel AANSLUITNET/Meetlint combination.
* [R.38](./R.38) - Checks that a LSkabel with Subnettype AANSLUITNET does not use Meetlint as its Inmeetwijze.
* [R.39](./R.39) - Checks that MS/LSkabel objects physically connected to a MS/LSmof share that mof's Verbindingnummer value.

## Consistentie

* [R.28](./R.28) - Checks that a protection pipe (mantelbuis) in use has a registered content and a reserve one does not.
* [R.29](./R.29) - Checks that a cable relocation (Bewerking VERPLAATSEN) is recorded as a pair of objects — the original BESTAAND object and a new REVISIE object sharing the same GisId — rather than as a single mutated object.
* [R.30](./R.30) - Checks that an AmantelbuisInhoud correctly references a surrounding Amantelbuis and a distinct content object of the declared ObjectTypeInhoud.

## Document

* [R.31](./R.31) - Checks that every Eaardpen (earth pin) has a linked AbestandBijlage attachment of SoortBestand "Aardingsrapport".
* [R.32](./R.32) - Checks that every zinker-type Akunstwerk has a linked AbestandBijlage attachment of SoortBestand "Zinkertekening".
* [R.33](./R.33) - Checks that every Aaanlegtechniek with SoortAanlegTechniek "GESTUURDE TECHNIEK" has a linked AbestandBijlage attachment of SoortBestand "Gestuurde boring".
