#!/usr/bin/env python3

# --------------------------------------------------------------------------------
# Friday Night Funkin' Rewritten Legacy XML Conversion Helper v1.2
#
# Copyright (C) 2021  HTV04
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------------

import os
import sys

import xml.etree.ElementTree as ET

import re, random

xmlname = os.path.split(sys.argv[1])[1]
sheetxml = ET.parse(xmlname).getroot()

imgFile = sheetxml.attrib.get('imagePath', '')

animLists = {}

lua = ('return graphics.newSprite(\n'
       f'\tgraphics.imagePath("{imgFile.replace(".png", "")}"),\n'
       '\t{\n'
       )
c = 0
for SubTexture in sheetxml.findall('SubTexture'):
    c += 1

    name = SubTexture.get('name')
    x = SubTexture.get('x')
    y = SubTexture.get('y')
    width = SubTexture.get('width')
    height = SubTexture.get('height')
    offsetx = SubTexture.get('frameX')
    offsety = SubTexture.get('frameY')
    offsetWidth = SubTexture.get('frameWidth')
    offsetHeight = SubTexture.get('frameHeight')
    rotated = SubTexture.get('rotated')

    if offsetx is None:
        offsetx = '0'
    if offsety is None:
        offsety = '0'
    if offsetWidth is None:
        offsetWidth = '0'
    if offsetHeight is None:
        offsetHeight = '0'
    if rotated is None:
        rotated = 'false'

    lua += '\t\t{x = ' + x + ', y = ' + y + ', width = ' + width + ', height = ' + height + ', offsetX = ' + offsetx + ', offsetY = ' + offsety + ', offsetWidth = ' + offsetWidth + ', offsetHeight = ' + offsetHeight + ', rotated = ' + rotated + '}, -- ' + str(c) + ': ' + name + '\n'

    realName = re.sub(r'\d+$', '', name)

    if realName in animLists:
        curAnim = animLists[realName]
    else:
        curAnim = {}
        animLists[realName] = curAnim
        curAnim["start"] = str(c) 

    curAnim["stop"] = str(c)
    curAnim["speed"] = str(24)
    curAnim["offsetX"] = str(0)
    curAnim["offsetY"] = str(0)
    curAnim["name"] = realName

lua += '\t},\n'

lua += "\t{\n"

for animName, animData in animLists.items():
    lua += '\t\t["' + animData["name"] + '"] = {start = ' + str(animData["start"]) + ', stop = ' + str(animData['stop']) + ', speed = ' + str(animData["speed"]) + ', offsetX = ' + str(animData["offsetX"]) + ', offsetY = ' + str(animData["offsetY"]) + '},\n'

lua += '\t},\n'

lua += f'\t"{random.choice(list(animLists.values()))["name"]}",\n'
lua += f'\tfalse\n'

lua += ")"

# remove .xml from xmlname
luaFile = xmlname.replace('.xml', '') + '.lua'

with open(luaFile, 'w') as f:
    f.write(lua)