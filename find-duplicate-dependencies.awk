#!/usr/bin/env -S awk -E
# Find duplicate dependencies in a Cargo.lock file
function do_substr(str, len, end) {
   return substr(str, len + 1, length(str) - len - end)
}
function assert(cond, msg) {
   if (!cond) {
      print msg > "/dev/stderr"
      exit 2
   }
}
BEGIN {
   num_duplicates = 0
   for (i = 1; i < ARGC; ++i) {
      if (ARGV[i] !~ /^[/.]/) {
         ARGV[i] = "./" ARGV[i]
      }
   }
}
/^name = "[[:alnum:]_-]+"$/ {
   pkg_name = do_substr($0, 8, 1)
   line_num = NR
   next
}
/^version = "[0-9]+\.[0-9]+\.[0-9]+([+-][[:alnum:]_.-]*)?"$/ {
   version = do_substr($0, length("version = \""), 1)
   assert(NR == line_num + 1, "Found version line at wrong time?")
   line_num = 0
   if (pkg_name in versions && versions[pkg_name] != version) {
      print ("Duplicate package " pkg_name ": found versions " versions[pkg_name] " and " version)
      num_duplicates += 1
   }
   versions[pkg_name] = version
   next
}
{ assert(!line_num, "missing version line " NR) }
END {
   if (num_duplicates) {
      print "\033[1;31mFound", num_duplicates, "duplicate dependencies 😨\033[0m"
      exit 1
   } else {
      print "\033[1;32mYou only depend on one version of each dependency. Yay! 🙂\033[0m"
   }
}
