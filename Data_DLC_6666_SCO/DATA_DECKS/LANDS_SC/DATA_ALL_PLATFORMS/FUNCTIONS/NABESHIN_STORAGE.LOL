

dataStorage = {}

function Storage(obj)

if(dataStorage[obj] == nil) then
	local t = {};
	dataStorage[obj] = t;
end

local v = {};

v.push = function(value)
	local datatable = dataStorage[obj];
	local index = #datatable + 1;
	dataStorage[obj][index] = value;
end

v.get = function(ind)
	return dataStorage[obj][ind];
end

v.set = function(ind,value)
	dataStorage[obj][ind] = value;
end

v.erase = function(ind)
	table.remove(dataStorage[obj], ind);
end

v.count = function()
	local datatable = dataStorage[obj];
	return #datatable;
end

v.test = function(value)
	local index = 1;
	local datatable = dataStorage[obj];
	while index < (#datatable+1) do
		if datatable[index] == value then
			return index;
		end
		index = index+1;
	end
	return -1;
end

v.clear = function()
	local t = {};
	dataStorage[obj] = t;
end

return v;
end


