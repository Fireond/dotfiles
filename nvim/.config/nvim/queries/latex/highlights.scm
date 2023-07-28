;; extends
((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @text.strong))
  (#match? @_name "^(\\\\vb)$"))
