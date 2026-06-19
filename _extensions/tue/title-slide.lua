local function stringify_meta(value)
  if not value then
    return ""
  end

  if value.t == "MetaInlines" or value.t == "MetaBlocks" then
    return pandoc.utils.stringify(value)
  end

  if value.t == "MetaString" then
    return value.text
  end

  if value.t == "MetaList" then
    local parts = {}
    for _, item in ipairs(value) do
      local text = stringify_meta(item)
      if text ~= "" then
        table.insert(parts, text)
      end
    end
    return table.concat(parts, " · ")
  end

  if value.t == "MetaMap" then
    if value.name then
      return stringify_meta(value.name)
    end
    return pandoc.utils.stringify(value)
  end

  return pandoc.utils.stringify(value)
end

local function escape_markdown(text)
  local escaped = text
  escaped = escaped:gsub("\\", "\\\\")
  escaped = escaped:gsub("([%[%]%*_%`])", "\\%1")
  return escaped
end

local function ensure_header_includes(meta)
  local includes = meta["header-includes"]
  if not includes then
    includes = pandoc.MetaList({})
    meta["header-includes"] = includes
  elseif includes.t ~= "MetaList" then
    includes = pandoc.MetaList({ includes })
    meta["header-includes"] = includes
  end
  return includes
end

function Pandoc(doc)
  local meta = doc.meta
  local title = stringify_meta(meta.title)
  local subtitle = stringify_meta(meta.subtitle)
  local author = stringify_meta(meta.author)
  local date = stringify_meta(meta.date)
  local cover_image = stringify_meta(meta["tue-cover-image"])
  local cover_logo = stringify_meta(meta["tue-cover-logo"])
  local bar_opacity = stringify_meta(meta["tue-cover-bar-opacity"])
  local slide_bg = stringify_meta(meta["tue-slide-bg"])
  local content_padding = stringify_meta(meta["tue-content-slide-padding"])
  local short_title = stringify_meta(meta["tue-short-title"])
  local footer_logo = stringify_meta(meta["tue-footer-logo"])

  if title == "" then
    return doc
  end

  -- Prevent Quarto's built-in title slide from being emitted; we render our own.
  doc.meta["title-slide"] = pandoc.MetaBool(false)
  doc.meta["title"] = nil
  doc.meta["subtitle"] = nil
  doc.meta["author"] = nil
  doc.meta["date"] = nil
  doc.meta["pagetitle"] = pandoc.MetaString(title)

  if cover_image == "" then
    cover_image = "assets/tue-cover-background.jpg"
  end

  if cover_logo == "" then
    cover_logo = "assets/tue-logo-white.png"
  end

  if bar_opacity == "" then
    bar_opacity = "0.85"
  end

  if slide_bg == "" then
    slide_bg = "#f3efef"
  end

  if content_padding == "" then
    content_padding = "30px 58px"
  end

  if footer_logo == "" then
    footer_logo = "assets/tue-logo-scarlet.png"
  end

  -- Build the persistent slide footer HTML via JS.
  -- (Quarto processes the `footer` metadata key before Lua filters run, so
  -- setting doc.meta["footer"] has no effect. We populate the footer div at
  -- runtime with a small DOMContentLoaded script instead.)
  local footer_left = short_title ~= "" and
    string.format('<span class=\\"tue-footer-title\\">%s</span>', short_title) or ""
  local footer_right = string.format(
    '<img src=\\"%s\\" class=\\"tue-footer-logo\\" alt=\\"TU/e\\">',
    footer_logo
  )
  local footer_html = string.format(
    '<div class=\\"tue-footer-inner\\">%s%s</div>',
    footer_left, footer_right
  )
  local footer_js = string.format(
    "<script>document.addEventListener('DOMContentLoaded',function(){" ..
    "var f=document.querySelector('.footer.footer-default');" ..
    "if(f){f.innerHTML=\"%s\";}" ..
    "function tueSyncFooter(){" ..
    "var s=document.querySelector('.reveal .slides .present');" ..
    "var r=document.querySelector('.reveal');" ..
    "if(r)r.classList.toggle('tue-on-cover',!!(s&&s.classList.contains('tue-cover-slide')));" ..
    "}" ..
    "document.addEventListener('revealjsloaded',function(){" ..
    "Reveal.on('slidechanged',tueSyncFooter);" ..
    "Reveal.on('ready',tueSyncFooter);" ..
    "});" ..
    "});</script>",
    footer_html
  )

  local meta_line = subtitle
  if date ~= "" then
    if meta_line ~= "" then
      meta_line = meta_line .. " | " .. date
    else
      meta_line = date
    end
  end

  -- The background-image URL must live in a <style> block inside the HTML so that
  -- relative URLs resolve against the HTML file, not the external CSS file.
  -- The gradient layer paints the bottom 10% with the slide background colour,
  -- so the photo naturally stops at 90% without needing a DOM overlay.
  local css_override = string.format(
    "<style>" ..
    ":root{--tue-slide-bg:%s;--tue-cover-bar-opacity:%s;--tue-content-slide-padding:%s;}" ..
    "</style>",
    slide_bg, bar_opacity, content_padding
  )

  local header_includes = ensure_header_includes(doc.meta)
  table.insert(header_includes, pandoc.MetaBlocks({ pandoc.RawBlock("html", css_override) }))
  table.insert(header_includes, pandoc.MetaBlocks({ pandoc.RawBlock("html", footer_js) }))

  -- Logo and panel are direct children of the section so that
  -- left:0 / right:0 are unambiguously relative to the section (= full slide width).
  local markdown = table.concat({
    "## {.tue-cover-slide data-background-image=\"" .. cover_image .. "\" data-background-size=\"cover\" data-background-position=\"center top\" data-background-transition=\"zoom\"}",
    "",
    "::: {.tue-cover-logo}",
    "![]("
      .. cover_logo
      .. "){fig-alt=\"TU/e logo\"}",
    ":::",
    "",
    "::: {.tue-cover-panel}",
    "::: {.tue-cover-title}",
    escape_markdown(title),
    ":::",
    "",
    meta_line ~= "" and "::: {.tue-cover-meta}\n" .. escape_markdown(meta_line) .. "\n:::" or "",
    "",
    author ~= "" and "::: {.tue-cover-authors}\n" .. escape_markdown(author) .. "\n:::" or "",
    ":::",
    ""
  }, "\n")

  local cover_blocks = pandoc.read(markdown, "markdown").blocks
  for index = #cover_blocks, 1, -1 do
    table.insert(doc.blocks, 1, cover_blocks[index])
  end

  return doc
end
