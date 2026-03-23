# Funkin3D
3DS "Demake" of the game "Friday Night Funkin'"

# Porting Process

This port does quite a bit of compression to making sure this works on the 3ds

For sprites, a simple process is followed
- Rearrange the sprites w/ [FNF Spritesheet XML Generator](https://uncertainprod.github.io/FNF-Spritesheet-XML-generator-Web/) if it is a spritesheet and remove every second frame
- Resize sprites 0.33x w/ Kades [SarrowAtlasResizer](https://github.com/Kade-github/SparrowAtlasResizer) (Or gimp)

For audio, this ffmpeg arg is used:

`ffmpeg -i <source> -ar 22050 -q:a 3 <out>`