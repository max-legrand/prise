---@meta

---PTY size information
---@class PtySize
---@field rows integer Number of rows
---@field cols integer Number of columns
---@field width_px integer Width in pixels
---@field height_px integer Height in pixels

---Key data for send_key
---@class PtyKeyData
---@field key string The key character
---@field code? string The key code
---@field ctrl? boolean Ctrl modifier
---@field alt? boolean Alt modifier
---@field shift? boolean Shift modifier
---@field super? boolean Super/Cmd modifier
---@field release? boolean Key release event

---Mouse data for send_mouse
---@class PtyMouseData
---@field col? integer Column position
---@field row? integer Row position
---@field button? string Mouse button ("left", "right", "middle")
---@field action? string Mouse action ("press", "release", "move")
---@field ctrl? boolean Ctrl modifier
---@field alt? boolean Alt modifier
---@field shift? boolean Shift modifier

---PTY userdata representing a pseudo-terminal
---@class Pty
local Pty = {}

---Get the PTY's numeric ID
---@return integer
function Pty:id() end

---Get the PTY's title
---@return string
function Pty:title() end

---Get the current working directory
---@return string?
function Pty:cwd() end

---Get the PTY's size information
---@return PtySize
function Pty:size() end

---Send a key event
---@param key PtyKeyData
function Pty:send_key(key) end

---Send a mouse event
---@param mouse PtyMouseData
function Pty:send_mouse(mouse) end

---Send pasted text
---@param text string
function Pty:send_paste(text) end

---Set the focus state
---@param focused boolean
function Pty:set_focus(focused) end

---Close the PTY
function Pty:close() end

---Copy the current selection to clipboard
function Pty:copy_selection() end

---Capture the current pane content (triggers capture_pane_complete event)
function Pty:capture_pane() end

---Scroll the viewport by delta lines (positive=down, negative=up) or "top"/"bottom"
---@param delta integer|string Delta lines or "top"/"bottom"
function Pty:scroll_viewport(delta) end

---Set selection by viewport coordinates
---@param start_row integer
---@param start_col integer
---@param end_row integer
---@param end_col integer
function Pty:select_viewport(start_row, start_col, end_row, end_col) end

---Set selection by absolute screen coordinates (from top of scrollback).
---Unlike select_viewport, this allows the selection to span beyond the
---current viewport, which is needed for copying selections that extend
---into scrollback history.
---@param start_row integer
---@param start_col integer
---@param end_row integer
---@param end_col integer
function Pty:select_screen(start_row, start_col, end_row, end_col) end

---Clear the current selection
function Pty:clear_selection() end

---Get the text content of a viewport row
---@param row integer Row number (0-indexed)
---@return string
function Pty:get_viewport_text(row) end

---Get the terminal cursor position (from the front buffer)
---@return { row: integer, col: integer }
function Pty:cursor_position() end

---Set search highlight regions for rendering
---@param highlights { row: integer, col: integer, len: integer }[]
function Pty:set_search_highlights(highlights) end

---Clear all search highlight regions
function Pty:clear_search_highlights() end
