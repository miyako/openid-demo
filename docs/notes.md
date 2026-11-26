# notes -- chokepoints, failures and findings

Working log for the `openid-demo` build (4D 21.1 LTS host, `miyako/openid`
`0.1.3`, macOS arm64). Kept because every item cost time or would recur in
the next component-consuming demo.

## Toolchain

1. **tool4d does not act on `dependencies.json`.** Every headless run logs
   `PackageManager Dependency 'openid' cannot be found`. These lines are
   diagnostics, not failures: stage `Components/openid.4dbase` manually
   from the pinned release zip and prove the load by calling the component
   (the self-test calls `version()`). The demo's `AGENTS.md` documents the
   staging recipe.
2. **LSP sessions never see the component.** Even with `Components/`
   staged and `tool4d-lsp-stdio install-components` reporting "components
   installed", each `validate` invocation starts a fresh tool4d, so
   `cs.OpenID` stays "unknown" (21 R4 globalStorage build and 21 R5 build
   behave identically). Treat those specific diagnostics as expected noise;
   runtime evidence comes from `Demo_HeadlessSelfTest`.
3. **`Get 4D folder(Database folder)` in dataless mode is the repo root**,
   not the `Project/` folder. The self-test report therefore lands at
   `openid-demo-selftest.json` next to `.gitignore` -- which now ignores it.
4. **`gh release download` needs the exact tag**: `0.1.3`, not `v0.1.3`
   (the component's SemVer tags are prefix-free).
5. **macOS TCC**: listing `~/Documents` from a shell is denied, while
   direct paths into `~/Documents/GitHub/...` work. Do not retry the
   parent listing.
6. **`fourdform` previews resolve `:xliff:` references fine** -- provided
   the `.lproj` folders are in the database-root `Resources/` (see
   finding 23; the earlier "renderer cannot resolve XLIFF" conclusion was
   the same location mistake). Pass `--language en|ja` to pick the
   variant; empty inputs and object-based dropdowns still display their
   data-source names (`Form.status`, `Form.lang`) -- a documented renderer
   limitation, not a localization failure.

## 4D language traps (caught by `4dlsp` + `4dlang` before any runtime)

7. **`OPEN WEB URL` does not exist** in the classic command set -- the
   command is `OPEN URL(path)` (Tools theme; opens the default browser for
   `http:` URLs). `4d-language-classic` had it one fuzzy query away.
8. **`BRING WINDOW TO FRONT` does not exist** either -- `BRING TO FRONT`
   takes a *process* number, not a window reference.
9. **`Else If` is not 4D syntax.** Nest a plain `If` inside `Else` instead.
10. **Static text objects have no data source.** A value computed at
    runtime (`Form.tokenInfo`) needs a non-enterable input, not a `text`
    object.

## Component contract findings

11. **Read `result()` before `dispose()`.** After the VersionLab's
    "dispose before completion" experiment the poll can see a result that
    is not an object at all; `Demo_PollTask` / `Demo_PollVersionTask` guard
    with `Value type($result)#Is object` and report a discarded result
    instead of dereferencing `.ok`.
12. **Invalid configuration surfaces immediately.** Validation happens at
    Task construction, so a bad issuer becomes a *done* Task with
    `invalid_configuration` -- a good interactive teaching moment in the
    Login lab, no polling needed.
13. **`takeAuthorizationURL()` is read-and-clear**, and completion clears
    the URL too. The URL lab keeps the finished Task (no auto-dispose)
    specifically so the second call can be demonstrated; disposal happens
    via a button or `On Unload`.
14. **`Client.compiled` mirrors `Is compiled mode`** -- displayed in the
    Version lab as acceptance evidence that the loaded component is real.
15. **Zip verification workflow**: `openid.zip` SHA256 matched
    `openid-signing.json` (`zip.sha256`), the extracted `oidc-cli` matched
    `preservedExternalCLI.sha256`, and Unix modes survived extraction
    (executable bit preserved). Symlink/traversal scan of all 29 entries:
    clean.

## Localisation

16. **Define project menu IDs instead of `Common*` when the language is
    chosen at runtime** -- built-in `Common*` entries ignore
    `SET DATABASE LOCALIZATION`. `menus.json` uses `Demo_Menu*` IDs.
17. **Multi-line XLIFF targets need `&#13;`**; a literal newline would be
    normalised to LF and 4D would not break the line.
18. The language dropdown names languages in their own language
    ("English" / "日本語") and is deliberately not localised.

## Skill-set gaps (PR candidates for `miyako/skills`)

19. The canonical `.gitignore` in `4dproject` has no `/Components/` entry
    for *host* projects that consume a component through
    `dependencies.json`; `dependencies.md` documents manual staging for
    tool4d but not the ignore rule. A fetched component is an artifact and
    must not be committed. (Submitted as `miyako/skills` PR #129.)

## Local run under 4D 21.2 LTS

20. **`FORM GET OBJECTS` takes arrays, not collections** -- passing
    collections raises error 52 ("An array was expected") per form. The
    form-load check (`Demo_FormLoadCheck`) now declares
    `ARRAY TEXT` / `ARRAY LONGINT` and reports object counts: Main 14,
    Login 26, VersionLab 11, ResultPages 20, URLCapture 15.
21. **A GUI 4D session does not re-read methods edited on disk after it
    started.** After fixing `Start.4dm` (the hub-reuse branch used a
    no-op `CALL FORM`/`SET WINDOW RECT` pair instead of
    `BRING TO FRONT(1)`), the running instance had to be restarted to pick
    the fix up.
22. **The Result pages lab needs its own idle timer policy.** The shared
    `Demo_PollTask` sets `SET TIMER(0)` when a task completes, which would
    freeze the UTF-8 byte counters; the form method re-arms `SET TIMER(30)`
    whenever the task slot is empty again.

## The XLIFF location trap (found by running the demo)

23. **XLIFF `.lproj` folders must live in `<database>/Resources/`, a
    sibling of `Project/` -- not inside `Project/Resources/`.** With the
    files under `Project/Resources/`, 4D loads no string tables at all:
    `Localized string` returns `""`, `:xliff:` references in form JSON and
    `menus.json` render as raw tokens, `SET WINDOW TITLE` receives `""`
    (the hub window opened untitled), and -- with no root `Resources/` at
    all -- `SET DATABASE LOCALIZATION` fails silently, so the localization
    stays the OS value (`en-gb` here). Moving the same files one level up
    fixed everything: the default localization resolved `en-gb` -> `en`,
    and every string resolved. Proven with a minimal `/tmp` probe project
    and then by the demo's hub window appearing titled "openid demo".
24. **`--dataless` tool4d can still load XLIFF** once the folder is in the
    right place, so `Demo_XliffCheck` (localized-string probe writing a
    JSON report) is a valid headless localization gate. The earlier
    ""-everywhere results were the wrong location, not a dataless
    limitation.
25. **Screen-forensics hazards while another session drives 4D:** a
    sibling session's capture instance (ldap-demo, 4D 21 R5 under
    `timeout`) kept raising a modal Syntax Error dialog
    (`Demo_FixtureCertPath` line 11: `Folder(Get 4D folder(Database
    folder))` -- "A valid posix path was expected"; `Get 4D folder`
    returns an HFS path, `Folder` wants POSIX) that overlapped this
    project's windows and poisoned OCR attribution. OCR + Vision via
    AppleScriptObjC (`VNRecognizeTextRequest`) worked well for reading
    4D's dialogs, which expose almost nothing through accessibility; map
    windows to owning PIDs via System Events `unix id` before believing
    any on-screen text belongs to your project.
