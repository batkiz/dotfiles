# -*- encoding: utf-8 -*-
# 用于分离 gif 图片所有帧

from PIL import Image
import os
import sys

if not sys.argv[1]:
    print('no input file.')
else:
    gifFileName = sys.argv[1]
    im = Image.open(gifFileName)
    layersDir = gifFileName[:4]
    os.mkdir(layersDir)

try:
    while True:
        # 保存当前帧图片
        current = im.tell()
        im.save(layersDir+'\\'+str(current)+'.png')
        # 获取下一帧图片
        im.seek(current+1)
except EOFError:
    pass
