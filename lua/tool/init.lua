local tools = {
  'CodeRunning',
  'Cursor',
  'CursorWord',
  'GetNode',
  'ImSwitch',
  'QuickSubstitute',
  'Ranger',
  'Surround',
  'TabToSpace',
  'Wiki',
  'Wildfire',
  'Chdir',
}

for _, v in ipairs(tools) do
  require('tool.' .. v)
end
