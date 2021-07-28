# GitLab scripts

This is the collection of small GitLab-related scripts written in Ruby.

### Table of contents

| Name | Usage |
| ---- | ----- |
| `get-all-mirrored-projects` | Outputs all mirrored projects within user's authz scope. Needs `GITLAB_INSTANCE` & `GITLAB_TOKEN` env vars. Accepts optional `with-vanity` and `without-vanity` arguments to filter projects with/without `vanity-service` integration. Accepts optional `github` to filter projects with enabled GitHub integration.
| `get-all-projects-with-pages` | Outputs all projects with GitLab Pages enabled within user's authz scope. Needs `GITLAB_INSTANCE` & `GITLAB_TOKEN` env vars. Accepts optional `public` argument to filter projects with public Pages access level.
| `wipe-inactive-runners` | Delete runners that never contacted a GitLab instance. User has to be an admin. Needs `GITLAB_INSTANCE` & `GITLAB_TOKEN` env vars. Check available options with `./wipe-inactive-runners --help`. Highly recommended to check what you are going to delete first with `--dry-run` flag.

### Examples

Get maximum info from `get-all-mirrored-projects`:
```
env GITLAB_INSTANCE=https://gitlab.example.com GITLAB_TOKEN=foobarbaz ./get-all-mirrored-projects with-vanity without-vanity github
```

Show projects with public Pages from `get-all-projects-with-pages`:
```
env GITLAB_INSTANCE=https://gitlab.example.com GITLAB_TOKEN=foobarbaz ./get-all-projects-with-pages public
```

Show dummy runners without their removal with `wipe-inactive-runners`:
```
env GITLAB_INSTANCE=https://gitlab.example.com GITLAB_TOKEN=foobarbaz ./wipe-inactive-runners --tag somerunnertag --dry-run
```

### Dependencies

Dependencies are declared in the relevant `Gemfile`. Just `bundle install` and you are good to go.
