const rawOpenapi = await quiet($`cue export --out openapi schema.cue`)

import toJsonSchema from '@openapi-contrib/openapi-schema-to-json-schema'

const openapi = JSON.parse(rawOpenapi)
var conv = {
  components: {
    schemas: {}
  }
}
for (const s in openapi.components.schemas) {
  conv.components.schemas[s] = toJsonSchema(openapi.components.schemas[s])
}
const root = conv.components.schemas.Root
delete conv.components.schemas.Root

await fs.writeJson(
  './generated/schema.json',
  { ...conv, ...root },
  { spaces: 2 }
)
