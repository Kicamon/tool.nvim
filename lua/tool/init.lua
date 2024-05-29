local tools = {
  'CodeRunning',
  'CursorWord',
  'CursorMove',
  'GetNode',
  'ImSwitch',
  'QuickSubstitute',
  'Ranger',
  'Surround',
  'TabToSpace',
  'Wiki',
  'Wildfire',
  'Chdir',
  'MdTableFormat',
  'Align',
  'MdPreview',
}

for _, v in ipairs(tools) do
  require('tool.' .. v)
end
