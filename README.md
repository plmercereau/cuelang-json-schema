# Nhost Application Configuration schema

Defines a basic Cue schema from our [ongoing discussion](https://www.notion.so/nhost/nhost-nhost-yaml-7b87edb3e89f473490fbe767cb89c154), and generates the corresponding JSON schema.

Generates a [JSON schema](./generated/schema.json) from a [Cue schema](./schema.cue) and validates [reference.yaml](./reference.yaml).

## Prerequisites

- [cue](https://cuelang.org/docs/install/)
- [zx](https://github.com/google/zx)
- [yj](https://github.com/sclevine/yj)

## Convert reference from Yaml to Toml

```sh
yj -iyt < reference.yaml > reference.toml
```

## Default values

See the [generated defaults](./generated/defaults.yaml)

To generate them:

```sh
# Generate default values in Yaml
echo '# yaml-language-server: $schema=./schema.json' > generated/defaults.yaml
cue eval schema.cue -e '#Root' --out yaml >> generated/defaults.yaml

# Generate default values in Toml
cue eval schema.cue -e '#Root' --out json | yj -jti >> generated/defaults.toml

```

## Generate the JSON Schema

See the [generated JSON Schema](./generated/schema.json)

To generate it:

```sh
zx --install convert.mjs
```

## Notes

- JSON Schema limitations
  - additional properties seem to be enabled (could be solved)
  - "flex" struct definition is not supported (see `#Global.environment`). The problem is in the cue to OpenAPI export
- Do we want optional fields or required fields with defaults?

## Resources

- [Generating jsonschema from cue](https://github.com/cue-lang/cue/discussions/663)
