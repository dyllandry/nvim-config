local vim_profile = os.getenv("VIM_PROFILE")
if vim_profile ~= nil then
	print("loading profile: "..vim_profile)
	require("profiles/"..vim_profile)
else
	print("loading default profile")
	require("profiles/default")
end

