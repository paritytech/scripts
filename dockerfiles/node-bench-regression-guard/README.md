# node-bench-regression-guard

This small utility is used as part of `substrate` pipeline for the perfomance regression detections.

### How it works

It processes JSON output of `substrate`'s `node-bench` benchmarks and compares the results. The utility exits with `1` when the difference between the benchmarks and their reference counterparts is twice or more.

### Usage

```
node-bench-regression-guard --help

Usage: node-bench-regression-guard [options]
        --reference DIRECTORY (current master)
        --compare-with DIRECTORY (merged PR branch)
        --comparison-threshold (optional, integer, defaults to 2)
```

### Testing

Just `bundle install && bundle exec ruby run-tests.rb`.

### Dependencies

The test script uses `faker` and `minitest` as the external dependencies. The main script (`node-bench-regression-guard`) is dependency-free and relies solely on Ruby's standard library.
