# yy-open-contract

Text-only contract repository for the yy-open platform.

Nothing here is an implementation. The only executable content is the code
generation pipeline and the whitelist gate that keeps this repository from
growing into a fourth language project.

## Layout

```
openapi.yaml               single source of truth for the HTTP API
codegen.yaml               oapi-codegen settings
gen/go/                    generated Go types, chi server interface and client
scripts/gen.sh             regenerate gen/go from openapi.yaml
scripts/check-whitelist.sh reject changes outside the allowed file set
```

## Consumers

| Repository | How it consumes this |
|---|---|
| `yy-open-backend` | `go.mod` requires this module; `gen/go` provides types, the chi server interface and a client |
| `yy-open-frontend` | fetches a read-only snapshot of `openapi.yaml`, then generates TypeScript locally |

Neither consumer writes to this repository. Changes land here first, get a tag,
and each consumer picks the new tag up in its own repository. There is no
cross-repository push.

## Change flow

1. Edit `openapi.yaml`.
2. `./scripts/dev gen` from the root checkout (regenerates `gen/go`).
3. Run `scripts/check-whitelist.sh`, then commit both the spec and the generated
   output together.
4. Tag `vX.Y.Z`. A breaking change needs a major bump.

## Whitelist

Allowed: `*.yaml`, `*.json`, `*.md`, `gen/**`, `go.mod`, `go.sum`, `scripts/**`,
`.gitignore`.

Rejected on purpose: `cmd/`, `internal/`, `pkg/`, `src/`, `package.json`,
`Dockerfile`, and any file with a `.go` suffix outside `gen/`. A contract
repository that starts carrying implementation stops being neutral, and the
whole reason it exists separately is to stay neutral.
