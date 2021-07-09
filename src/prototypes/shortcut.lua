local function shortcut_sprite(suffix, size)
  return {
    filename = "__core__/graphics/rename-"..suffix,
    priority = "extra-high-no-scale",
    size = size,
    scale = 1,
    mipmap_count = 0,
    flags = {"icon"}
  }
end

data:extend{
  {
    type = "shortcut",
    name = "ee-toggle-map-editor",
    icon = shortcut_sprite("normal.png", 32),
    small_icon = shortcut_sprite("small-black.png", 16),
    disabled_small_icon = shortcut_sprite("small-white.png", 16),
    action = "lua",
    associated_control_input = "ee-toggle-map-editor",
    toggleable = true
  }
}