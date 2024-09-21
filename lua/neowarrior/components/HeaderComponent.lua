---@class HeaderComponent
local HeaderComponent = {}

--- Create a new HeaderComponent
---@return HeaderComponent
function HeaderComponent:new(tram)
    local header_component = {}
    setmetatable(header_component, self)
    self.__index = self

    self.tram = tram

    return self
end

--- Print header
function HeaderComponent:set()

  local nw = _Neowarrior
  local keys = nw.config.keys

  if nw.config.header.text then

    local header_text_color = "NeoWarriorTextInfo"
    local header_text_has_version = string.match(nw.config.header.text, "{version}")

    if header_text_has_version then

      if string.match(nw.version, "dev") then
        header_text_color = "NeoWarriorTextDanger"
      elseif string.match(nw.version, "pre") or string.match(nw.version, "alpha") or string.match(nw.version, "beta") then
        header_text_color = "NeoWarriorTextWarning"
      end

    end

    local header_text = nw.config.header.text:gsub("{version}", nw.version)
    self.tram:col(header_text, header_text_color)
    self.tram:into_line({})

  end

  if nw.config.header.enable_help_line then

    self.tram:col("(" .. keys.help .. ")help | ", "")
    self.tram:col("(" .. keys.add .. ")add | ", "")
    self.tram:col("(" .. keys.done .. ")done | ", "")
    self.tram:col("(" .. keys.filter .. ")filter", "")
    self.tram:into_line({
      meta = { action = 'help' }
    })

  end

  if nw.config.header.enable_current_report then

    self.tram:col("(" .. keys.select_report .. ")report: ", "")
    self.tram:col("Report: " .. nw.current_report, "NeoWarriorTextInfo")

    if nw.config.header.enable_current_view then
      if nw.current_mode == 'grouped' then
        self.tram:col(" (Grouped by project)", "")
      elseif nw.current_mode == 'tree' then
        self.tram:col(" (Tree view)", "")
      end
    end

    self.tram:into_line({
      meta = { action = 'report' }
    })

  end

  if nw.config.header.enable_current_filter then

    self.tram:col("(" .. keys.select_filter .. ")filter: ", "")
    self.tram:col(nw.current_filter, "NeoWarriorTextWarning")
    self.tram:into_line({
      meta = { action = 'filter' }
    })

  end

  self.tram:nl()

  return self
end

return HeaderComponent
