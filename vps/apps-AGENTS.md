# VPS app root

These are deploy checkouts; GitHub is the source of truth.

- Keep trees clean; update with fetch plus fast-forward-only, then restart the service.
- Commit and push VPS edits; never leave uncommitted drift.
- Use `github-personal` remotes; plain `github.com` is limited here.
- Do not accept rsync/scp overwrites of tracked code; only secrets and data.
- Runtime/third-party dirs (`fousekis-api`, goatcounter, karakeep/guacamole) have no git workflow.

This file is versioned in the configs repo (`vps/apps-AGENTS.md`) and deployed by
`vps/deploy-vps.sh` — edit it there, not here.

## Automated deploys (push to main)

- Each git repo has a `Deploy to VPS` GitHub workflow: on push to main it SSHs in as `deployer` and runs `/home/diab/bin/vps-deploy.sh <service>` (absolute path, pinned action, 30m timeout, per-service concurrency).
- The helper serializes on a flock, requires a clean tree on the default branch, fetches (read-only token over https) plus fast-forward-only merge, then restarts per the map: compose rebuild (ai-cookbook, mp3podcasts, onyx, redact_pdf, greek_embassy_bot), compose pull (note-sx), npm build plus service restart (tfl), fousekis-api restart (fousekis), venv smoke check (fastmailai), quartz build (notes), nothing (personal_website).
- Restarts run under a shutdown inhibit (`/usr/local/sbin/vps-deploy-inhibit`) so the nightly OS reboot waits for deploys.
- SSH is confined: the deploy key lives only in deployer's `authorized_keys` behind the forced-command gate (`/usr/local/sbin/vps-deploy-ssh-gate`); deployer sudo is limited to the inhibit wrapper plus `systemctl restart` for tfl and fousekis-api. Per-repo secrets are `VPS_HOST` / `VPS_USER` / `VPS_SSH_KEY`.

## OS auto-updates

- `unattended-upgrades` installs updates from the base, security and ESM pockets with an automatic reboot at 03:30 (`/etc/apt/apt.conf.d/50unattended-upgrades` plus `51-vps-auto-updates`).
- Both files are versioned in the configs repo and installed by `vps/deploy-vps.sh`; edit them there. `50-` carries the allowed origins, `51-` adds the reboot window, `Automatic-Reboot-WithUsers "true"` and kernel cleanup.
- A reboot is cut short of an in-flight deploy by the `vps-deploy-inhibit` shutdown inhibit.

## Weekly upkeep (com.diab.sync-vps deploys these; timers are user units)

- `~/bin/vps-cleanup.sh` — Sunday 04:30: trims the Docker build cache to a 3 GB ceiling, removes images no container uses except the protected build bases (the Playwright image greek_embassy_bot builds from), clears runner/npm/apt caches and old kernels, caps the journal. `--dry-run` prints without changing anything. Log: `~/logs/vps-cleanup.log`.
- `~/bin/vps-update-images.sh` — Sunday 05:30: pulls and recreates only the third-party-image projects (note-sx, karakeep-app), taking the same `~/.cache/vps-deploy.lock` as `vps-deploy.sh`, snapshotting their data into `~/backups/<app>/` (3 generations) and rolling the image tags back if a project is unhealthy afterwards. Log: `~/logs/vps-update-images.log`.
- `herdr-server.service` — keeps the headless Herdr server running across reboots.
- Locally built images and the `deploy.sh`-managed nginx step are never touched by the weekly jobs; they belong to the push path.
