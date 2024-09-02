---
title: Library Clients
geekdocNav: true
# geekdocAlign: center
geekdocAnchor: true
---

The ALZ Library is designed to be consumed programatically.
It has been co-developed for use with the [Azure Landing Zones Terraform provider](https://registry.terraform.io/providers/Azure/alz/latest).
The Terraform provider is in turn based on a [Go module](https://github.com/Azure/alzlib) called `alzlib`, which provides the API for the library.

We welcome the development of other clients that can consume the library.

## Alzlib

[`alzlib`](https://github.com/Azure/alzlib) has been designed to be used by *any client* that needs to consume the ALZ Library.
It is agnostic and not Terraform specific.
It uses the Go type system to represent the ALZ Library constructs and contains all the functionality needed to read the ALZ Library constructs and generate deployable resource definitions based on the supplied configuration.

[`alzlibtool`](https://github.com/Azure/alzlib/tree/main/cmd/alzlibtool) is a command line tool that uses `alzlib` to expose certain functionality of the library to the command line.
As this is written in Go, it can be used on any practically any platform.
