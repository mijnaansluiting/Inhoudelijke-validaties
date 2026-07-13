---
type: Domain Concept
title: NLCS++ and content validation
description: What NLCS++ is and why structural XSD validation isn't enough to guarantee usable grid-asset data.
tags: domain, nlcs
timestamp: 2026-07-08T00:00:00Z
published: true
editor: markdown
date: 2026-07-08T00:00:00Z
dateCreated: 2026-07-08T00:00:00Z
---

# Overview

NLCS++ is the Dutch electricity grid-asset information exchange format used
between contractors/surveyors and netbeheerders (grid operators) to hand over
geometries and attributes of grid assets — LS/MS cables, joints (moffen),
protection pipes (mantelbuis), transfer points, stations, and related
documents — as an XML file (namespace `NS_NLCSnetbeheer`).

An XSD schema (`NLCS_Netbeheer.xsd`, an external dependency fetched at build
time — see [build-and-release](/architecture/build-and-release.md)) guarantees
the file is *structurally* valid: the right elements, in the right shape.
It says nothing about whether the *content* is sensible — whether a cable's
declared endpoints actually exist, whether required attributes are filled in,
whether geometry sits inside the project area, and so on. This repository
implements exactly that layer: **Inhoudelijke Validaties** (content
validations), expressed as Schematron rules — see
[schematron-layering](/architecture/schematron-layering.md).

# Why Schematron

Schematron was chosen specifically because it is a decentralized,
system-agnostic way to validate XML content: any party — a netbeheerder's
backend, a contractor's laptop, a CI pipeline — can run the exact same rule
set against an NLCS++ file and get identical results, without depending on a
shared service. That's the stated goal of the project: run the same content
validations "on every device" that the netbeheerder itself runs.

# The rule catalog

The 37 rules (`R.1`–`R.41`, with gaps at `R.16`–`R.19`) are catalogued with
their full Dutch definitions in `doc/NLCSValidatieRegels.xml` (rendered as
HTML and published to GitHub Pages). Each rule has its own OKF concept under
[/rules](/rules/index.md). Rules don't all apply with the same severity in
every situation — see [scope-severity-model](/domain/scope-severity-model.md)
for how severity depends on the kind of drawing being submitted.

# Citations

[1] [README.md](../../README.md)
[2] [NLCS Validatieregels catalog](../../doc/NLCSValidatieRegels.xml)
