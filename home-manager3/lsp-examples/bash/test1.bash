#!/usr/bin/env bash
# Test script for bash-language-server (bashls) features.

# Global variable
MY_VAR="hello world"

# 1. Check Function Definition and References
function my_function() {
  local count=0

  # A simple loop
  for i in {1..5}; do
    count=$((count + 1))
  done

  # 2. Check ShellCheck (SC) diagnostics: Using echo without quotes (SC2086)
  echo $MY_VAR
}

# 3. Check Explainshell/Documentation on Hover
function cleanup() {
  # The 'find' command should show documentation on hover
  find . -type f -name "*.log" -delete

  # Check for process management (should show documentation)
  ps -ef | grep "test_bashls"
}

# 4. Check Completion
# When typing: 'my_f' below, bashls should suggest 'my_function'
# Uses blink.cmp (see plugins.lua)  ["<C-n>"] = { "select_and_accept" },
my_function
