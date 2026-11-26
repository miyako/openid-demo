# openid-demo

Agent instructions for this repository. The canonical skills live in the
`.agents` submodule (dist branch of `miyako/skills`): read
[.agents/AGENTS.md](.agents/AGENTS.md) first, then the skill that matches
the task (`4dproject`, `4dform`, `4dstartup`, `4dlocalise`, `4dcss`,
`4dcli`, `4dlsp`, `demo-shareable-repo`).

## What this repository is

A demo host project for the [miyako/openid](https://github.com/miyako/openid)
4D component (namespace `OpenID`, classes `Client` / `Task`). It demonstrates
the component; it does not contain OIDC logic and must never grow any.

## Boundaries inherited from the component

- No secrets, no Keychain access, no token or authorization-URL logging or
  persistence. The provider setup (Auth0 tenant, client ID, callback
  registration) belongs to the person running the demo.
- UI stays nonblocking: `authenticate()` / `version()` return a `Task`
  immediately; forms poll with `On Timer`. Never kill the component worker;
  cancellation goes through `Task.cancel()`.
- Read `Task.result()` **before** `Task.dispose()`; dispose discards a
  completed result.
- `(issuer, subject)` is the identity key. This is not a 4D Server login.

## Layout

- `Project/Sources/dependencies.json` pins `miyako/openid` `0.1.3`. 4D's
  Dependency manager resolves it on first open of
  `Project/openid-demo.4DProject`.
- `Components/` is a fetched artifact and gitignored. `tool4d` does not act
  on `dependencies.json`: for headless runs, stage
  `Components/openid.4dbase` manually from the pinned release zip (verify
  the SHA256 against `openid-signing.json`, preserve executable modes) --
  see [docs/notes.md](docs/notes.md).
- `Project/Sources/Forms/` holds five forms (hub `Main` plus four labs),
  each with `method.4dm` and `ObjectMethods/`.
- `Project/Resources/en.lproj/` and `ja.lproj/` carry paired XLIFF
  (`menu`, `messages`, one file per form). IDs are PascalCase with `_`;
  multi-line strings use `&#13;` (4D line break is CR).
- `Project/Sources/styleSheets.css` holds visual-only rules; structural
  properties stay in the `.4DForm` JSON.

## Validation

```sh
# form schema
tools/4dform/boon .agents/schemas/4dform/formsSchema.json Project/Sources/Forms/*/form.4DForm

# method diagnostics (component classes report "unknown" here: LSP sessions
# do not load components -- see docs/notes.md)
tools/4dlsp/tool4d-lsp-stdio validate --workspace Project/ Sources/Methods/Start.4dm

# runtime acceptance: loads the staged component and calls version()
"/Applications/4D 21 R5 (100189)/tool4d.app/Contents/MacOS/tool4d" \
  Project/openid-demo.4DProject --startup-method Demo_HeadlessSelfTest --dataless
# report: openid-demo-selftest.json (repo root, gitignored)
```

Layout overlap check:
`python3 .agents/../tools` -- use
`skills/4d-skills/skills/4dform/scripts/form_layout_calc.py --form <form.4DForm>`.

## Do not

- Do not commit `Components/`, data files or self-test reports.
- Do not bump the component pin or touch the bundled CLI bytes.
- Do not add blocking UI, secrets, or OIDC logic to this host.
