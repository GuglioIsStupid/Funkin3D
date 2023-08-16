# to-lua.py
# Script created by @Lumaah7 on Twitter
# Lumaah on GitHub
import xml.etree.ElementTree as ET
import sys

def get_animation_prefix(animation_name, prefixes_file):
    with open(prefixes_file, "r") as file:
        valid_prefixes = [line.strip() for line in file]

    for prefix in valid_prefixes:
        if prefix in animation_name.lower():
            return prefix
    return None

def convert_xml_to_lua(xml_file, lua_output_file, prefixes_file, image_path):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    lua_data = "return graphics.newSprite(\n"
    lua_data += f"\tlove.graphics.newImage(graphics.imagePath(\"{image_path}\")),\n"
    lua_data += "\t{\n"

    animation_data = {}
    frame_indices = {}

    for index, sub_texture in enumerate(root.findall(".//SubTexture")):
        name = sub_texture.get("name")
        x = float(sub_texture.get("x"))
        y = float(sub_texture.get("y"))
        width = float(sub_texture.get("width"))
        height = float(sub_texture.get("height"))
        offsetX = float(sub_texture.get("frameX", 0))
        offsetY = float(sub_texture.get("frameY", 0))
        offsetWidth = float(sub_texture.get("frameWidth", width))
        offsetHeight = float(sub_texture.get("frameHeight", height))

        animation_prefix = get_animation_prefix(name, prefixes_file)

        if animation_prefix is None:
            animation_prefix = name.split(" ")[-1]

        if animation_prefix not in frame_indices:
            frame_indices[animation_prefix] = {
                "start": index + 1,
                "stop": index + 1,
                "speed": 12,
                "offsetX": 0,
                "offsetY": 0
            }

        else:
            frame_indices[animation_prefix]["stop"] = index + 1

        lua_data += f"\t\t{{x = {x}, y = {y}, width = {width}, height = {height}, offsetX = {offsetX}, offsetY = {offsetY}, offsetWidth = {offsetWidth}, offsetHeight = {offsetHeight}}}, -- {name}\n"

    lua_data += "\t},\n"
    lua_data += "\t{\n"

    for anim_prefix, indices in frame_indices.items():
        lua_data += f"\t\t[\"{anim_prefix}\"] = {{start = {indices['start']}, stop = {indices['stop']}, speed = {indices['speed']}, offsetX = {indices['offsetX']}, offsetY = {indices['offsetY']}}},\n"

    lua_data += "\t},\n"
    lua_data += "\t\"i\",\n"  # Default animation name (can be changed)
    lua_data += "\tfalse\n"
    lua_data += ")"

    with open(lua_output_file, "w") as lua_file:
        lua_file.write(lua_data)

    print(f"Conversion complete. Output saved to '{lua_output_file}'")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python script.py input_xml_file output_lua_file animation_prefixes_file image_path")
    else:
        xml_file = sys.argv[1]
        lua_output_file = sys.argv[2] or sys.argv[1].replace(".xml", ".lua")
        prefixes_file = sys.argv[3] or "default_prefixes.txt"
        image_path = sys.argv[4] or "none"
        convert_xml_to_lua(xml_file, lua_output_file, prefixes_file, image_path)
