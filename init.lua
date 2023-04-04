---------- START FUNCTIONS ----------
function vim_profile()
	return os.getenv("VIM_PROFILE") or "default"
end

function last_used_vim_profile_path()
	local vimrc_directory = vimrc_directory()
	return vimrc_directory .. "last_used_vim_profile.txt"
end

function read_last_used_vim_profile()
	local vimrc_directory = vimrc_directory()
	local handle = io.open(last_used_vim_profile_path(), "r")
	if handle ~= nil then
		local last_used_vim_profile = handle:read("*line")
		handle:close()
		return last_used_vim_profile
	else
		return nil
	end
end

function update_last_used_vim_profile()
	io.output(last_used_vim_profile_path())
	io.write(vim_profile() .. "\n")
end


function vimrc_directory()
	local vimrc_path = os.getenv("MYVIMRC")
	local path_separator = package.config:sub(1,1) -- https://stackoverflow.com/a/14425862/7933478
	local index_of_last_path_separator = vimrc_path:len() - (vimrc_path:reverse():find(path_separator) - 1)
	return vimrc_path:sub(1, index_of_last_path_separator)
end
---------- END FUNCTIONS ----------

local last_used_vim_profile = read_last_used_vim_profile()
update_last_used_vim_profile()

if vim_profile() == "default" then
	require("profiles/default")
else
	require("profiles/".. vim_profile())
end
