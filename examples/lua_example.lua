-- find a value in a list
local found = nil
for i=1,a.n do
	if a[i] == value then
		found = i      -- save value of `i', and other comments that force linebreak
	break
	end
end
print(found)
