local cels = app.range.cels
local xmax = 0
local ymax = 0
local xmin = 100000
local ymin = 100000
local processedImgs = 0
for key,value in ipairs(cels)
do
	processedImgs = processedImgs + 1
	if(value.bounds.width + value.position.x > xmax)
	then
		xmax = value.bounds.width + value.position.x
	end
	if(value.position.x < xmin)
	then
		xmin = value.position.x
	end
	if(value.bounds.height + value.position.y > ymax)
	then
		ymax = value.bounds.height + value.position.y
	end
	if(value.position.y < ymin)
	then
		ymin = value.position.y
	end
end

local img = Image(xmax - xmin, ymax - ymin)
local lastIndex = 0
local currentLowestIndex = 100000

while (processedImgs > 0)
do

currentLowestIndex = 100000

for key,value in ipairs(cels)
do
	layerIndex = value.layer.stackIndex
	if(layerIndex > lastIndex and layerIndex < currentLowestIndex)
	then
		currentLowestIndex = layerIndex
	end
end

lastIndex = currentLowestIndex
processedImgs = processedImgs - 1

for key,value in ipairs(cels)
do
	layerIndex = value.layer.stackIndex
	if(layerIndex == currentLowestIndex) 
	then
		pos = Point(value.position.x - xmin, value.position.y - ymin)
		for it in value.image:pixels() do
			pixelValue = it()
			alpha = app.pixelColor.rgbaA(pixelValue)
			if alpha > 0 then
				img:drawPixel(pos.x + it.x, pos.y + it.y, pixelValue)
			end
		end
	end
end

end

local dlg = Dialog("Save selected cels")
dlg:file{	id="save_loc",
		label="export cels to:",
		open=false,
		save=true,
		filetypes={"png","jpeg"}}

dlg:button{	id="ok", 
		text="&Export"}
dlg:button{	id="cancel", 
		text="&Cancel"}
dlg:show()

local data = dlg.data

if not data.ok then return end

img:saveAs(data.save_loc)
























