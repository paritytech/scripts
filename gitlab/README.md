# GitLab scripts

This is the collection of small GitLab-related scripts written in Ruby.

### Table of contents

| Name | Usage |
| ---- | ----- |
| `get-all-mirrored-projects` | Outputs all mirrored projects within user's authz scope. Needs `GITLAB_INSTANCE` & `GITLAB_TOKEN` env vars. Accepts optional `with-vanity` and `without-vanity` arguments to filter projects with/without `vanity-service` integration. Accepts optional `github` to filter projects with enabled GitHub integration.
| `get-all-projects-with-pages` | Outputs all projects with GitLab Pages enabled within user's authz scope. Needs `GITLAB_INSTANCE` & `GITLAB_TOKEN` env vars.


### Examples

Get maximum info from `get-all-mirrored-projects`:
```
env GITLAB_INSTANCE=https://gitlab.example.com GITLAB_TOKEN=foobarbaz ./get-all-mirrored-projects with-vanity without-vanity github
```

### Dependencies

Dependencies are declared in the relevant `Gemfile`. Just `bundle install` and you are good to go.
