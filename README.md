# Nhost Application Configuration schema

Defines a basic Cue schema from our [ongoing discussion](https://www.notion.so/nhost/nhost-nhost-yaml-7b87edb3e89f473490fbe767cb89c154), and generates the corresponding JSON schema.

Generates a [JSON schema](./generated/schema.json) from a [Cue schema](./schema.cue) and validates [reference.yaml](./reference.yaml).

## Prerequisites

- [cue](https://cuelang.org/docs/install/)
- [zx](https://github.com/google/zx)

## Generate the JSON Schema

```sh
zx --install convert.mjs
```

## Resources

- [Generating jsonschema from cue](https://github.com/cue-lang/cue/discussions/663)
