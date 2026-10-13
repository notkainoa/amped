# Releasing Amped

Pushing to `main` publishes a GitHub Release. That build is ad-hoc signed and
not notarized. People download the zip from the latest release, replace
`Amped.app`, and right-click → Open the first time.

Check for Updates asks GitHub for that release. When a newer version exists, it
opens the release page. It does not replace the app.

## What runs

| Workflow | Trigger | What it does |
| --- | --- | --- |
| `.github/workflows/ci.yml` | every push and pull request | Unsigned build; asserts the app icon is in the bundle. |
| `.github/workflows/release.yml` | every push to `main` | Same kind of build, zipped as `Amped-<version>.zip` and attached to a GitHub Release. |

The version is `MARKETING_VERSION` from `project.yml`, plus the Actions run
number. `1.0` in the project becomes `1.0.1`, then `1.0.2`, and so on. The tag
is `v1.0.1`. Change `MARKETING_VERSION` when you want the first two numbers to
move.

No Apple certificate, notarization secret, or Homebrew token is required.
Notarization stays a separate local step (`./notarize.sh`) for when a download
should open without the right-click.

## Ship a build

Merge or push to `main`. The release workflow builds on the `xcode-27` runner
and publishes the zip. The download is on the
[Releases page](https://github.com/notkainoa/amped/releases/latest).
