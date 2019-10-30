files = {}
for k, v in ipairs(arg) do
	if k > 0 then
		table.insert(files, v)
	end
end

if #files == 0 then
	print("No files to lint!")
	os.exit(1)
end

require('lib/isx')
require('lib/gmod')

require('lib/test/Test')
require('lib/test/Runner')