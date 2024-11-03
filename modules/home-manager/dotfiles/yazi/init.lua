require("folder-rules"):setup()

-- [manager] - linemode
-- show size and mtime together
function Linemode:size_and_mtime()
  local time = (self._file.cha.mtime or 0) // 1            -- get file date
  time = time and os.date("%Y/%m/%d %H:%M:%S", time) or "" -- show date only when it has

  local size = self._file:size()                           -- get file size

  return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or '-', time))
end
