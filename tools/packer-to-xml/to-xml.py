import os, sys
import xml.etree.ElementTree as ET

# Packer atlas example layout:
"""
idle spirit_0 = 0 1028 128 128 # anim_name = x, y, w, h
idle spirit_1 = 0 1157 128 128
idle spirit_2 = 1542 0 128 128
idle spirit_3 = 643 900 128 128
spirit down_0 = 0 0 256 256
spirit down_1 = 257 0 256 256
spirit down_2 = 771 514 256 256

# etc...

"""
# conver to adobe animate xml format
"""
<TextureAtlas imagePath="filename.png">
    <!-- Created with Packer texture atlas generator-->
    <SubTexture name="idle spirit_0" x="0" y="1028" width="128" height="128"/>
    etc...
</TextureAtlas>
"""

def main():
    file = sys.argv[1]
    
    filename, file_extension = os.path.splitext(file)
    
    # create xml tree
    root = ET.Element("TextureAtlas")
    root.set("imagePath", filename + ".png")
    
    # read file
    with open(file, "r") as f:
        for line in f:
            # skip comments
            if line[0] == "#":
                continue
            
            # split line
            line = line.split("=")
            name = line[0].strip()
            data = line[1].strip().split(" ")
            
            # create subtexture
            subtexture = ET.SubElement(root, "SubTexture")
            subtexture.set("name", name)
            subtexture.set("x", data[0])
            subtexture.set("y", data[1])
            subtexture.set("width", data[2])
            subtexture.set("height", data[3])
            
    # write xml (pretty print with 4 spaces and newlines)
    tree = ET.ElementTree(root)
    tree.write(filename + ".xml", encoding="utf-8", xml_declaration=True, method="xml", default_namespace=None, short_empty_elements=True)
    
if __name__ == "__main__":
    main()