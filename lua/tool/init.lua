local tools = {
  'CodeRunning',
  'Cursor',
  'GetNode',
  'ImSwitch',
  'QuickSubstitute',
  'Ranger',
  'Surround',
  'TabToSpace',
  'Wiki',
  'Wildfire',
}

for _, v in ipairs(tools) do
  require('tool.' .. v)
end
