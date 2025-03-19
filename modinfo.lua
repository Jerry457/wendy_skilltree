name = "wendy-skilltree"  ---mod名字
version = "0.0.2" -- mod版本 上传mod需要两次的版本不一样
description = [[
]]  --mod描述
author = "" --作者

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. "-dev"
end

api_version = 10

dst_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "lilith"
}

configuration_options = {

}
