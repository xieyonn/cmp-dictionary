---@class TrieNode
---@field children table<string, TrieNode>
---@field end_of_word boolean
local TrieNode = {}

---@return TrieNode
function TrieNode.new()
  return { children = {}, end_of_word = false }
end

---@class Trie
---@field root TrieNode
local Trie = {}

---@return Trie
function Trie.new()
  return setmetatable({
    root = TrieNode.new(),
  }, { __index = Trie })
end

---@param word string
function Trie:insert(word)
  local current = self.root
  for char in vim.gsplit(word, "") do
    local node = current.children[char] or TrieNode.new()
    current.children[char] = node
    current = node
  end
  current.end_of_word = true
end

---@param prefix string
---@param max_number_items number
---@return string[]
function Trie:search(prefix, max_number_items)
  local node = self.root
  for char in vim.gsplit(prefix, "") do
    node = node.children[char]
    if node == nil then
      return {}
    end
  end
  local word_list = {}

  local count = 0
  local stack = { { node = node, path = prefix } }
  while #stack > 0 and count <= max_number_items do
    local current = table.remove(stack)

    if current.node.end_of_word then
      table.insert(word_list, current.path)
      count = count + 1
    end

    for char, child in pairs(current.node.children) do
      table.insert(stack, {
        node = child,
        path = prefix .. char,
      })
    end
  end

  return word_list
end

return Trie
